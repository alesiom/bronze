"""
Monitoring and health reporting for Neve26.

Part of Phase 6: Agent-Driven Monitoring.
Provides health checks, daily reports, and alerting.
"""

import os
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession
import structlog
import httpx

log = structlog.get_logger()

# Alert webhook (n8n)
ALERT_WEBHOOK_URL = os.environ.get("ALERT_WEBHOOK_URL", "")

# HTML output path
HTML_OUTPUT_PATH = Path(os.environ.get("HTML_OUTPUT_PATH", "/var/www/neve26.com"))


async def send_alert(
    alert_type: str,
    message: str,
    details: Optional[dict] = None,
    severity: str = "warning"
) -> bool:
    """
    Send alert via n8n webhook.

    Args:
        alert_type: Type of alert (legal_violation, generation_failure, etc.)
        message: Human-readable message
        details: Additional context
        severity: 'info', 'warning', 'error', 'critical'

    Returns:
        True if alert sent successfully
    """
    if not ALERT_WEBHOOK_URL:
        log.warning("Alert webhook not configured", alert_type=alert_type)
        return False

    payload = {
        "type": alert_type,
        "message": message,
        "severity": severity,
        "timestamp": datetime.utcnow().isoformat(),
        "details": details or {},
    }

    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                ALERT_WEBHOOK_URL,
                json=payload,
                timeout=10.0
            )
            response.raise_for_status()

        log.info("Alert sent", alert_type=alert_type, severity=severity)
        return True

    except Exception as e:
        log.error("Failed to send alert", alert_type=alert_type, error=str(e))
        return False


async def get_validation_stats(session: AsyncSession, days: int = 7) -> dict:
    """Get validation rejection statistics for the past N days."""
    result = await session.execute(
        text("""
            SELECT
                rejection_type,
                severity,
                COUNT(*) as count
            FROM validation_rejections
            WHERE created_at > NOW() - INTERVAL ':days days'
            GROUP BY rejection_type, severity
            ORDER BY count DESC
        """.replace(":days", str(days)))
    )

    stats = {}
    for row in result.fetchall():
        rejection_type, severity, count = row
        if rejection_type not in stats:
            stats[rejection_type] = {}
        stats[rejection_type][severity] = count

    return stats


async def get_article_stats(session: AsyncSession) -> dict:
    """Get article statistics."""
    result = await session.execute(
        text("""
            SELECT
                status,
                COUNT(*) as count,
                COUNT(CASE WHEN published_at > NOW() - INTERVAL '24 hours' THEN 1 END) as last_24h,
                COUNT(CASE WHEN published_at > NOW() - INTERVAL '7 days' THEN 1 END) as last_7d
            FROM articles
            GROUP BY status
        """)
    )

    stats = {}
    for row in result.fetchall():
        status, count, last_24h, last_7d = row
        stats[status] = {
            "total": count,
            "last_24h": last_24h,
            "last_7d": last_7d,
        }

    return stats


async def get_queue_stats(session: AsyncSession) -> dict:
    """Get regeneration queue statistics."""
    result = await session.execute(
        text("""
            SELECT
                status,
                COUNT(*) as count,
                AVG(EXTRACT(EPOCH FROM (
                    CASE WHEN completed_at IS NOT NULL
                    THEN completed_at - created_at
                    ELSE NULL END
                ))) as avg_duration_seconds
            FROM regeneration_queue
            WHERE created_at > NOW() - INTERVAL '24 hours'
            GROUP BY status
        """)
    )

    stats = {}
    for row in result.fetchall():
        status, count, avg_duration = row
        stats[status] = {
            "count": count,
            "avg_duration_seconds": float(avg_duration) if avg_duration else None,
        }

    return stats


def check_html_files_integrity(categories: list = None) -> dict:
    """
    Check that HTML files exist for published articles.

    Returns dict with missing files and integrity status.
    """
    if categories is None:
        categories = [
            "athletes", "venues", "guides", "history",
            "alpine-skiing", "biathlon", "cross-country",
            "ski-jumping", "nordic-combined", "freestyle",
            "snowboard", "news"
        ]

    missing_files = []
    total_files = 0
    existing_files = 0

    for category in categories:
        category_path = HTML_OUTPUT_PATH / category
        if category_path.exists():
            for slug_dir in category_path.iterdir():
                if slug_dir.is_dir():
                    total_files += 1
                    index_file = slug_dir / "index.html"
                    if index_file.exists():
                        existing_files += 1
                    else:
                        missing_files.append(f"{category}/{slug_dir.name}")

    return {
        "total_expected": total_files,
        "existing": existing_files,
        "missing_count": len(missing_files),
        "missing_files": missing_files[:20],  # Limit to first 20
        "integrity_ok": len(missing_files) == 0,
    }


async def generate_daily_report(session: AsyncSession) -> dict:
    """
    Generate daily health report.

    This should be called by n8n on a daily cron schedule.
    """
    report = {
        "generated_at": datetime.utcnow().isoformat(),
        "period": "last_24_hours",
    }

    # Article statistics
    report["articles"] = await get_article_stats(session)

    # Validation statistics
    report["validations"] = await get_validation_stats(session, days=1)

    # Queue statistics
    report["queue"] = await get_queue_stats(session)

    # File integrity check
    report["file_integrity"] = check_html_files_integrity()

    # Summary
    total_published = report["articles"].get("published", {}).get("total", 0)
    new_articles = report["articles"].get("published", {}).get("last_24h", 0)
    legal_rejections = report["validations"].get("legal", {}).get("critical", 0)
    missing_files = report["file_integrity"]["missing_count"]

    report["summary"] = {
        "total_published_articles": total_published,
        "new_articles_24h": new_articles,
        "legal_rejections_24h": legal_rejections,
        "missing_html_files": missing_files,
        "health_status": "healthy" if (legal_rejections == 0 and missing_files == 0) else "warning",
    }

    # Send alert if there are issues
    if legal_rejections > 0:
        await send_alert(
            alert_type="legal_rejection",
            message=f"{legal_rejections} legal violation(s) blocked in the last 24 hours",
            details={"count": legal_rejections},
            severity="critical"
        )

    if missing_files > 0:
        await send_alert(
            alert_type="missing_files",
            message=f"{missing_files} HTML file(s) missing",
            details={"files": report["file_integrity"]["missing_files"]},
            severity="warning"
        )

    log.info("Daily report generated", summary=report["summary"])
    return report


async def check_system_health(session: AsyncSession) -> dict:
    """
    Quick health check for monitoring endpoints.

    Returns simple pass/fail status for each component.
    """
    health = {
        "timestamp": datetime.utcnow().isoformat(),
        "status": "healthy",
        "checks": {},
    }

    # Database connection
    try:
        await session.execute(text("SELECT 1"))
        health["checks"]["database"] = {"status": "ok"}
    except Exception as e:
        health["checks"]["database"] = {"status": "error", "message": str(e)}
        health["status"] = "unhealthy"

    # Template files
    templates_ok = all(
        (Path(os.environ.get("TEMPLATES_PATH", "/app/website/templates")) / f).exists()
        for f in ["base.html.j2", "article.html.j2", "index.html.j2"]
    )
    health["checks"]["templates"] = {
        "status": "ok" if templates_ok else "error",
        "message": None if templates_ok else "Missing template files"
    }
    if not templates_ok:
        health["status"] = "degraded"

    # i18n files
    i18n_path = Path(os.environ.get("I18N_PATH", "/app/website/i18n"))
    i18n_count = len(list(i18n_path.glob("*.json"))) if i18n_path.exists() else 0
    health["checks"]["i18n"] = {
        "status": "ok" if i18n_count >= 11 else "warning",
        "languages_found": i18n_count
    }

    # Queue backlog
    try:
        result = await session.execute(
            text("SELECT COUNT(*) FROM regeneration_queue WHERE status = 'pending'")
        )
        pending_count = result.scalar()
        health["checks"]["queue"] = {
            "status": "ok" if pending_count < 100 else "warning",
            "pending_items": pending_count
        }
    except Exception:
        health["checks"]["queue"] = {"status": "unknown"}

    return health
