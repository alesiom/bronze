"""
Article regeneration queue and template versioning.

Part of Phase 5: Scalability Infrastructure.
Enables incremental regeneration when templates or content change.
"""

import hashlib
import os
from pathlib import Path
from typing import Optional
from datetime import datetime

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

log = structlog.get_logger()

# Template paths
TEMPLATES_PATH = Path(os.environ.get("TEMPLATES_PATH", "/app/website/templates"))


def compute_template_hash() -> str:
    """
    Compute a hash of all template files.

    This creates a single version hash that changes when any template changes.
    Used to detect when articles need regeneration.
    """
    hasher = hashlib.sha256()

    template_files = [
        "base.html.j2",
        "article.html.j2",
        "index.html.j2",
        "partials/header.html.j2",
        "partials/footer.html.j2",
        "partials/card.html.j2",
        "partials/headline.html.j2",
    ]

    for template_file in sorted(template_files):
        template_path = TEMPLATES_PATH / template_file
        if template_path.exists():
            hasher.update(template_path.read_bytes())
            hasher.update(template_file.encode())  # Include filename in hash

    return hasher.hexdigest()[:16]  # First 16 chars is enough


async def update_template_version(session: AsyncSession) -> str:
    """
    Update the stored template version hash.

    Call this after deploying template changes.
    Returns the new version hash.
    """
    version_hash = compute_template_hash()

    await session.execute(
        text("""
            INSERT INTO template_versions (template_name, version_hash, updated_at)
            VALUES ('article', :hash, NOW())
            ON CONFLICT (template_name)
            DO UPDATE SET version_hash = :hash, updated_at = NOW()
        """),
        {"hash": version_hash}
    )

    log.info("Template version updated", version=version_hash)
    return version_hash


async def get_current_template_version(session: AsyncSession) -> Optional[str]:
    """Get the current template version hash from database."""
    result = await session.execute(
        text("SELECT version_hash FROM template_versions WHERE template_name = 'article'")
    )
    row = result.fetchone()
    return row[0] if row else None


async def queue_article_regeneration(
    session: AsyncSession,
    slug: str,
    priority: str = "normal",
    reason: str = "manual"
) -> int:
    """
    Add an article to the regeneration queue.

    Args:
        session: Database session
        slug: Article slug
        priority: 'immediate', 'normal', or 'low'
        reason: Reason for regeneration

    Returns:
        Queue item ID
    """
    result = await session.execute(
        text("SELECT queue_regeneration(:slug, :priority, :reason)"),
        {"slug": slug, "priority": priority, "reason": reason}
    )
    queue_id = result.scalar()
    log.info("Article queued for regeneration", slug=slug, priority=priority, reason=reason)
    return queue_id


async def queue_all_articles(session: AsyncSession, reason: str = "template_update") -> int:
    """
    Queue all published articles for regeneration.

    Use after template updates to regenerate all HTML.
    Returns count of articles queued.
    """
    result = await session.execute(
        text("SELECT queue_all_articles(:reason)"),
        {"reason": reason}
    )
    count = result.scalar()
    log.info("All articles queued for regeneration", count=count, reason=reason)
    return count


async def get_next_queue_item(session: AsyncSession) -> Optional[dict]:
    """
    Get and lock the next item from the regeneration queue.

    Returns None if queue is empty.
    """
    result = await session.execute(text("SELECT * FROM get_next_queue_item()"))
    row = result.fetchone()

    if row:
        return {
            "id": row[0],
            "article_slug": row[1],
            "priority": row[2],
            "reason": row[3],
        }
    return None


async def complete_queue_item(
    session: AsyncSession,
    item_id: int,
    success: bool = True,
    error: Optional[str] = None
) -> None:
    """Mark a queue item as completed or failed."""
    await session.execute(
        text("SELECT complete_queue_item(:id, :success, :error)"),
        {"id": item_id, "success": success, "error": error}
    )


async def mark_article_regenerated(
    session: AsyncSession,
    slug: str,
    template_version: str
) -> None:
    """
    Mark an article as regenerated with current template version.

    Call after successfully generating HTML for an article.
    """
    await session.execute(
        text("""
            UPDATE articles
            SET template_version = :version,
                html_generated_at = NOW()
            WHERE slug = :slug
        """),
        {"slug": slug, "version": template_version}
    )


async def get_articles_needing_regeneration(
    session: AsyncSession,
    limit: int = 100
) -> list:
    """
    Get articles that need regeneration.

    Returns articles where:
    - template_version is outdated
    - content was updated after last HTML generation
    - HTML has never been generated
    """
    result = await session.execute(
        text("""
            SELECT slug, category, current_version, latest_version,
                   html_generated_at, content_updated_at
            FROM articles_needing_regeneration
            LIMIT :limit
        """),
        {"limit": limit}
    )

    return [
        {
            "slug": row[0],
            "category": row[1],
            "current_version": row[2],
            "latest_version": row[3],
            "html_generated_at": row[4],
            "content_updated_at": row[5],
        }
        for row in result.fetchall()
    ]


async def get_queue_summary(session: AsyncSession) -> dict:
    """Get summary of regeneration queue status."""
    result = await session.execute(
        text("SELECT status, priority, count, oldest, newest FROM regeneration_queue_summary")
    )

    summary = {"pending": {}, "processing": {}}
    for row in result.fetchall():
        status, priority, count, oldest, newest = row
        summary[status][priority] = {
            "count": count,
            "oldest": oldest,
            "newest": newest,
        }

    return summary


async def process_regeneration_queue(
    session: AsyncSession,
    generate_html_func,
    max_items: int = 10
) -> dict:
    """
    Process items from the regeneration queue.

    Args:
        session: Database session
        generate_html_func: Async function to generate HTML for a slug
        max_items: Maximum items to process in this batch

    Returns:
        Dict with processed, succeeded, failed counts
    """
    processed = 0
    succeeded = 0
    failed = 0

    template_version = await get_current_template_version(session)

    for _ in range(max_items):
        item = await get_next_queue_item(session)
        if not item:
            break

        processed += 1

        try:
            # Generate HTML
            await generate_html_func(item["article_slug"])

            # Mark article with current template version
            await mark_article_regenerated(
                session,
                item["article_slug"],
                template_version
            )

            # Mark queue item complete
            await complete_queue_item(session, item["id"], success=True)
            succeeded += 1

            log.info(
                "Article regenerated",
                slug=item["article_slug"],
                reason=item["reason"]
            )

        except Exception as e:
            await complete_queue_item(
                session,
                item["id"],
                success=False,
                error=str(e)
            )
            failed += 1

            log.error(
                "Article regeneration failed",
                slug=item["article_slug"],
                error=str(e)
            )

        await session.commit()

    return {
        "processed": processed,
        "succeeded": succeeded,
        "failed": failed,
    }
