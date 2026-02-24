"""SQLAlchemy models for Bronze database."""

from datetime import datetime, date, time
from typing import Optional
from uuid import uuid4

from sqlalchemy import (
    Boolean,
    Column,
    Date,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    Time,
)
from sqlalchemy.dialects.postgresql import ARRAY, JSONB, UUID
from sqlalchemy.orm import DeclarativeBase, relationship


class Base(DeclarativeBase):
    """Base class for all models."""
    pass


class Event(Base):
    """Sports event in the schedule."""

    __tablename__ = "events"

    event_id = Column(String(50), primary_key=True)
    sport = Column(String(50), nullable=False)
    sport_code = Column(String(10), nullable=False, index=True)
    event_name = Column(String(255), nullable=False)
    date = Column(Date, nullable=False, index=True)
    time = Column(Time, nullable=True)
    venue = Column(String(100), nullable=True)
    venue_city = Column(String(50), nullable=True, index=True)
    country = Column(String(3), nullable=True)  # ISO country code
    status = Column(String(50), default="scheduled")
    session_code = Column(String(20), nullable=True)
    medal_event = Column(Boolean, default=False)

    # Federation and series info
    federation = Column(String(10), nullable=True, index=True)  # FIS, IBU, IBSF, FIL, ISU, WCF, IOC
    series = Column(String(50), nullable=True)  # World Cup, Tour de Ski, Four Hills, etc.

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    changes = relationship("ScheduleChange", back_populates="event", cascade="all, delete-orphan")

    __table_args__ = (
        Index("idx_events_date_time", "date", "time"),
        Index("idx_events_sport_date", "sport_code", "date"),
    )

    def to_dict(self) -> dict:
        """Convert to dictionary for API response."""
        return {
            "event_id": self.event_id,
            "sport": self.sport,
            "sport_code": self.sport_code,
            "event_name": self.event_name,
            "date": self.date.isoformat() if self.date else None,
            "time": self.time.isoformat() if self.time else None,
            "venue": self.venue,
            "venue_city": self.venue_city,
            "country": self.country,
            "status": self.status,
            "session_code": self.session_code,
            "medal_event": self.medal_event,
            "federation": self.federation,
            "series": self.series,
        }


class Device(Base):
    """Registered device for push notifications."""

    __tablename__ = "devices"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    token = Column(String(255), nullable=False, unique=True)
    platform = Column(String(10), nullable=False)  # ios/android
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    favorites = relationship("Favorite", back_populates="device", cascade="all, delete-orphan")

    def to_dict(self) -> dict:
        """Convert to dictionary for API response."""
        return {
            "id": str(self.id),
            "platform": self.platform,
        }


class Favorite(Base):
    """Device's favorited events for push notifications."""

    __tablename__ = "favorites"

    device_id = Column(UUID(as_uuid=True), ForeignKey("devices.id", ondelete="CASCADE"), primary_key=True)
    event_id = Column(String(50), primary_key=True)  # No FK to events - favorites can exist before schedule is loaded
    synced_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    device = relationship("Device", back_populates="favorites")

    __table_args__ = (
        Index("idx_favorites_device", "device_id"),
        Index("idx_favorites_event", "event_id"),
    )


class ScheduleChange(Base):
    """Tracked changes in the schedule for notifications."""

    __tablename__ = "schedule_changes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    event_id = Column(String(50), ForeignKey("events.event_id", ondelete="CASCADE"))
    change_type = Column(String(50), nullable=False)  # time_changed, date_changed, venue_changed, status_changed
    old_value = Column(Text, nullable=True)
    new_value = Column(Text, nullable=True)
    detected_at = Column(DateTime, default=datetime.utcnow, index=True)
    notified = Column(Boolean, default=False)  # Track if notifications were sent

    # Relationships
    event = relationship("Event", back_populates="changes")

    def to_dict(self) -> dict:
        """Convert to dictionary for API response."""
        return {
            "id": str(self.id),
            "event_id": self.event_id,
            "change_type": self.change_type,
            "old_value": self.old_value,
            "new_value": self.new_value,
            "detected_at": self.detected_at.isoformat() if self.detected_at else None,
        }


class ScrapeLog(Base):
    """Log of scraping runs for monitoring."""

    __tablename__ = "scrape_logs"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    started_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)
    events_found = Column(String(10), default="0")  # Store as string to avoid int column issues
    changes_detected = Column(String(10), default="0")
    status = Column(String(20), default="running")  # running, success, failed
    error_message = Column(Text, nullable=True)

    def to_dict(self) -> dict:
        """Convert to dictionary for API response."""
        return {
            "id": str(self.id),
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "completed_at": self.completed_at.isoformat() if self.completed_at else None,
            "events_found": int(self.events_found) if self.events_found else 0,
            "changes_detected": int(self.changes_detected) if self.changes_detected else 0,
            "status": self.status,
            "error_message": self.error_message,
        }


class SocialPost(Base):
    """Social media post history for content variety tracking."""

    __tablename__ = "social_posts"

    id = Column(Integer, primary_key=True)
    content_type = Column(String(50), nullable=False, index=True)  # 'quote', 'race_preview', etc.
    post_text = Column(Text, nullable=False)
    platform = Column(String(20), nullable=False, index=True)  # 'twitter', 'instagram'
    posted_at = Column(DateTime(timezone=True), default=datetime.utcnow, index=True)

    # Context for smarter content selection
    athletes_mentioned = Column(ARRAY(Text), nullable=True)
    sports_mentioned = Column(ARRAY(Text), nullable=True)
    topics = Column(ARRAY(Text), nullable=True)

    # Late.dev response tracking
    late_post_id = Column(String(100), nullable=True)

    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)

    def to_dict(self) -> dict:
        """Convert to dictionary for API response."""
        return {
            "id": self.id,
            "content_type": self.content_type,
            "post_text": self.post_text,
            "platform": self.platform,
            "posted_at": self.posted_at.isoformat() if self.posted_at else None,
            "athletes_mentioned": self.athletes_mentioned or [],
            "sports_mentioned": self.sports_mentioned or [],
            "topics": self.topics or [],
        }


class Article(Base):
    """News article with multilingual content."""

    __tablename__ = "articles"

    id = Column(Integer, primary_key=True)
    slug = Column(String(255), unique=True, nullable=False, index=True)

    # Multilingual content as JSONB: {"en": "...", "de": "...", ...}
    title = Column(JSONB, nullable=False)
    excerpt = Column(JSONB, nullable=True)
    content = Column(JSONB, nullable=False)

    # Categorization
    category = Column(String(50), nullable=False, index=True)
    sport_code = Column(String(10), nullable=True, index=True)

    # Related entities
    athlete_slugs = Column(ARRAY(Text), nullable=True)
    event_id = Column(String(50), nullable=True)
    venue = Column(String(100), nullable=True)
    venue_city = Column(String(50), nullable=True)

    # SEO
    meta_description = Column(JSONB, nullable=True)
    canonical_url = Column(String(500), nullable=True)
    structured_data = Column(JSONB, nullable=True)

    # Media
    featured_image = Column(String(500), nullable=True)
    image_alt = Column(JSONB, nullable=True)
    image_credit = Column(String(255), nullable=True)

    # Publishing
    status = Column(String(20), default="draft", index=True)
    published_at = Column(DateTime(timezone=True), nullable=True, index=True)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)

    # Source tracking
    source_type = Column(String(50), nullable=True)
    source_data = Column(JSONB, nullable=True)

    def get_localized(self, field: str, lang: str = "en") -> Optional[str]:
        """Get localized content with fallback to English."""
        value = getattr(self, field, None)
        if not value or not isinstance(value, dict):
            return None
        return value.get(lang) or value.get("en")

    def to_dict(self, lang: str = "en") -> dict:
        """Convert to dictionary for API response."""
        return {
            "id": self.id,
            "slug": self.slug,
            "title": self.get_localized("title", lang),
            "excerpt": self.get_localized("excerpt", lang),
            "content": self.get_localized("content", lang),
            "category": self.category,
            "sport_code": self.sport_code,
            "athlete_slugs": self.athlete_slugs or [],
            "venue": self.venue,
            "venue_city": self.venue_city,
            "featured_image": self.featured_image,
            "image_alt": self.get_localized("image_alt", lang),
            "published_at": self.published_at.isoformat() if self.published_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
