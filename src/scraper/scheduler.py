"""Adaptive scheduling for the scraper based on time and events."""

import asyncio
from datetime import datetime, timedelta
from enum import Enum
from typing import Callable, Awaitable, Optional
from zoneinfo import ZoneInfo
import structlog

from config.settings import get_settings
from .proxy import add_jitter

log = structlog.get_logger()

# Central European Time (Italy)
CET = ZoneInfo("Europe/Rome")


class ScrapeMode(Enum):
    """Scraping frequency modes."""
    NIGHT = "night"          # 30 min intervals (00:00-06:00)
    DAY = "day"              # 5 min intervals (06:00-24:00)
    PRE_EVENT = "pre_event"  # 90 sec intervals (2h before events)
    LIVE = "live"            # 30 sec intervals (during events)


class AdaptiveScheduler:
    """
    Dynamically adjusts scrape frequency based on time and upcoming events.
    
    Usage:
        scheduler = AdaptiveScheduler(event_store)
        await scheduler.run(scrape_function)
    """
    
    def __init__(self, event_store: Optional[object] = None):
        """
        Initialize scheduler.
        
        Args:
            event_store: Database access for checking upcoming events.
                         If None, only time-based scheduling is used.
        """
        self.event_store = event_store
        self.settings = get_settings()
        self.running = False
        
        self.intervals = {
            ScrapeMode.NIGHT: self.settings.scrape_interval_night,
            ScrapeMode.DAY: self.settings.scrape_interval_day,
            ScrapeMode.PRE_EVENT: self.settings.scrape_interval_pre_event,
            ScrapeMode.LIVE: self.settings.scrape_interval_live,
        }
    
    def get_current_mode(self) -> ScrapeMode:
        """
        Determine scraping mode based on current time and events.
        
        Returns:
            Current ScrapeMode based on conditions.
        """
        now = datetime.now(CET)
        hour = now.hour
        
        # Night mode: 00:00 - 06:00 CET
        if 0 <= hour < 6:
            return ScrapeMode.NIGHT
        
        # If we have event store, check for live/upcoming events
        if self.event_store:
            # Check for live events (happening right now)
            if self._has_live_events(now):
                return ScrapeMode.LIVE
            
            # Check for upcoming events (within 2 hours)
            if self._has_upcoming_events(now, timedelta(hours=2)):
                return ScrapeMode.PRE_EVENT
        
        # Default: day mode
        return ScrapeMode.DAY
    
    def _has_live_events(self, now: datetime) -> bool:
        """Check if there are events currently in progress."""
        if not self.event_store:
            return False
        
        try:
            # This would call event_store.get_events_in_progress(now)
            # For now, return False until DB is implemented
            return False
        except Exception as e:
            log.error("Error checking live events", error=str(e))
            return False
    
    def _has_upcoming_events(self, now: datetime, window: timedelta) -> bool:
        """Check if there are events starting within the given window."""
        if not self.event_store:
            return False
        
        try:
            # This would call event_store.get_events_starting_within(now, window)
            # For now, return False until DB is implemented
            return False
        except Exception as e:
            log.error("Error checking upcoming events", error=str(e))
            return False
    
    def get_interval(self) -> int:
        """
        Get current scrape interval in seconds.
        
        Returns:
            Interval with jitter applied.
        """
        mode = self.get_current_mode()
        base_interval = self.intervals[mode]
        return add_jitter(base_interval)
    
    async def run(self, scrape_func: Callable[[], Awaitable[None]]) -> None:
        """
        Main scheduling loop.
        
        Args:
            scrape_func: Async function to call for each scrape cycle.
        """
        self.running = True
        log.info("Scheduler started")
        
        while self.running:
            mode = self.get_current_mode()
            interval = self.get_interval()
            
            log.info(
                "Scrape cycle starting",
                mode=mode.value,
                interval_seconds=interval,
                time=datetime.now(CET).isoformat()
            )
            
            try:
                await scrape_func()
            except Exception as e:
                log.error("Scrape cycle failed", error=str(e))
            
            log.debug("Sleeping until next cycle", seconds=interval)
            await asyncio.sleep(interval)
        
        log.info("Scheduler stopped")
    
    def stop(self) -> None:
        """Stop the scheduler loop."""
        self.running = False
    
    async def run_once(self, scrape_func: Callable[[], Awaitable[None]]) -> None:
        """
        Run a single scrape cycle (useful for testing).
        
        Args:
            scrape_func: Async function to call.
        """
        mode = self.get_current_mode()
        log.info("Single scrape cycle", mode=mode.value)
        await scrape_func()


def is_games_period() -> bool:
    """
    Check if we're currently in the Games period.
    
    Returns:
        True if current date is within the Games window.
    """
    now = datetime.now(CET).date()
    
    # Games: Feb 4 (competitions start) to Feb 22, 2026
    games_start = datetime(2026, 2, 4).date()
    games_end = datetime(2026, 2, 22).date()
    
    return games_start <= now <= games_end


def is_pre_games_period() -> bool:
    """
    Check if we're in the pre-Games period (good for initial data load).
    
    Returns:
        True if we're within 30 days before Games start.
    """
    now = datetime.now(CET).date()
    games_start = datetime(2026, 2, 4).date()
    
    days_until = (games_start - now).days
    return 0 < days_until <= 30
