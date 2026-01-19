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
    country: Optional[str] = None
    status: str = "scheduled"
    session_code: Optional[str] = None
    medal_event: bool = False
    federation: Optional[str] = None  # FIS, IBU, IBSF, FIL, ISU, WCF, IOC
    series: Optional[str] = None  # World Cup, Tour de Ski, Four Hills, etc.

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


class EventCreate(BaseModel):
    """Schema for creating/importing an event."""
    event_id: str
    sport: str
    sport_code: str
    event_name: str
    date: date
    time: Optional[dt_time] = None
    venue: Optional[str] = None
    venue_city: Optional[str] = None
    country: Optional[str] = None
    status: str = "scheduled"
    session_code: Optional[str] = None
    medal_event: bool = False
    federation: Optional[str] = None
    series: Optional[str] = None


class EventBulkImport(BaseModel):
    """Schema for bulk importing events."""
    events: list[EventCreate]
    replace_all: bool = False  # If True, delete existing events first


class EventBulkImportResponse(BaseModel):
    """Response for bulk import."""
    imported: int
    message: str


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


# ============================================================================
# Article Schemas
# ============================================================================

class ArticleBase(BaseModel):
    """Base article schema with localized fields."""
    slug: str
    title: str
    excerpt: Optional[str] = None
    category: str
    sport_code: Optional[str] = None
    venue: Optional[str] = None
    venue_city: Optional[str] = None
    featured_image: Optional[str] = None
    image_alt: Optional[str] = None
    published_at: Optional[datetime] = None


class ArticleListItem(ArticleBase):
    """Article item for list responses (no full content)."""
    id: int

    class Config:
        from_attributes = True


class ArticleDetail(ArticleBase):
    """Full article with content."""
    id: int
    content: str
    athlete_slugs: list[str] = []
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class ArticleListResponse(BaseModel):
    """Response for list of articles."""
    articles: list[ArticleListItem]
    total: int
    limit: int
    offset: int


class ArticleCreate(BaseModel):
    """Schema for creating an article (used by n8n webhook)."""
    slug: str
    title: dict[str, str]  # {"en": "...", "de": "...", ...}
    excerpt: Optional[dict[str, str]] = None
    content: dict[str, str]
    category: str
    sport_code: Optional[str] = None
    athlete_slugs: Optional[list[str]] = None
    event_id: Optional[str] = None
    venue: Optional[str] = None
    venue_city: Optional[str] = None
    meta_description: Optional[dict[str, str]] = None
    featured_image: Optional[str] = None
    image_alt: Optional[dict[str, str]] = None
    image_credit: Optional[str] = None
    status: str = "draft"
    source_type: Optional[str] = None
    source_data: Optional[dict] = None


class ArticleRaw(BaseModel):
    """Raw article with JSONB fields intact (for n8n HTML generator)."""
    id: int
    slug: str
    title: dict[str, str]
    excerpt: Optional[dict[str, str]] = None
    content: dict[str, str]
    meta_description: Optional[dict[str, str]] = None
    category: str
    sport_code: Optional[str] = None
    athlete_slugs: list[str] = []
    venue: Optional[str] = None
    venue_city: Optional[str] = None
    featured_image: Optional[str] = None
    image_alt: Optional[dict[str, str]] = None
    published_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    structured_data: Optional[dict] = None

    class Config:
        from_attributes = True


class ArticleTranslationUpdate(BaseModel):
    """Schema for updating article translations."""
    lang: str = Field(..., description="Language code (de, fr, it, es, pt, nl, ar, ja, zh, ko)")
    title: str = Field(..., description="Translated title")
    excerpt: Optional[str] = Field(None, description="Translated excerpt")
    content: str = Field(..., description="Translated content with HTML preserved")
    meta_description: Optional[str] = Field(None, description="Translated meta description")
