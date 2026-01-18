"""Database module for Neve26."""

from .connection import get_session, init_db, close_db
from .models import Base, Event, Device, Favorite, ScheduleChange, ScrapeLog, Article, SocialPost
from .queries import (
    # Event queries
    get_all_events,
    get_event_by_id,
    get_live_events,
    get_upcoming_events,
    upsert_events,
    get_sports,
    get_venues,
    # Device queries
    register_device,
    get_device_by_id,
    # Favorites queries
    sync_favorites,
    get_device_favorites,
    get_devices_with_favorite,
    # Change queries
    record_change,
    get_pending_notifications,
    mark_notified,
    # Scrape log queries
    create_scrape_log,
    complete_scrape_log,
    # Article queries
    get_articles,
    get_article_by_slug,
    get_featured_articles,
    create_article,
    update_article,
    publish_article,
    # Social post queries
    get_recent_social_posts,
    create_social_post,
    get_content_type_counts,
)

__all__ = [
    # Connection
    "get_session",
    "init_db",
    "close_db",
    # Models
    "Base",
    "Event",
    "Device",
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
    # Device queries
    "register_device",
    "get_device_by_id",
    # Favorites queries
    "sync_favorites",
    "get_device_favorites",
    "get_devices_with_favorite",
    # Change queries
    "record_change",
    "get_pending_notifications",
    "mark_notified",
    # Scrape log queries
    "create_scrape_log",
    "complete_scrape_log",
    # Article model and queries
    "Article",
    "get_articles",
    "get_article_by_slug",
    "get_featured_articles",
    "create_article",
    "update_article",
    "publish_article",
    # Social post model and queries
    "SocialPost",
    "get_recent_social_posts",
    "create_social_post",
    "get_content_type_counts",
]
