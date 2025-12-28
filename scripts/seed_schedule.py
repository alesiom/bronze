"""
Generate realistic mock schedule data for Milano Cortina 2026.

Based on actual Games structure:
- Feb 4-22, 2026 (competitions Feb 4, ceremonies Feb 6 & 22)
- 16 sports across 8 venue clusters
- ~300 medal events
"""

import json
from datetime import datetime, timedelta
from pathlib import Path
import random

# Sports with their event types
SPORTS = {
    "ALP": {
        "name": "Alpine Skiing",
        "venue": "Stelvio Ski Centre",
        "city": "Bormio",
        "events": [
            ("Men's Downhill", True),
            ("Women's Downhill", True),
            ("Men's Super-G", True),
            ("Women's Super-G", True),
            ("Men's Giant Slalom", True),
            ("Women's Giant Slalom", True),
            ("Men's Slalom", True),
            ("Women's Slalom", True),
            ("Men's Combined", True),
            ("Women's Combined", True),
            ("Mixed Team Parallel", True),
        ]
    },
    "BTH": {
        "name": "Biathlon",
        "venue": "Anterselva Biathlon Arena",
        "city": "Anterselva",
        "events": [
            ("Men's 10km Sprint", True),
            ("Women's 7.5km Sprint", True),
            ("Men's 20km Individual", True),
            ("Women's 15km Individual", True),
            ("Men's 12.5km Pursuit", True),
            ("Women's 10km Pursuit", True),
            ("Men's 15km Mass Start", True),
            ("Women's 12.5km Mass Start", True),
            ("Men's 4x7.5km Relay", True),
            ("Women's 4x6km Relay", True),
            ("Mixed Relay", True),
        ]
    },
    "BOB": {
        "name": "Bobsleigh",
        "venue": "Cortina Sliding Centre",
        "city": "Cortina d'Ampezzo",
        "events": [
            ("Two-Man Heat 1", False),
            ("Two-Man Heat 2", False),
            ("Two-Man Heat 3", True),
            ("Two-Man Heat 4", True),
            ("Two-Woman Heat 1", False),
            ("Two-Woman Heat 2", False),
            ("Two-Woman Heat 3", True),
            ("Two-Woman Heat 4", True),
            ("Four-Man Heat 1", False),
            ("Four-Man Heat 2", False),
            ("Four-Man Heat 3", True),
            ("Four-Man Heat 4", True),
            ("Monobob Heat 1", False),
            ("Monobob Heat 2", False),
            ("Monobob Heat 3", True),
            ("Monobob Heat 4", True),
        ]
    },
    "CCS": {
        "name": "Cross-Country Skiing",
        "venue": "Tesero Cross-Country Skiing Stadium",
        "city": "Tesero",
        "events": [
            ("Men's 15km + 15km Skiathlon", True),
            ("Women's 7.5km + 7.5km Skiathlon", True),
            ("Men's Sprint Free", True),
            ("Women's Sprint Free", True),
            ("Men's 15km Classic", True),
            ("Women's 10km Classic", True),
            ("Men's Team Sprint", True),
            ("Women's Team Sprint", True),
            ("Men's 4x10km Relay", True),
            ("Women's 4x5km Relay", True),
            ("Men's 50km Mass Start Free", True),
            ("Women's 30km Mass Start Free", True),
        ]
    },
    "CUR": {
        "name": "Curling",
        "venue": "Cortina Curling Olympic Stadium",
        "city": "Cortina d'Ampezzo",
        "events": [
            ("Mixed Doubles Round Robin", False),
            ("Mixed Doubles Semifinal", False),
            ("Mixed Doubles Bronze Medal", True),
            ("Mixed Doubles Gold Medal", True),
            ("Men's Round Robin", False),
            ("Women's Round Robin", False),
            ("Men's Semifinal", False),
            ("Women's Semifinal", False),
            ("Men's Bronze Medal", True),
            ("Women's Bronze Medal", True),
            ("Men's Gold Medal", True),
            ("Women's Gold Medal", True),
        ]
    },
    "FSK": {
        "name": "Figure Skating",
        "venue": "Milano Ice Skating Arena",
        "city": "Milano",
        "events": [
            ("Team Event Short Program", False),
            ("Team Event Free Skating", True),
            ("Men's Short Program", False),
            ("Men's Free Skating", True),
            ("Women's Short Program", False),
            ("Women's Free Skating", True),
            ("Pairs Short Program", False),
            ("Pairs Free Skating", True),
            ("Ice Dance Rhythm Dance", False),
            ("Ice Dance Free Dance", True),
            ("Exhibition Gala", False),
        ]
    },
    "FRS": {
        "name": "Freestyle Skiing",
        "venue": "Livigno Snow Park",
        "city": "Livigno",
        "events": [
            ("Men's Moguls Qualification", False),
            ("Men's Moguls Final", True),
            ("Women's Moguls Qualification", False),
            ("Women's Moguls Final", True),
            ("Men's Aerials Qualification", False),
            ("Men's Aerials Final", True),
            ("Women's Aerials Qualification", False),
            ("Women's Aerials Final", True),
            ("Mixed Team Aerials", True),
            ("Men's Ski Cross Seeding", False),
            ("Men's Ski Cross Finals", True),
            ("Women's Ski Cross Seeding", False),
            ("Women's Ski Cross Finals", True),
            ("Men's Halfpipe Qualification", False),
            ("Men's Halfpipe Final", True),
            ("Women's Halfpipe Qualification", False),
            ("Women's Halfpipe Final", True),
            ("Men's Slopestyle Qualification", False),
            ("Men's Slopestyle Final", True),
            ("Women's Slopestyle Qualification", False),
            ("Women's Slopestyle Final", True),
            ("Men's Big Air Qualification", False),
            ("Men's Big Air Final", True),
            ("Women's Big Air Qualification", False),
            ("Women's Big Air Final", True),
        ]
    },
    "IHO": {
        "name": "Ice Hockey",
        "venue": "Milano Santagiulia Ice Hockey Arena",
        "city": "Milano",
        "events": [
            ("Men's Preliminary Round", False),
            ("Women's Preliminary Round", False),
            ("Men's Qualification Playoff", False),
            ("Women's Qualification Playoff", False),
            ("Men's Quarterfinal", False),
            ("Women's Quarterfinal", False),
            ("Men's Semifinal", False),
            ("Women's Semifinal", False),
            ("Women's Bronze Medal Game", True),
            ("Women's Gold Medal Game", True),
            ("Men's Bronze Medal Game", True),
            ("Men's Gold Medal Game", True),
        ]
    },
    "LUG": {
        "name": "Luge",
        "venue": "Cortina Sliding Centre",
        "city": "Cortina d'Ampezzo",
        "events": [
            ("Men's Singles Run 1", False),
            ("Men's Singles Run 2", False),
            ("Men's Singles Run 3", True),
            ("Men's Singles Run 4", True),
            ("Women's Singles Run 1", False),
            ("Women's Singles Run 2", False),
            ("Women's Singles Run 3", True),
            ("Women's Singles Run 4", True),
            ("Doubles Run 1", False),
            ("Doubles Run 2", True),
            ("Team Relay", True),
        ]
    },
    "NCB": {
        "name": "Nordic Combined",
        "venue": "Predazzo Ski Jumping Stadium",
        "city": "Predazzo",
        "events": [
            ("Individual Normal Hill/10km", True),
            ("Individual Large Hill/10km", True),
            ("Team Large Hill/4x5km", True),
        ]
    },
    "STK": {
        "name": "Short Track Speed Skating",
        "venue": "Milano Ice Skating Arena",
        "city": "Milano",
        "events": [
            ("Men's 1000m Heats", False),
            ("Men's 1000m Quarterfinal", False),
            ("Men's 1000m Semifinal", False),
            ("Men's 1000m Final", True),
            ("Women's 1000m Heats", False),
            ("Women's 1000m Quarterfinal", False),
            ("Women's 1000m Semifinal", False),
            ("Women's 1000m Final", True),
            ("Men's 500m Heats", False),
            ("Men's 500m Quarterfinal", False),
            ("Men's 500m Final", True),
            ("Women's 500m Heats", False),
            ("Women's 500m Quarterfinal", False),
            ("Women's 500m Final", True),
            ("Men's 1500m Heats", False),
            ("Men's 1500m Semifinal", False),
            ("Men's 1500m Final", True),
            ("Women's 1500m Heats", False),
            ("Women's 1500m Semifinal", False),
            ("Women's 1500m Final", True),
            ("Men's 5000m Relay Heats", False),
            ("Men's 5000m Relay Final", True),
            ("Women's 3000m Relay Heats", False),
            ("Women's 3000m Relay Final", True),
            ("Mixed Team Relay", True),
        ]
    },
    "SKN": {
        "name": "Skeleton",
        "venue": "Cortina Sliding Centre",
        "city": "Cortina d'Ampezzo",
        "events": [
            ("Men's Heat 1", False),
            ("Men's Heat 2", False),
            ("Men's Heat 3", True),
            ("Men's Heat 4", True),
            ("Women's Heat 1", False),
            ("Women's Heat 2", False),
            ("Women's Heat 3", True),
            ("Women's Heat 4", True),
        ]
    },
    "SJP": {
        "name": "Ski Jumping",
        "venue": "Predazzo Ski Jumping Stadium",
        "city": "Predazzo",
        "events": [
            ("Men's Normal Hill Qualification", False),
            ("Men's Normal Hill Final", True),
            ("Women's Normal Hill Qualification", False),
            ("Women's Normal Hill Final", True),
            ("Men's Large Hill Qualification", False),
            ("Men's Large Hill Final", True),
            ("Women's Large Hill Qualification", False),
            ("Women's Large Hill Final", True),
            ("Men's Team Large Hill", True),
            ("Women's Team Normal Hill", True),
            ("Mixed Team Normal Hill", True),
        ]
    },
    "SMT": {
        "name": "Ski Mountaineering",
        "venue": "Bormio Ski Mountaineering Venue",
        "city": "Bormio",
        "events": [
            ("Men's Individual", True),
            ("Women's Individual", True),
            ("Men's Sprint Qualification", False),
            ("Men's Sprint Final", True),
            ("Women's Sprint Qualification", False),
            ("Women's Sprint Final", True),
            ("Mixed Relay", True),
        ]
    },
    "SBD": {
        "name": "Snowboard",
        "venue": "Livigno Snow Park",
        "city": "Livigno",
        "events": [
            ("Men's Parallel Giant Slalom Qualification", False),
            ("Men's Parallel Giant Slalom Finals", True),
            ("Women's Parallel Giant Slalom Qualification", False),
            ("Women's Parallel Giant Slalom Finals", True),
            ("Mixed Team Parallel Slalom", True),
            ("Men's Halfpipe Qualification", False),
            ("Men's Halfpipe Final", True),
            ("Women's Halfpipe Qualification", False),
            ("Women's Halfpipe Final", True),
            ("Men's Slopestyle Qualification", False),
            ("Men's Slopestyle Final", True),
            ("Women's Slopestyle Qualification", False),
            ("Women's Slopestyle Final", True),
            ("Men's Big Air Qualification", False),
            ("Men's Big Air Final", True),
            ("Women's Big Air Qualification", False),
            ("Women's Big Air Final", True),
            ("Men's Snowboard Cross Seeding", False),
            ("Men's Snowboard Cross Finals", True),
            ("Women's Snowboard Cross Seeding", False),
            ("Women's Snowboard Cross Finals", True),
            ("Mixed Team Snowboard Cross", True),
        ]
    },
    "SSK": {
        "name": "Speed Skating",
        "venue": "Milano Speed Skating Stadium",
        "city": "Milano",
        "events": [
            ("Men's 5000m", True),
            ("Women's 3000m", True),
            ("Men's 1500m", True),
            ("Women's 1500m", True),
            ("Men's 1000m", True),
            ("Women's 1000m", True),
            ("Men's 500m", True),
            ("Women's 500m", True),
            ("Men's 10000m", True),
            ("Women's 5000m", True),
            ("Men's Team Pursuit", True),
            ("Women's Team Pursuit", True),
            ("Men's Mass Start", True),
            ("Women's Mass Start", True),
        ]
    },
}

# Time slots for different types of events
TIME_SLOTS = [
    "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
    "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
    "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
    "18:00", "18:30", "19:00", "19:30", "20:00", "20:30",
]


def generate_schedule():
    """Generate complete mock schedule."""
    events = []
    event_counter = {}

    # Games period: Feb 4-22, 2026
    start_date = datetime(2026, 2, 4)
    end_date = datetime(2026, 2, 22)

    for sport_code, sport_info in SPORTS.items():
        event_counter[sport_code] = 0

        # Distribute events across the Games period
        sport_events = sport_info["events"]
        days_available = (end_date - start_date).days + 1

        for event_name, is_medal in sport_events:
            event_counter[sport_code] += 1

            # Assign a date (spread events across the period)
            day_offset = random.randint(0, days_available - 1)
            event_date = start_date + timedelta(days=day_offset)

            # Assign a time slot
            time = random.choice(TIME_SLOTS)

            # Generate event ID
            event_id = f"{sport_code}-{event_counter[sport_code]:03d}"

            # Session code
            session_code = f"{sport_code}{event_counter[sport_code]:02d}"

            events.append({
                "event_id": event_id,
                "sport": sport_info["name"],
                "sport_code": sport_code,
                "event_name": event_name,
                "date": event_date.strftime("%Y-%m-%d"),
                "time": time,
                "venue": sport_info["venue"],
                "venue_city": sport_info["city"],
                "status": "scheduled",
                "session_code": session_code,
                "medal_event": is_medal,
            })

    # Sort by date and time
    events.sort(key=lambda e: (e["date"], e["time"]))

    return events


def main():
    """Generate and save mock schedule."""
    events = generate_schedule()

    # Save as JSON
    output_dir = Path(__file__).parent.parent / "data"
    output_dir.mkdir(exist_ok=True)

    output_file = output_dir / "mock_schedule.json"
    with open(output_file, "w") as f:
        json.dump(events, f, indent=2)

    print(f"Generated {len(events)} events")
    print(f"Saved to: {output_file}")

    # Stats
    medal_events = sum(1 for e in events if e["medal_event"])
    print(f"Medal events: {medal_events}")
    print(f"Sports: {len(SPORTS)}")

    # By city
    cities = {}
    for e in events:
        city = e["venue_city"]
        cities[city] = cities.get(city, 0) + 1

    print("\nEvents by city:")
    for city, count in sorted(cities.items(), key=lambda x: -x[1]):
        print(f"  {city}: {count}")


if __name__ == "__main__":
    main()
