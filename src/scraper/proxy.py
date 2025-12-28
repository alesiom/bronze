"""Proxy rotation for web scraping."""

import random
from dataclasses import dataclass, field
from typing import Optional
import structlog

log = structlog.get_logger()


@dataclass
class ProxyConfig:
    """Configuration for a proxy provider."""
    provider: str
    username: str
    password: str
    endpoint: str = ""
    
    def __post_init__(self):
        """Set default endpoints based on provider."""
        if not self.endpoint:
            endpoints = {
                "iproyal": "geo.iproyal.com:12321",
                "decodo": "gate.decodo.com:7000",
                "scraperapi": "proxy-server.scraperapi.com:8001",
            }
            self.endpoint = endpoints.get(self.provider, "")


@dataclass
class ProxyRotator:
    """
    Manages rotating residential proxies with automatic failover.
    
    Usage:
        rotator = ProxyRotator([
            ProxyConfig("iproyal", "user", "pass"),
            ProxyConfig("decodo", "user", "pass"),
        ])
        proxy_url = rotator.get_proxy_url()
    """
    
    configs: list[ProxyConfig]
    max_failures: int = 3
    failure_counts: dict[str, int] = field(default_factory=dict)
    
    def __post_init__(self):
        """Initialize failure tracking."""
        self.failure_counts = {c.provider: 0 for c in self.configs}
    
    def get_proxy_url(self) -> Optional[str]:
        """
        Get next proxy URL with rotation.
        
        Returns:
            Proxy URL string or None if no proxies configured.
        """
        if not self.configs:
            return None
            
        config = self._select_provider()
        if not config:
            return None
        
        return self._build_proxy_url(config)
    
    def _select_provider(self) -> Optional[ProxyConfig]:
        """Select provider, avoiding those with too many failures."""
        available = [
            c for c in self.configs 
            if self.failure_counts.get(c.provider, 0) < self.max_failures
        ]
        
        if not available:
            # Reset all counts if all providers failed
            log.warning("All proxy providers failed, resetting counts")
            self.failure_counts = {c.provider: 0 for c in self.configs}
            available = self.configs
        
        return random.choice(available) if available else None
    
    def _build_proxy_url(self, config: ProxyConfig) -> str:
        """Build proxy URL based on provider format."""
        
        if config.provider == "iproyal":
            # IPRoyal: rotating session
            return f"http://{config.username}:{config.password}@{config.endpoint}"
        
        elif config.provider == "decodo":
            # Decodo/Smartproxy: session-based rotation
            session_id = random.randint(100000, 999999)
            username = f"{config.username}-session-{session_id}"
            return f"http://{username}:{config.password}@{config.endpoint}"
        
        elif config.provider == "scraperapi":
            # ScraperAPI: API key as password
            return f"http://scraperapi:{config.password}@{config.endpoint}"
        
        else:
            # Generic format
            return f"http://{config.username}:{config.password}@{config.endpoint}"
    
    def report_failure(self, provider: str) -> None:
        """Track proxy failures for intelligent rotation."""
        self.failure_counts[provider] = self.failure_counts.get(provider, 0) + 1
        log.warning("Proxy failure recorded", provider=provider, count=self.failure_counts[provider])
    
    def report_success(self, provider: str) -> None:
        """Reset failure count on success."""
        if self.failure_counts.get(provider, 0) > 0:
            log.info("Proxy success, resetting failure count", provider=provider)
        self.failure_counts[provider] = 0
    
    def get_provider_from_url(self, proxy_url: str) -> str:
        """Extract provider name from proxy URL."""
        for config in self.configs:
            if config.endpoint in proxy_url:
                return config.provider
        return "unknown"


# Common User-Agent strings for rotation
USER_AGENTS = [
    # Chrome on Windows
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
    # Chrome on Mac
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    # Firefox on Windows
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
    # Safari on Mac
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15",
    # Edge on Windows
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0",
]


def get_random_user_agent() -> str:
    """Get a random User-Agent string."""
    return random.choice(USER_AGENTS)


def get_headers() -> dict[str, str]:
    """Get realistic browser headers."""
    return {
        "User-Agent": get_random_user_agent(),
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9,it;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
        "DNT": "1",
        "Connection": "keep-alive",
        "Upgrade-Insecure-Requests": "1",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "none",
        "Sec-Fetch-User": "?1",
        "Cache-Control": "max-age=0",
    }


def add_jitter(interval: int, jitter_pct: float = 0.1) -> int:
    """
    Add random jitter to an interval.
    
    Args:
        interval: Base interval in seconds
        jitter_pct: Percentage of jitter (0.1 = ±10%)
    
    Returns:
        Interval with random jitter applied
    """
    jitter = int(interval * jitter_pct)
    return interval + random.randint(-jitter, jitter)
