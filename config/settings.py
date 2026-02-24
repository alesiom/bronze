"""Application settings loaded from environment variables."""

from pydantic_settings import BaseSettings
from pydantic import Field
from typing import Literal
from functools import lru_cache


class Settings(BaseSettings):
    """Application configuration."""
    
    # Environment
    env: Literal["development", "staging", "production"] = "development"
    debug: bool = False
    log_level: str = "INFO"
    
    # Database
    database_url: str = Field(
        default="postgresql://postgres:postgres@localhost:5432/neve26",  # DB name is legacy, intentional
        description="PostgreSQL connection string"
    )
    
    # Proxy configuration
    proxy_provider: Literal["iproyal", "decodo", "scraperapi", "none"] = "none"
    proxy_username: str = ""
    proxy_password: str = ""
    
    # Scraper settings
    scrape_enabled: bool = True
    scrape_interval_night: int = 1800      # 30 minutes
    scrape_interval_day: int = 300         # 5 minutes
    scrape_interval_pre_event: int = 90    # 1.5 minutes
    scrape_interval_live: int = 30         # 30 seconds
    
    # Website
    site_url: str = "https://bronze.news"
    
    # Push notifications
    firebase_credentials_json: str = ""
    apns_key_id: str = ""
    apns_team_id: str = ""
    apns_key_path: str = ""
    
    # API settings
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    cors_origins: list[str] = ["*"]
    
    # Rate limiting
    max_requests_per_minute: int = 30
    
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        extra = "ignore"  # Ignore extra env vars (e.g., POSTGRES_USER for db container)


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()


# Content categories
CONTENT_CATEGORIES = {
    "news": "General Sports News",
    "athlete-profile": "Athlete Profiles",
    "sport-explainer": "Sport Explainers",
    "football": "Football",
    "tennis": "Tennis",
    "athletics": "Athletics",
    "cycling": "Cycling",
    "motorsport": "Motorsport",
    "winter-sports": "Winter Sports",
    "swimming": "Swimming",
    "other": "Other Sports",
}
