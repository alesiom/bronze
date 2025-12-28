"""SQLAlchemy models for Neve26 database."""

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
    String,
    Text,
    Time,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import DeclarativeBase, relationship


class Base(DeclarativeBase):
    """Base class for all models."""
    pass


class Event(Base):
    """Olympic event in the schedule."""

    __tablename__ = "events"

    event_id = Column(String(50), primary_key=True)
    sport = Column(String(50), nullable=False)
    sport_code = Column(String(10), nullable=False, index=True)
    event_name = Column(String(255), nullable=False)
    date = Column(Date, nullable=False, index=True)
    time = Column(Time, nullable=True)
    venue = Column(String(100), nullable=True)
    venue_city = Column(String(50), nullable=True, index=True)
    status = Column(String(50), default="scheduled")
    session_code = Column(String(20), nullable=True)
    medal_event = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    favorites = relationship("Favorite", back_populates="event", cascade="all, delete-orphan")
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
            "status": self.status,
            "session_code": self.session_code,
            "medal_event": self.medal_event,
        }


class User(Base):
    """App user (device-based, no login required)."""

    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    device_token = Column(String(255), nullable=True, unique=True)
    platform = Column(String(10), nullable=True)  # ios/android
    is_premium = Column(Boolean, default=False)
    language = Column(String(5), default="en")  # User's preferred language
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    favorites = relationship("Favorite", back_populates="user", cascade="all, delete-orphan")

    def to_dict(self) -> dict:
        """Convert to dictionary for API response."""
        return {
            "id": str(self.id),
            "platform": self.platform,
            "is_premium": self.is_premium,
            "language": self.language,
        }


class Favorite(Base):
    """User's favorited events."""

    __tablename__ = "favorites"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    event_id = Column(String(50), ForeignKey("events.event_id", ondelete="CASCADE"), primary_key=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="favorites")
    event = relationship("Event", back_populates="favorites")

    __table_args__ = (
        Index("idx_favorites_user", "user_id"),
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
