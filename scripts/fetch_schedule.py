#!/usr/bin/env python3
"""
Fetch complete Milano Cortina 2026 schedule from olympics.com

Extracts schedule data from __NEXT_DATA__ JSON embedded in daily schedule pages.
Outputs unified JSON with all events across all competition days.
"""

import json
import re
import time
from datetime import datetime
from pathlib import Path
import httpx

# Competition dates: Feb 4-22, 2026
DAYS = [
    "04-feb", "05-feb", "06-feb", "07-feb", "08-feb", "09-feb", "10-feb",
    "11-feb", "12-feb", "13-feb", "14-feb", "15-feb", "16-feb", "17-feb",
    "18-feb", "19-feb", "20-feb", "21-feb", "22-feb"
]

BASE_URL = "https://www.olympics.com/en/milano-cortina-2026/schedule"
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

# Output paths
SCRIPT_DIR = Path(__file__).parent
OUTPUT_DIR = SCRIPT_DIR.parent / "data"
OUTPUT_FILE = OUTPUT_DIR / "schedule.json"


def fetch_day_schedule(client: httpx.Client, day: str) -> dict | None:
    """Fetch schedule for a single day."""
    url = f"{BASE_URL}/{day}"
    print(f"  Fetching {day}...", end=" ", flush=True)

    try:
        response = client.get(url)
        response.raise_for_status()

        # Extract __NEXT_DATA__ JSON
        match = re.search(
            r'<script id="__NEXT_DATA__"[^>]*>([^<]+)</script>',
            response.text
        )
        if not match:
            print("ERROR: No __NEXT_DATA__ found")
            return None

        data = json.loads(match.group(1))
        page_items = data.get("props", {}).get("pageProps", {}).get("page", {}).get("items", [])

        # Find scheduleList module
        for item in page_items:
            if item.get("name") == "scheduleList":
                schedule_data = item.get("data", {})
                schedules = schedule_data.get("schedules", [])

                # Count events
                total_units = sum(len(s.get("units", [])) for s in schedules)
                print(f"OK ({total_units} events)")

                return {
                    "day": schedule_data.get("activeDay"),
                    "schedules": schedules,
                    "disciplines": schedule_data.get("disciplines", []),
                }

        print("ERROR: No scheduleList found")
        return None

    except httpx.HTTPError as e:
        print(f"ERROR: {e}")
        return None
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON - {e}")
        return None


def extract_events(day_data: dict) -> list[dict]:
    """Extract flat list of events from day schedule data."""
    events = []

    for schedule in day_data.get("schedules", []):
        discipline = schedule.get("discipline", {})

        for unit in schedule.get("units", []):
            venue = unit.get("venue", {})
            location = unit.get("location", {})
            match_info = unit.get("match")

            event = {
                # Core identifiers
                "event_id": unit.get("unitCode"),
                "session_code": unit.get("sessionCode"),

                # Sport/discipline
                "sport_code": discipline.get("disciplineCode"),
                "sport": discipline.get("description"),

                # Event details
                "event_name": unit.get("description"),
                "is_medal_event": unit.get("medal") == "1",
                "is_training": unit.get("isTraining", False),

                # Timing
                "date": day_data.get("day"),
                "start_time": unit.get("localStartDateTime"),
                "end_time": unit.get("localEndDateTime"),
                "start_utc": unit.get("startDateTimeUtc"),
                "end_utc": unit.get("endDateTimeUtc"),
                "estimated": unit.get("estimated", False),

                # Venue
                "venue_code": venue.get("venueCode"),
                "venue": venue.get("description"),
                "venue_slug": venue.get("venueSlug"),
                "location": location.get("locationName"),
                "location_code": location.get("locationCode"),

                # Match info (for team sports)
                "match": {
                    "team1": match_info.get("team1") if match_info else None,
                    "team2": match_info.get("team2") if match_info else None,
                } if match_info else None,

                # Ticketing
                "ticketing_url": unit.get("ticketingUrl") or None,

                # Status (will be updated during games)
                "status": "scheduled",
            }

            events.append(event)

    return events


def main():
    print("=" * 60)
    print("Milano Cortina 2026 Schedule Fetcher")
    print("=" * 60)
    print()

    # Ensure output directory exists
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    events_by_id: dict[str, dict] = {}  # Deduplicate by event_id
    all_disciplines = []
    failed_days = []

    with httpx.Client(
        headers={"User-Agent": USER_AGENT},
        timeout=30.0,
        follow_redirects=True,
    ) as client:

        print(f"Fetching {len(DAYS)} competition days...")
        print()

        for i, day in enumerate(DAYS, 1):
            print(f"[{i:2}/{len(DAYS)}]", end=" ")

            day_data = fetch_day_schedule(client, day)

            if day_data:
                events = extract_events(day_data)
                # Deduplicate: same event appears on multiple day pages
                for event in events:
                    event_id = event["event_id"]
                    if event_id not in events_by_id:
                        events_by_id[event_id] = event

                # Collect disciplines (first day only)
                if not all_disciplines and day_data.get("disciplines"):
                    all_disciplines = day_data["disciplines"]
            else:
                failed_days.append(day)

            # Be polite - small delay between requests
            if i < len(DAYS):
                time.sleep(0.5)

    all_events = list(events_by_id.values())

    print()
    print("=" * 60)
    print("Summary")
    print("=" * 60)
    print(f"Total events fetched: {len(all_events)}")
    print(f"Medal events: {sum(1 for e in all_events if e['is_medal_event'])}")
    print(f"Training sessions: {sum(1 for e in all_events if e['is_training'])}")
    print(f"Competition events: {sum(1 for e in all_events if not e['is_training'])}")

    if failed_days:
        print(f"Failed days: {', '.join(failed_days)}")

    # Group by sport
    print()
    print("Events by sport:")
    sports = {}
    for event in all_events:
        sport = event.get("sport", "Unknown")
        sports[sport] = sports.get(sport, 0) + 1
    for sport, count in sorted(sports.items(), key=lambda x: -x[1]):
        print(f"  {sport}: {count}")

    # Build output
    output = {
        "meta": {
            "fetched_at": datetime.utcnow().isoformat() + "Z",
            "source": "olympics.com",
            "edition": "OG2026",
            "total_events": len(all_events),
            "competition_days": len(DAYS),
            "days_fetched": len(DAYS) - len(failed_days),
        },
        "disciplines": all_disciplines,
        "events": all_events,
    }

    # Save to file
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)

    print()
    print(f"Saved to: {OUTPUT_FILE}")
    print(f"File size: {OUTPUT_FILE.stat().st_size / 1024:.1f} KB")


if __name__ == "__main__":
    main()
