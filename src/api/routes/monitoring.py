"""
Monitoring and health check endpoints.

Provides:
- /health - Quick health check
- /health/detailed - Detailed system health
- /health/report - Daily health report
- /queue/status - Regeneration queue status
- /queue/process - Trigger queue processing
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import Optional

from src.db import get_session
from src.api.monitoring import (
    check_system_health,
    generate_daily_report,
    get_queue_stats,
    send_alert,
)
from src.api.regeneration import (
    get_queue_summary,
    queue_all_articles,
    queue_article_regeneration,
    update_template_version,
    process_regeneration_queue,
)

router = APIRouter(tags=["monitoring"])


async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


# =============================================================================
# Health Endpoints
# =============================================================================

@router.get("/health")
async def health_check():
    """
    Simple health check for load balancers.

    Returns 200 if API is running.
    """
    return {"status": "ok"}


@router.get("/health/detailed")
async def detailed_health_check(session: AsyncSession = Depends(get_db)):
    """
    Detailed health check including database, templates, and queue.

    Use for monitoring dashboards.
    """
    return await check_system_health(session)


@router.get("/health/report")
async def daily_health_report(session: AsyncSession = Depends(get_db)):
    """
    Generate daily health report.

    Called by n8n cron job. Sends alerts for issues.
    """
    return await generate_daily_report(session)


# =============================================================================
# Queue Management Endpoints
# =============================================================================

class QueueArticleRequest(BaseModel):
    slug: str
    priority: str = "normal"
    reason: str = "manual"


class QueueAllRequest(BaseModel):
    reason: str = "template_update"


class ProcessQueueRequest(BaseModel):
    max_items: int = 10


@router.get("/queue/status")
async def queue_status(session: AsyncSession = Depends(get_db)):
    """Get current regeneration queue status."""
    summary = await get_queue_summary(session)
    stats = await get_queue_stats(session)

    return {
        "summary": summary,
        "stats_24h": stats,
    }


@router.post("/queue/article")
async def queue_single_article(
    request: QueueArticleRequest,
    session: AsyncSession = Depends(get_db)
):
    """Add a single article to the regeneration queue."""
    queue_id = await queue_article_regeneration(
        session,
        request.slug,
        request.priority,
        request.reason
    )
    await session.commit()

    return {
        "success": True,
        "queue_id": queue_id,
        "slug": request.slug,
    }


@router.post("/queue/all")
async def queue_all(
    request: QueueAllRequest,
    session: AsyncSession = Depends(get_db)
):
    """
    Queue all published articles for regeneration.

    Use after template updates.
    """
    count = await queue_all_articles(session, request.reason)
    await session.commit()

    return {
        "success": True,
        "articles_queued": count,
        "reason": request.reason,
    }


@router.post("/queue/process")
async def process_queue(
    request: ProcessQueueRequest,
    session: AsyncSession = Depends(get_db)
):
    """
    Process items from the regeneration queue.

    This is called by a background worker or cron job.
    """
    # Import here to avoid circular imports
    from src.api.routes.articles import generate_article_html_internal

    result = await process_regeneration_queue(
        session,
        generate_article_html_internal,
        request.max_items
    )

    return {
        "success": True,
        **result,
    }


@router.post("/templates/update-version")
async def update_templates(session: AsyncSession = Depends(get_db)):
    """
    Update template version hash.

    Call after deploying new templates to mark all articles as needing regeneration.
    """
    version = await update_template_version(session)
    await session.commit()

    return {
        "success": True,
        "new_version": version,
    }


# =============================================================================
# Alert Testing
# =============================================================================

class TestAlertRequest(BaseModel):
    message: str = "Test alert from Neve26"
    severity: str = "info"


@router.post("/alerts/test")
async def test_alert(request: TestAlertRequest):
    """Send a test alert to verify webhook configuration."""
    success = await send_alert(
        alert_type="test",
        message=request.message,
        severity=request.severity,
        details={"source": "manual_test"}
    )

    return {
        "success": success,
        "message": "Alert sent" if success else "Alert failed - check webhook configuration",
    }
