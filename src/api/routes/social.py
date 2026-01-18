"""Social media post tracking endpoints."""

from typing import Optional

from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from src.db import (
    get_session,
    get_recent_social_posts,
    create_social_post,
    get_content_type_counts,
)

log = structlog.get_logger()
router = APIRouter(prefix="/social-posts", tags=["social"])


# ============================================================================
# Pydantic Models
# ============================================================================

class SocialPostCreate(BaseModel):
    """Request body for creating a social post record."""
    content_type: str
    post_text: str
    platform: str
    athletes_mentioned: Optional[list[str]] = None
    sports_mentioned: Optional[list[str]] = None
    topics: Optional[list[str]] = None
    late_post_id: Optional[str] = None


class SocialPostResponse(BaseModel):
    """Response model for a social post."""
    id: int
    content_type: str
    post_text: str
    platform: str
    posted_at: str
    athletes_mentioned: list[str]
    sports_mentioned: list[str]
    topics: list[str]


class RecentPostsResponse(BaseModel):
    """Response model for recent posts endpoint."""
    posts: list[SocialPostResponse]
    content_type_counts: dict[str, int]


# ============================================================================
# Dependencies
# ============================================================================

async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


# ============================================================================
# Endpoints
# ============================================================================

@router.get("/recent", response_model=RecentPostsResponse)
async def list_recent_posts(
    platform: Optional[str] = Query(None, description="Filter by platform (twitter, instagram)"),
    limit: int = Query(10, ge=1, le=50, description="Number of posts to return"),
    session: AsyncSession = Depends(get_db),
):
    """
    Get recent social posts for content variety tracking.

    Used by n8n workflow to know what was posted recently
    and avoid repetitive content.
    """
    posts = await get_recent_social_posts(session, platform=platform, limit=limit)
    counts = await get_content_type_counts(session, days=3, platform=platform)

    return RecentPostsResponse(
        posts=[
            SocialPostResponse(
                id=p.id,
                content_type=p.content_type,
                post_text=p.post_text,
                platform=p.platform,
                posted_at=p.posted_at.isoformat() if p.posted_at else "",
                athletes_mentioned=p.athletes_mentioned or [],
                sports_mentioned=p.sports_mentioned or [],
                topics=p.topics or [],
            )
            for p in posts
        ],
        content_type_counts=counts,
    )


@router.post("", response_model=SocialPostResponse, status_code=201)
async def record_social_post(
    post_data: SocialPostCreate,
    session: AsyncSession = Depends(get_db),
):
    """
    Record a social post after successful publishing.

    Called by n8n workflow after Late.dev successfully posts.
    """
    post = await create_social_post(
        session,
        content_type=post_data.content_type,
        post_text=post_data.post_text,
        platform=post_data.platform,
        athletes_mentioned=post_data.athletes_mentioned,
        sports_mentioned=post_data.sports_mentioned,
        topics=post_data.topics,
        late_post_id=post_data.late_post_id,
    )
    await session.commit()

    log.info("Social post recorded", content_type=post.content_type, platform=post.platform)

    return SocialPostResponse(
        id=post.id,
        content_type=post.content_type,
        post_text=post.post_text,
        platform=post.platform,
        posted_at=post.posted_at.isoformat() if post.posted_at else "",
        athletes_mentioned=post.athletes_mentioned or [],
        sports_mentioned=post.sports_mentioned or [],
        topics=post.topics or [],
    )
