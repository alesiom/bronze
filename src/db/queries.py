"""Database query functions for Neve26."""

from datetime import date, datetime, time, timedelta
from typing import Optional
from uuid import UUID

from sqlalchemy import delete, select, update, and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from .models import Event, User, Favorite, ScheduleChange, ScrapeLog

log = structlog.get_logger()


# ============================================================================
# Event Queries
# ============================================================================

async def get_all_events(
    session: AsyncSession,
    sport_code: Optional[str] = None,
    venue_city: Optional[str] = None,
    event_date: Optional[date] = None,
    include_past: bool = False,
    medal_only: bool = False,
) -> list[Event]:
    """
    Get events with optional filters.

    Args:
        session: Database session
        sport_code: Filter by sport code (e.g., "ALP")
        venue_city: Filter by venue city
        event_date: Filter by specific date
        include_past: Include past events (default: False)
        medal_only: Only return medal events

    Returns:
        List of Event objects sorted by date and time
    """
    query = select(Event)

    filters = []

    if sport_code:
        filters.append(Event.sport_code == sport_code.upper())

    if venue_city:
        filters.append(Event.venue_city == venue_city)

    if event_date:
        filters.append(Event.date == event_date)

    if not include_past:
        today = date.today()
        filters.append(Event.date >= today)

    if medal_only:
        filters.append(Event.medal_event == True)

    if filters:
        query = query.where(and_(*filters))

    query = query.order_by(Event.date, Event.time)

    result = await session.execute(query)
    return list(result.scalars().all())


async def get_event_by_id(session: AsyncSession, event_id: str) -> Optional[Event]:
    """Get a single event by ID."""
    result = await session.execute(
        select(Event).where(Event.event_id == event_id)
    )
    return result.scalar_one_or_none()


async def get_live_events(session: AsyncSession) -> list[Event]:
    """
    Get events happening right now (within 2 hours of current time).
    """
    now = datetime.now()
    current_date = now.date()
    current_time = now.time()

    # Events that started in the last 2 hours
    two_hours_ago = (now - timedelta(hours=2)).time()

    result = await session.execute(
        select(Event)
        .where(
            and_(
                Event.date == current_date,
                Event.time >= two_hours_ago,
                Event.time <= current_time,
            )
        )
        .order_by(Event.time)
    )
    return list(result.scalars().all())


async def get_upcoming_events(
    session: AsyncSession,
    hours: int = 24,
    limit: int = 50,
) -> list[Event]:
    """Get events starting in the next N hours."""
    now = datetime.now()
    end_time = now + timedelta(hours=hours)

    result = await session.execute(
        select(Event)
        .where(
            or_(
                # Today after current time
                and_(
                    Event.date == now.date(),
                    Event.time >= now.time(),
                ),
                # Tomorrow (if within window)
                and_(
                    Event.date == end_time.date(),
                    Event.time <= end_time.time(),
                ) if end_time.date() > now.date() else False,
            )
        )
        .order_by(Event.date, Event.time)
        .limit(limit)
    )
    return list(result.scalars().all())


async def upsert_events(session: AsyncSession, events: list[dict]) -> int:
    """
    Insert or update events from scraper.

    Returns:
        Number of events upserted
    """
    count = 0
    for event_data in events:
        event_id = event_data.get("event_id")
        if not event_id:
            continue

        existing = await get_event_by_id(session, event_id)

        if existing:
            # Update existing event
            for key, value in event_data.items():
                if key != "event_id" and hasattr(existing, key):
                    setattr(existing, key, value)
            existing.updated_at = datetime.utcnow()
        else:
            # Create new event
            # Parse date and time strings if needed
            if isinstance(event_data.get("date"), str):
                event_data["date"] = date.fromisoformat(event_data["date"])
            if isinstance(event_data.get("time"), str):
                event_data["time"] = time.fromisoformat(event_data["time"])

            event = Event(**event_data)
            session.add(event)

        count += 1

    await session.flush()
    return count


async def get_sports(session: AsyncSession) -> list[dict]:
    """Get list of unique sports."""
    result = await session.execute(
        select(Event.sport_code, Event.sport)
        .distinct()
        .order_by(Event.sport)
    )
    return [{"code": row[0], "name": row[1]} for row in result.all()]


async def get_venues(session: AsyncSession) -> list[dict]:
    """Get list of unique venues with cities."""
    result = await session.execute(
        select(Event.venue, Event.venue_city)
        .distinct()
        .order_by(Event.venue_city, Event.venue)
    )
    return [{"venue": row[0], "city": row[1]} for row in result.all()]


# ============================================================================
# User Queries
# ============================================================================

async def get_or_create_user(
    session: AsyncSession,
    device_token: Optional[str] = None,
    platform: Optional[str] = None,
) -> User:
    """Get existing user by device token or create new one."""
    if device_token:
        result = await session.execute(
            select(User).where(User.device_token == device_token)
        )
        user = result.scalar_one_or_none()
        if user:
            return user

    # Create new user
    user = User(device_token=device_token, platform=platform)
    session.add(user)
    await session.flush()
    return user


async def update_user_token(
    session: AsyncSession,
    user_id: UUID,
    device_token: str,
    platform: str,
) -> Optional[User]:
    """Update user's device token for push notifications."""
    result = await session.execute(
        select(User).where(User.id == user_id)
    )
    user = result.scalar_one_or_none()
    if user:
        user.device_token = device_token
        user.platform = platform
        await session.flush()
    return user


# ============================================================================
# Favorites Queries
# ============================================================================

async def get_user_favorites(
    session: AsyncSession,
    user_id: UUID,
    include_past: bool = False,
) -> list[Event]:
    """Get user's favorited events."""
    query = (
        select(Event)
        .join(Favorite)
        .where(Favorite.user_id == user_id)
    )

    if not include_past:
        query = query.where(Event.date >= date.today())

    query = query.order_by(Event.date, Event.time)

    result = await session.execute(query)
    return list(result.scalars().all())


async def add_favorite(
    session: AsyncSession,
    user_id: UUID,
    event_id: str,
) -> bool:
    """Add event to user's favorites. Returns True if added, False if already exists."""
    # Check if already favorited
    result = await session.execute(
        select(Favorite).where(
            and_(Favorite.user_id == user_id, Favorite.event_id == event_id)
        )
    )
    if result.scalar_one_or_none():
        return False

    favorite = Favorite(user_id=user_id, event_id=event_id)
    session.add(favorite)
    await session.flush()
    return True


async def remove_favorite(
    session: AsyncSession,
    user_id: UUID,
    event_id: str,
) -> bool:
    """Remove event from user's favorites. Returns True if removed."""
    result = await session.execute(
        delete(Favorite).where(
            and_(Favorite.user_id == user_id, Favorite.event_id == event_id)
        )
    )
    return result.rowcount > 0


async def get_users_with_favorite(
    session: AsyncSession,
    event_id: str,
) -> list[User]:
    """Get all users who favorited a specific event (for notifications)."""
    result = await session.execute(
        select(User)
        .join(Favorite)
        .where(Favorite.event_id == event_id)
        .where(User.device_token.isnot(None))
    )
    return list(result.scalars().all())


# ============================================================================
# Schedule Change Queries
# ============================================================================

async def record_change(
    session: AsyncSession,
    event_id: str,
    change_type: str,
    old_value: Optional[str],
    new_value: Optional[str],
) -> ScheduleChange:
    """Record a schedule change for notification."""
    change = ScheduleChange(
        event_id=event_id,
        change_type=change_type,
        old_value=old_value,
        new_value=new_value,
    )
    session.add(change)
    await session.flush()
    return change


async def get_pending_notifications(session: AsyncSession) -> list[ScheduleChange]:
    """Get changes that haven't been notified yet."""
    result = await session.execute(
        select(ScheduleChange)
        .where(ScheduleChange.notified == False)
        .order_by(ScheduleChange.detected_at)
    )
    return list(result.scalars().all())


async def mark_notified(session: AsyncSession, change_ids: list[UUID]) -> None:
    """Mark changes as notified."""
    await session.execute(
        update(ScheduleChange)
        .where(ScheduleChange.id.in_(change_ids))
        .values(notified=True)
    )


# ============================================================================
# Scrape Log Queries
# ============================================================================

async def create_scrape_log(session: AsyncSession) -> ScrapeLog:
    """Create a new scrape log entry."""
    log_entry = ScrapeLog()
    session.add(log_entry)
    await session.flush()
    return log_entry


async def complete_scrape_log(
    session: AsyncSession,
    log_id: UUID,
    events_found: int,
    changes_detected: int,
    status: str = "success",
    error_message: Optional[str] = None,
) -> None:
    """Complete a scrape log entry."""
    await session.execute(
        update(ScrapeLog)
        .where(ScrapeLog.id == log_id)
        .values(
            completed_at=datetime.utcnow(),
            events_found=str(events_found),
            changes_detected=str(changes_detected),
            status=status,
            error_message=error_message,
        )
    )
