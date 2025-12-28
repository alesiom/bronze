"""Health check and status endpoints."""

from datetime import datetime

from fastapi import APIRouter, Depends
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from src.db import get_session, Event, User, Favorite, ScrapeLog
from src.api.models import HealthResponse, StatsResponse

router = APIRouter(tags=["health"])


async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """
    Health check endpoint.

    Used by load balancers and monitoring.
    """
    return HealthResponse(
        status="healthy",
        version="0.1.0",
        timestamp=datetime.utcnow(),
    )


@router.get("/stats", response_model=StatsResponse)
async def get_stats(
    session: AsyncSession = Depends(get_db),
):
    """
    Get API statistics.
    """
    # Count events
    event_count = await session.execute(select(func.count(Event.event_id)))
    total_events = event_count.scalar() or 0

    # Count users
    user_count = await session.execute(select(func.count(User.id)))
    total_users = user_count.scalar() or 0

    # Count favorites
    fav_count = await session.execute(select(func.count()).select_from(Favorite))
    total_favorites = fav_count.scalar() or 0

    # Last successful scrape
    last_scrape_result = await session.execute(
        select(ScrapeLog.completed_at)
        .where(ScrapeLog.status == "success")
        .order_by(ScrapeLog.completed_at.desc())
        .limit(1)
    )
    last_scrape = last_scrape_result.scalar()

    return StatsResponse(
        total_events=total_events,
        total_users=total_users,
        total_favorites=total_favorites,
        last_scrape=last_scrape,
    )
