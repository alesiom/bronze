"""Database query functions for Bronze."""

from datetime import date, datetime, time, timedelta
from typing import Optional
from uuid import UUID

from sqlalchemy import delete, select, update, and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from .models import Event, Device, Favorite, ScheduleChange, ScrapeLog, Article, SocialPost

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
# Device Queries
# ============================================================================

async def register_device(
    session: AsyncSession,
    token: str,
    platform: str,
) -> Device:
    """Register a device for push notifications. Returns existing device if token already registered."""
    # Check if device with this token already exists
    result = await session.execute(
        select(Device).where(Device.token == token)
    )
    device = result.scalar_one_or_none()
    if device:
        # Update platform if changed
        if device.platform != platform:
            device.platform = platform
            await session.flush()
        return device

    # Create new device
    device = Device(token=token, platform=platform)
    session.add(device)
    await session.flush()
    return device


async def get_device_by_id(session: AsyncSession, device_id: UUID) -> Optional[Device]:
    """Get device by ID."""
    result = await session.execute(
        select(Device).where(Device.id == device_id)
    )
    return result.scalar_one_or_none()


# ============================================================================
# Favorites Queries
# ============================================================================

async def sync_favorites(
    session: AsyncSession,
    device_id: UUID,
    event_ids: list[str],
) -> int:
    """
    Bulk sync favorites - replaces all device favorites with the provided list.
    Returns the number of favorites synced.
    """
    # Delete all existing favorites for this device
    await session.execute(
        delete(Favorite).where(Favorite.device_id == device_id)
    )

    # Add new favorites
    for event_id in event_ids:
        favorite = Favorite(device_id=device_id, event_id=event_id)
        session.add(favorite)

    await session.flush()
    return len(event_ids)


async def get_device_favorites(
    session: AsyncSession,
    device_id: UUID,
) -> list[str]:
    """Get list of event IDs favorited by this device."""
    result = await session.execute(
        select(Favorite.event_id).where(Favorite.device_id == device_id)
    )
    return [row[0] for row in result.all()]


async def get_devices_with_favorite(
    session: AsyncSession,
    event_id: str,
) -> list[Device]:
    """Get all devices that have favorited a specific event (for push notifications)."""
    result = await session.execute(
        select(Device)
        .join(Favorite)
        .where(Favorite.event_id == event_id)
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


# ============================================================================
# Article Queries
# ============================================================================

async def get_articles(
    session: AsyncSession,
    category: Optional[str] = None,
    sport_code: Optional[str] = None,
    limit: int = 20,
    offset: int = 0,
) -> tuple[list[Article], int]:
    """
    Get published articles with optional filters.

    Returns:
        Tuple of (articles list, total count)
    """
    # Base query for published articles
    base_filter = Article.status == "published"

    filters = [base_filter]

    if category:
        filters.append(Article.category == category)

    if sport_code:
        filters.append(Article.sport_code == sport_code.upper())

    # Count total
    count_query = select(Article).where(and_(*filters))
    count_result = await session.execute(count_query)
    total = len(count_result.scalars().all())

    # Get paginated results
    query = (
        select(Article)
        .where(and_(*filters))
        .order_by(Article.published_at.desc())
        .offset(offset)
        .limit(limit)
    )

    result = await session.execute(query)
    return list(result.scalars().all()), total


async def get_article_by_slug(session: AsyncSession, slug: str) -> Optional[Article]:
    """Get a single article by slug."""
    result = await session.execute(
        select(Article).where(Article.slug == slug)
    )
    return result.scalar_one_or_none()


async def get_featured_articles(
    session: AsyncSession,
    limit: int = 5,
) -> list[Article]:
    """Get most recent published articles as featured."""
    result = await session.execute(
        select(Article)
        .where(Article.status == "published")
        .order_by(Article.published_at.desc())
        .limit(limit)
    )
    return list(result.scalars().all())


async def create_article(session: AsyncSession, article_data: dict) -> Article:
    """Create a new article."""
    article = Article(**article_data)
    session.add(article)
    await session.flush()
    return article


async def update_article(
    session: AsyncSession,
    slug: str,
    article_data: dict,
) -> Optional[Article]:
    """Update an existing article."""
    article = await get_article_by_slug(session, slug)
    if not article:
        return None

    for key, value in article_data.items():
        if hasattr(article, key):
            setattr(article, key, value)

    await session.flush()
    return article


async def publish_article(session: AsyncSession, slug: str) -> Optional[Article]:
    """Publish an article (set status and published_at)."""
    article = await get_article_by_slug(session, slug)
    if not article:
        return None

    article.status = "published"
    article.published_at = datetime.utcnow()
    await session.flush()
    return article


# ============================================================================
# Social Post Queries
# ============================================================================

async def get_recent_social_posts(
    session: AsyncSession,
    platform: Optional[str] = None,
    limit: int = 10,
) -> list[SocialPost]:
    """
    Get recent social posts for content variety tracking.

    Args:
        session: Database session
        platform: Filter by platform (twitter, instagram)
        limit: Number of recent posts to return

    Returns:
        List of recent SocialPost objects, newest first
    """
    query = select(SocialPost)

    if platform:
        query = query.where(SocialPost.platform == platform)

    query = query.order_by(SocialPost.posted_at.desc()).limit(limit)

    result = await session.execute(query)
    return list(result.scalars().all())


async def create_social_post(
    session: AsyncSession,
    content_type: str,
    post_text: str,
    platform: str,
    athletes_mentioned: Optional[list[str]] = None,
    sports_mentioned: Optional[list[str]] = None,
    topics: Optional[list[str]] = None,
    late_post_id: Optional[str] = None,
) -> SocialPost:
    """
    Create a new social post record.

    Args:
        session: Database session
        content_type: Type of content (quote, race_preview, etc.)
        post_text: The actual post text
        platform: Platform posted to (twitter, instagram)
        athletes_mentioned: List of athlete slugs mentioned
        sports_mentioned: List of sport codes mentioned
        topics: List of topic tags
        late_post_id: ID from Late.dev API response

    Returns:
        Created SocialPost object
    """
    post = SocialPost(
        content_type=content_type,
        post_text=post_text,
        platform=platform,
        athletes_mentioned=athletes_mentioned,
        sports_mentioned=sports_mentioned,
        topics=topics,
        late_post_id=late_post_id,
    )
    session.add(post)
    await session.flush()
    return post


async def get_content_type_counts(
    session: AsyncSession,
    days: int = 3,
    platform: Optional[str] = None,
) -> dict[str, int]:
    """
    Get counts of each content type posted in the last N days.

    Useful for balancing content variety.
    """
    cutoff = datetime.utcnow() - timedelta(days=days)

    query = select(SocialPost).where(SocialPost.posted_at >= cutoff)

    if platform:
        query = query.where(SocialPost.platform == platform)

    result = await session.execute(query)
    posts = result.scalars().all()

    counts: dict[str, int] = {}
    for post in posts:
        counts[post.content_type] = counts.get(post.content_type, 0) + 1

    return counts
