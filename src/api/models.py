"""Pydantic models for API request/response schemas."""

from datetime import date, time as dt_time, datetime
from typing import Optional, Any
from uuid import UUID

from pydantic import BaseModel, Field, field_serializer


# ============================================================================
# Event Schemas
# ============================================================================

class EventBase(BaseModel):
    """Base event schema."""
    event_id: str
    sport: str
    sport_code: str
    event_name: str
    date: date
    time: Optional[dt_time] = None
    venue: Optional[str] = None
    venue_city: Optional[str] = None
    status: str = "scheduled"
    session_code: Optional[str] = None
    medal_event: bool = False

    @field_serializer('time')
    def serialize_time(self, value: Optional[dt_time]) -> Optional[str]:
        if value is None:
            return None
        return value.isoformat()


class EventResponse(EventBase):
    """Event response with computed fields."""

    class Config:
        from_attributes = True


class EventListResponse(BaseModel):
    """Response for list of events."""
    events: list[EventResponse]
    total: int


# ============================================================================
# Sport/Venue Schemas
# ============================================================================

class SportResponse(BaseModel):
    """Sport info."""
    code: str
    name: str


class VenueResponse(BaseModel):
    """Venue info."""
    venue: str
    city: str


# ============================================================================
# Device Schemas
# ============================================================================

class DeviceRegister(BaseModel):
    """Register device for push notifications."""
    token: str = Field(..., description="FCM or APNs device token")
    platform: str = Field(..., pattern="^(ios|android)$")


class DeviceResponse(BaseModel):
    """Device registration response."""
    id: UUID
    platform: str

    class Config:
        from_attributes = True


# ============================================================================
# Favorite Schemas
# ============================================================================

class FavoritesSync(BaseModel):
    """Bulk sync favorites - replaces all favorites with this list."""
    event_ids: list[str] = Field(..., description="List of event IDs to sync as favorites")


class FavoritesSyncResponse(BaseModel):
    """Response after syncing favorites."""
    synced: int = Field(..., description="Number of favorites synced")
    event_ids: list[str]


# ============================================================================
# Schedule Change Schemas
# ============================================================================

class ScheduleChangeResponse(BaseModel):
    """Schedule change notification."""
    id: UUID
    event_id: str
    change_type: str
    old_value: Optional[str] = None
    new_value: Optional[str] = None
    detected_at: datetime
    event: Optional[EventResponse] = None

    class Config:
        from_attributes = True


# ============================================================================
# Filter Schemas
# ============================================================================

class EventFilters(BaseModel):
    """Query parameters for filtering events."""
    sport_code: Optional[str] = None
    venue_city: Optional[str] = None
    date: Optional[date] = None
    medal_only: bool = False
    include_past: bool = False


# ============================================================================
# Health/Status Schemas
# ============================================================================

class HealthResponse(BaseModel):
    """Health check response."""
    status: str = "healthy"
    version: str = "0.1.0"
    timestamp: datetime


class StatsResponse(BaseModel):
    """API statistics."""
    total_events: int
    total_devices: int
    total_favorites: int
    last_scrape: Optional[datetime] = None
