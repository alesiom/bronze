"""Event endpoints for schedule browsing."""

from datetime import date
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from src.db import (
    get_session,
    get_all_events,
    get_event_by_id,
    get_live_events,
    get_upcoming_events,
    get_sports,
    get_venues,
)
from src.api.models import (
    EventResponse,
    EventListResponse,
    SportResponse,
    VenueResponse,
)

log = structlog.get_logger()
router = APIRouter(prefix="/events", tags=["events"])


async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


@router.get("", response_model=EventListResponse)
async def list_events(
    sport_code: Optional[str] = Query(None, description="Filter by sport code (e.g., ALP, BTH)"),
    venue_city: Optional[str] = Query(None, description="Filter by venue city"),
    event_date: Optional[date] = Query(None, alias="date", description="Filter by date (YYYY-MM-DD)"),
    medal_only: bool = Query(False, description="Only show medal events"),
    include_past: bool = Query(False, description="Include past events"),
    session: AsyncSession = Depends(get_db),
):
    """
    Get schedule events with optional filters.

    By default, only future events are returned, sorted by date and time.
    """
    events = await get_all_events(
        session,
        sport_code=sport_code,
        venue_city=venue_city,
        event_date=event_date,
        include_past=include_past,
        medal_only=medal_only,
    )

    return EventListResponse(
        events=[EventResponse.model_validate(e) for e in events],
        total=len(events),
    )


@router.get("/live", response_model=EventListResponse)
async def list_live_events(
    session: AsyncSession = Depends(get_db),
):
    """
    Get events currently in progress.

    Returns events that started within the last 2 hours.
    """
    events = await get_live_events(session)

    return EventListResponse(
        events=[EventResponse.model_validate(e) for e in events],
        total=len(events),
    )


@router.get("/upcoming", response_model=EventListResponse)
async def list_upcoming_events(
    hours: int = Query(24, ge=1, le=72, description="Hours to look ahead"),
    limit: int = Query(50, ge=1, le=200, description="Maximum events to return"),
    session: AsyncSession = Depends(get_db),
):
    """
    Get events starting in the next N hours.
    """
    events = await get_upcoming_events(session, hours=hours, limit=limit)

    return EventListResponse(
        events=[EventResponse.model_validate(e) for e in events],
        total=len(events),
    )


@router.get("/sports", response_model=list[SportResponse])
async def list_sports(
    session: AsyncSession = Depends(get_db),
):
    """
    Get list of all sports.
    """
    sports = await get_sports(session)
    return [SportResponse(**s) for s in sports]


@router.get("/venues", response_model=list[VenueResponse])
async def list_venues(
    session: AsyncSession = Depends(get_db),
):
    """
    Get list of all venues.
    """
    venues = await get_venues(session)
    return [VenueResponse(**v) for v in venues]


@router.get("/{event_id}", response_model=EventResponse)
async def get_event(
    event_id: str,
    session: AsyncSession = Depends(get_db),
):
    """
    Get a single event by ID.
    """
    event = await get_event_by_id(session, event_id)

    if not event:
        raise HTTPException(status_code=404, detail="Event not found")

    return EventResponse.model_validate(event)
