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
        default="postgresql://postgres:postgres@localhost:5432/neve26",
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
    
    # Target URLs
    olympics_base_url: str = "https://www.olympics.com/en/milano-cortina-2026"
    olympics_schedule_url: str = "https://www.olympics.com/en/milano-cortina-2026/schedule/overview"
    
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


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()


# Sport codes for Milano Cortina 2026
SPORT_CODES = {
    "ALP": "Alpine Skiing",
    "BTH": "Biathlon",
    "BOB": "Bobsleigh",
    "CCS": "Cross-Country Skiing",
    "CUR": "Curling",
    "FSK": "Figure Skating",
    "FRS": "Freestyle Skiing",
    "IHO": "Ice Hockey",
    "LUG": "Luge",
    "NCB": "Nordic Combined",
    "STK": "Short Track Speed Skating",
    "SKN": "Skeleton",
    "SJP": "Ski Jumping",
    "SMT": "Ski Mountaineering",
    "SBD": "Snowboard",
    "SSK": "Speed Skating",
}

# Venue information
VENUES = {
    "milano": {
        "name": "Milano",
        "venues": [
            "Milano Ice Skating Arena",
            "Milano San Siro Olympic Stadium",
            "Milano Santagiulia Ice Hockey Arena",
            "Milano Speed Skating Stadium",
            "Milano Rho Ice Hockey Arena",
        ]
    },
    "cortina": {
        "name": "Cortina d'Ampezzo",
        "venues": [
            "Cortina Curling Olympic Stadium",
            "Cortina Sliding Centre",
            "Tofane Alpine Skiing Centre",
        ]
    },
    "bormio": {
        "name": "Bormio",
        "venues": ["Stelvio Ski Centre"]
    },
    "livigno": {
        "name": "Livigno",
        "venues": [
            "Livigno Snow Park",
            "Livigno Aerials & Moguls Park",
        ]
    },
    "anterselva": {
        "name": "Anterselva/Antholz",
        "venues": ["Anterselva Biathlon Arena"]
    },
    "tesero": {
        "name": "Tesero",
        "venues": ["Tesero Cross-Country Skiing Stadium"]
    },
    "predazzo": {
        "name": "Predazzo",
        "venues": ["Predazzo Ski Jumping Stadium"]
    },
    "verona": {
        "name": "Verona",
        "venues": ["Verona Olympic Arena"]
    },
}

# Games dates
GAMES_START = "2026-02-06"
GAMES_END = "2026-02-22"
COMPETITIONS_START = "2026-02-04"  # Curling starts early
