"""Parser for Olympics.com schedule data."""

import json
import re
from dataclasses import dataclass, asdict
from typing import Optional
from bs4 import BeautifulSoup
import structlog

log = structlog.get_logger()


@dataclass
class ParsedEvent:
    """Structured event data from scraping."""
    event_id: str
    sport: str
    sport_code: str
    event_name: str
    date: str
    time: str
    venue: str
    venue_city: str
    status: str
    session_code: str
    medal_event: bool = False
    
    def to_dict(self) -> dict:
        """Convert to dictionary."""
        return asdict(self)


class OlympicsParser:
    """
    Parser for Olympics.com schedule pages.
    
    The Olympics website typically embeds schedule data as JSON in script tags,
    which is much more reliable than parsing HTML tables.
    """
    
    def parse(self, html: str, url: str = "") -> list[ParsedEvent]:
        """
        Parse schedule HTML and extract events.
        
        Args:
            html: Raw HTML content
            url: Source URL (for logging)
            
        Returns:
            List of parsed events
        """
        events: list[ParsedEvent] = []
        soup = BeautifulSoup(html, "lxml")
        
        # Strategy 1: Look for embedded JSON data (most reliable)
        json_events = self._extract_json_data(soup)
        if json_events:
            log.info("Parsed events from JSON", count=len(json_events), url=url)
            return json_events
        
        # Strategy 2: Look for Next.js __NEXT_DATA__ script
        next_data = self._extract_next_data(soup)
        if next_data:
            log.info("Parsed events from Next.js data", count=len(next_data), url=url)
            return next_data
        
        # Strategy 3: Parse HTML structure (fallback)
        html_events = self._parse_html_schedule(soup)
        if html_events:
            log.info("Parsed events from HTML", count=len(html_events), url=url)
            return html_events
        
        log.warning("No events found", url=url)
        return events
    
    def _extract_json_data(self, soup: BeautifulSoup) -> list[ParsedEvent]:
        """Extract events from embedded JSON in script tags."""
        events: list[ParsedEvent] = []
        
        # Look for script tags with type="application/json"
        for script in soup.find_all("script", type="application/json"):
            try:
                data = json.loads(script.string)
                events.extend(self._parse_json_schedule(data))
            except (json.JSONDecodeError, TypeError):
                continue
        
        # Also look for inline JSON in script tags
        for script in soup.find_all("script"):
            if not script.string:
                continue
            
            # Look for schedule data patterns
            patterns = [
                r'scheduleData\s*=\s*(\{.*?\});',
                r'window\.__SCHEDULE__\s*=\s*(\{.*?\});',
                r'"schedule"\s*:\s*(\[.*?\])',
            ]
            
            for pattern in patterns:
                match = re.search(pattern, script.string, re.DOTALL)
                if match:
                    try:
                        data = json.loads(match.group(1))
                        events.extend(self._parse_json_schedule(data))
                    except json.JSONDecodeError:
                        continue
        
        return events
    
    def _extract_next_data(self, soup: BeautifulSoup) -> list[ParsedEvent]:
        """Extract events from Next.js __NEXT_DATA__ script."""
        events: list[ParsedEvent] = []
        
        script = soup.find("script", id="__NEXT_DATA__")
        if not script or not script.string:
            return events
        
        try:
            data = json.loads(script.string)
            # Navigate to props.pageProps where schedule data usually lives
            page_props = data.get("props", {}).get("pageProps", {})
            
            # Try common keys
            for key in ["schedule", "events", "units", "competitions"]:
                if key in page_props:
                    events.extend(self._parse_json_schedule(page_props[key]))
                    break
            
            # Also check nested structures
            if "initialState" in page_props:
                initial = page_props["initialState"]
                for key in ["schedule", "events", "units"]:
                    if key in initial:
                        events.extend(self._parse_json_schedule(initial[key]))
                        break
                        
        except (json.JSONDecodeError, KeyError, TypeError) as e:
            log.debug("Failed to parse Next.js data", error=str(e))
        
        return events
    
    def _parse_json_schedule(self, data: dict | list) -> list[ParsedEvent]:
        """Parse schedule data from JSON structure."""
        events: list[ParsedEvent] = []
        
        # Handle different data structures
        if isinstance(data, dict):
            # Check for nested arrays
            for key in ["units", "events", "schedule", "items", "data"]:
                if key in data and isinstance(data[key], list):
                    data = data[key]
                    break
            else:
                # Single event object
                event = self._parse_json_event(data)
                if event:
                    events.append(event)
                return events
        
        if not isinstance(data, list):
            return events
        
        # Parse array of events
        for item in data:
            event = self._parse_json_event(item)
            if event:
                events.append(event)
        
        return events
    
    def _parse_json_event(self, item: dict) -> Optional[ParsedEvent]:
        """Parse a single event from JSON."""
        if not isinstance(item, dict):
            return None
        
        # Try to extract event_id from various possible keys
        event_id = (
            item.get("id") or 
            item.get("eventId") or 
            item.get("code") or
            item.get("unitCode") or
            ""
        )
        
        if not event_id:
            return None
        
        # Extract sport info
        sport = (
            item.get("sport") or 
            item.get("sportName") or
            item.get("discipline") or
            item.get("disciplineName") or
            ""
        )
        
        sport_code = (
            item.get("sportCode") or
            item.get("disciplineCode") or
            item.get("rsc", "")[:3] or
            ""
        )
        
        # Extract event name
        event_name = (
            item.get("name") or
            item.get("eventName") or
            item.get("description") or
            item.get("longDescription") or
            ""
        )
        
        # Extract timing
        date = (
            item.get("date") or
            item.get("startDate") or
            item.get("competitionDate") or
            ""
        )
        
        time = (
            item.get("time") or
            item.get("startTime") or
            item.get("scheduledTime") or
            ""
        )
        
        # Clean up date/time formats
        if date and "T" in str(date):
            date = str(date).split("T")[0]
        if time and "T" in str(time):
            time = str(time).split("T")[1].split("+")[0].split("Z")[0][:5]
        
        # Extract venue
        venue = (
            item.get("venue") or
            item.get("venueName") or
            item.get("location") or
            ""
        )
        
        venue_city = (
            item.get("venueCity") or
            item.get("city") or
            item.get("locationCity") or
            ""
        )
        
        # Extract status
        status = (
            item.get("status") or
            item.get("eventStatus") or
            "scheduled"
        )
        
        # Extract session info
        session_code = (
            item.get("sessionCode") or
            item.get("session") or
            ""
        )
        
        # Check if medal event
        medal_event = (
            item.get("medalEvent", False) or
            item.get("isMedalEvent", False) or
            "medal" in event_name.lower() or
            "final" in event_name.lower()
        )
        
        return ParsedEvent(
            event_id=str(event_id),
            sport=str(sport),
            sport_code=str(sport_code).upper(),
            event_name=str(event_name),
            date=str(date),
            time=str(time),
            venue=str(venue),
            venue_city=str(venue_city),
            status=str(status).lower(),
            session_code=str(session_code),
            medal_event=bool(medal_event),
        )
    
    def _parse_html_schedule(self, soup: BeautifulSoup) -> list[ParsedEvent]:
        """Fallback: Parse events from HTML structure."""
        events: list[ParsedEvent] = []
        
        # Look for common schedule container patterns
        selectors = [
            "[data-event-id]",
            ".schedule-item",
            ".event-row",
            ".competition-unit",
            "tr[data-id]",
            ".schedule-event",
        ]
        
        for selector in selectors:
            items = soup.select(selector)
            if items:
                for item in items:
                    event = self._parse_html_event(item)
                    if event:
                        events.append(event)
                break
        
        return events
    
    def _parse_html_event(self, element) -> Optional[ParsedEvent]:
        """Parse a single event from HTML element."""
        try:
            # Try to extract event_id
            event_id = (
                element.get("data-event-id") or
                element.get("data-id") or
                element.get("id") or
                ""
            )
            
            if not event_id:
                return None
            
            # Helper to safely get text from selector
            def get_text(selector: str) -> str:
                el = element.select_one(selector)
                return el.get_text(strip=True) if el else ""
            
            return ParsedEvent(
                event_id=event_id,
                sport=get_text(".sport-name, .discipline"),
                sport_code=element.get("data-sport-code", ""),
                event_name=get_text(".event-name, .unit-name, .description"),
                date=get_text(".event-date, .date"),
                time=get_text(".event-time, .time, .start-time"),
                venue=get_text(".event-venue, .venue"),
                venue_city=get_text(".venue-city, .location"),
                status=element.get("data-status", "scheduled"),
                session_code=element.get("data-session", ""),
                medal_event="medal" in element.get("class", []),
            )
        except Exception as e:
            log.debug("Failed to parse HTML event", error=str(e))
            return None


def extract_sport_code_from_url(url: str) -> str:
    """Extract sport code from schedule URL."""
    # URL pattern: /schedule/alp -> ALP
    match = re.search(r'/schedule/([a-z]{3})(?:\?|$|/)', url.lower())
    if match:
        return match.group(1).upper()
    return ""
