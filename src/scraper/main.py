"""Main scraper module for Olympics schedule data."""

import asyncio
import argparse
from datetime import datetime
from typing import Optional
import httpx
import structlog

from config.settings import get_settings, SPORT_CODES
from .proxy import ProxyRotator, ProxyConfig, get_headers, add_jitter
from .parser import OlympicsParser, ParsedEvent
from .diff import DiffEngine, ScheduleChange
from .scheduler import AdaptiveScheduler, ScrapeMode

log = structlog.get_logger()


class OlympicsScheduleScraper:
    """
    Scrapes the official Olympics schedule.
    
    Usage:
        scraper = OlympicsScheduleScraper()
        events = await scraper.scrape_all()
    """
    
    def __init__(
        self,
        proxy_rotator: Optional[ProxyRotator] = None,
        db = None,  # Database connection (optional for now)
    ):
        self.settings = get_settings()
        self.proxy = proxy_rotator
        self.db = db
        self.parser = OlympicsParser()
        self.diff_engine = DiffEngine()
        
        # Last successful scrape data (for diff comparison)
        self._last_schedule: list[dict] = []
    
    async def scrape_all(self) -> list[ParsedEvent]:
        """
        Scrape schedule for all sports.
        
        Returns:
            List of all parsed events (deduplicated)
        """
        all_events: list[ParsedEvent] = []
        
        # First try the overview page
        log.info("Scraping overview page")
        overview_url = f"{self.settings.olympics_schedule_url}/overview"
        overview_events = await self._scrape_page(overview_url)
        all_events.extend(overview_events)
        
        # If we got events from overview, we might not need individual pages
        if len(overview_events) > 50:
            log.info("Got sufficient events from overview", count=len(overview_events))
        else:
            # Scrape individual sport pages
            log.info("Scraping individual sport pages")
            tasks = [
                self._scrape_page(f"{self.settings.olympics_schedule_url}/{code.lower()}")
                for code in SPORT_CODES.keys()
            ]
            
            results = await asyncio.gather(*tasks, return_exceptions=True)
            
            for result in results:
                if isinstance(result, list):
                    all_events.extend(result)
                elif isinstance(result, Exception):
                    log.warning("Sport page scrape failed", error=str(result))
        
        # Deduplicate by event_id
        seen = set()
        unique_events: list[ParsedEvent] = []
        for event in all_events:
            if event.event_id not in seen:
                seen.add(event.event_id)
                unique_events.append(event)
        
        log.info("Scrape complete", total_events=len(unique_events))
        return unique_events
    
    async def scrape_and_diff(self) -> tuple[list[ParsedEvent], list[ScheduleChange]]:
        """
        Scrape schedule and compare with previous data.
        
        Returns:
            Tuple of (events, changes)
        """
        events = await self.scrape_all()
        
        # Convert to dicts for comparison
        new_schedule = [e.to_dict() for e in events]
        
        # Compare with previous
        changes: list[ScheduleChange] = []
        if self._last_schedule:
            changes = self.diff_engine.compare(self._last_schedule, new_schedule)
        
        # Store for next comparison
        self._last_schedule = new_schedule
        
        return events, changes
    
    async def _scrape_page(self, url: str) -> list[ParsedEvent]:
        """
        Scrape a single schedule page.
        
        Args:
            url: URL to scrape
            
        Returns:
            List of parsed events from page
        """
        html = await self._fetch(url)
        if not html:
            return []
        
        return self.parser.parse(html, url)
    
    async def _fetch(self, url: str, retries: int = 3) -> str:
        """
        Fetch URL content with proxy rotation and retries.
        
        Args:
            url: URL to fetch
            retries: Number of retry attempts
            
        Returns:
            HTML content or empty string on failure
        """
        for attempt in range(retries):
            try:
                proxy_url = self.proxy.get_proxy_url() if self.proxy else None
                
                async with httpx.AsyncClient(
                    proxy=proxy_url,
                    timeout=30,
                    follow_redirects=True,
                ) as client:
                    response = await client.get(url, headers=get_headers())
                    response.raise_for_status()
                    
                    if self.proxy and proxy_url:
                        provider = self.proxy.get_provider_from_url(proxy_url)
                        self.proxy.report_success(provider)
                    
                    return response.text
                    
            except httpx.HTTPStatusError as e:
                log.warning(
                    "HTTP error",
                    url=url,
                    status=e.response.status_code,
                    attempt=attempt + 1
                )
                
                # Back off on rate limiting
                if e.response.status_code == 429:
                    await asyncio.sleep(add_jitter(60))
                    
            except Exception as e:
                log.warning("Fetch error", url=url, error=str(e), attempt=attempt + 1)
                
                if self.proxy and proxy_url:
                    provider = self.proxy.get_provider_from_url(proxy_url)
                    self.proxy.report_failure(provider)
            
            # Wait before retry
            if attempt < retries - 1:
                await asyncio.sleep(add_jitter(5))
        
        return ""


async def test_scrape():
    """Test scraping without proxies (for development)."""
    log.info("Starting test scrape (no proxies)")
    
    scraper = OlympicsScheduleScraper()
    
    # First, let's see what we get from the main page
    settings = get_settings()
    
    urls_to_test = [
        settings.olympics_schedule_url,
        f"{settings.olympics_schedule_url}/overview",
        f"{settings.olympics_base_url}",
    ]
    
    async with httpx.AsyncClient(timeout=30, follow_redirects=True) as client:
        for url in urls_to_test:
            log.info(f"Testing URL: {url}")
            try:
                response = await client.get(url, headers=get_headers())
                log.info(f"  Status: {response.status_code}")
                log.info(f"  Content length: {len(response.text)}")
                
                # Try to parse
                events = scraper.parser.parse(response.text, url)
                log.info(f"  Events found: {len(events)}")
                
                if events:
                    log.info("  Sample events:")
                    for event in events[:3]:
                        log.info(f"    - {event.event_name} ({event.sport}) @ {event.date} {event.time}")
                
                # Save raw HTML for analysis
                filename = url.split("/")[-1] or "index"
                with open(f"/tmp/olympics_{filename}.html", "w") as f:
                    f.write(response.text)
                log.info(f"  Saved to /tmp/olympics_{filename}.html")
                
            except Exception as e:
                log.error(f"  Error: {e}")
            
            print()  # Blank line between URLs


async def run_scraper():
    """Run the full scraper with scheduling."""
    settings = get_settings()
    
    # Set up proxy rotation if configured
    proxy_rotator = None
    if settings.proxy_provider != "none":
        proxy_rotator = ProxyRotator([
            ProxyConfig(
                provider=settings.proxy_provider,
                username=settings.proxy_username,
                password=settings.proxy_password,
            )
        ])
    
    scraper = OlympicsScheduleScraper(proxy_rotator=proxy_rotator)
    scheduler = AdaptiveScheduler()
    
    async def scrape_cycle():
        """Single scrape cycle."""
        events, changes = await scraper.scrape_and_diff()
        
        if changes:
            log.info("Schedule changes detected", count=len(changes))
            for change in changes:
                log.info(change.to_notification_text())
                # TODO: Send push notifications
        
        # TODO: Save to database
    
    # Run with adaptive scheduling
    await scheduler.run(scrape_cycle)


def main():
    """CLI entry point."""
    parser = argparse.ArgumentParser(description="Neve26 Olympics Schedule Scraper")
    parser.add_argument(
        "--test",
        action="store_true",
        help="Run in test mode (single scrape, no proxies)"
    )
    parser.add_argument(
        "--once",
        action="store_true",
        help="Run a single scrape cycle and exit"
    )
    
    args = parser.parse_args()
    
    # Configure logging
    structlog.configure(
        processors=[
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.dev.ConsoleRenderer()
        ]
    )
    
    if args.test:
        asyncio.run(test_scrape())
    elif args.once:
        scraper = OlympicsScheduleScraper()
        events = asyncio.run(scraper.scrape_all())
        print(f"\nFound {len(events)} events")
        for event in events[:10]:
            print(f"  - {event.event_name} ({event.sport})")
    else:
        asyncio.run(run_scraper())


if __name__ == "__main__":
    main()
