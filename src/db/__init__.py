"""Database module for Neve26."""

from .connection import get_session, init_db, close_db
from .models import Base, Event, User, Favorite, ScheduleChange, ScrapeLog
from .queries import (
    # Event queries
    get_all_events,
    get_event_by_id,
    get_live_events,
    get_upcoming_events,
    upsert_events,
    get_sports,
    get_venues,
    # User queries
    get_or_create_user,
    update_user_token,
    # Favorites queries
    get_user_favorites,
    add_favorite,
    remove_favorite,
    get_users_with_favorite,
    # Change queries
    record_change,
    get_pending_notifications,
    mark_notified,
    # Scrape log queries
    create_scrape_log,
    complete_scrape_log,
)

__all__ = [
    # Connection
    "get_session",
    "init_db",
    "close_db",
    # Models
    "Base",
    "Event",
    "User",
    "Favorite",
    "ScheduleChange",
    "ScrapeLog",
    # Event queries
    "get_all_events",
    "get_event_by_id",
    "get_live_events",
    "get_upcoming_events",
    "upsert_events",
    "get_sports",
    "get_venues",
    # User queries
    "get_or_create_user",
    "update_user_token",
    # Favorites queries
    "get_user_favorites",
    "add_favorite",
    "remove_favorite",
    "get_users_with_favorite",
    # Change queries
    "record_change",
    "get_pending_notifications",
    "mark_notified",
    # Scrape log queries
    "create_scrape_log",
    "complete_scrape_log",
]
