"""Sitemap generation routes."""

import os
from datetime import datetime, timedelta, timezone
from typing import Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import structlog

from src.db import get_session
from src.db.models import Article
from sqlalchemy import select

log = structlog.get_logger()

router = APIRouter(prefix="/sitemap", tags=["sitemap"])

# Configuration
BASE_URL = "https://neve26.com"
LANGUAGES = ["en", "de", "fr", "it", "es", "pt", "nl", "ar", "ja", "zh", "ko"]
HTML_OUTPUT_PATH = os.getenv("HTML_OUTPUT_PATH", "/var/www/neve26.com")

# Categories for URL structure
CATEGORIES = [
    "athletes", "venues", "history", "guides",
    "alpine-skiing", "biathlon", "cross-country", "ski-jumping",
    "nordic-combined", "freestyle", "snowboard", "news"
]


class SitemapResult(BaseModel):
    """Response model for sitemap generation."""
    success: bool
    articles_count: int
    news_count: int
    files_written: list[str]
    message: str


def get_article_url(slug: str, category: str, lang: str = "en") -> str:
    """Generate URL for an article based on language and category."""
    if lang == "en":
        return f"{BASE_URL}/{category}/{slug}/"
    return f"{BASE_URL}/{lang}/{category}/{slug}/"


def generate_hreflang_links(slug: str, category: str) -> str:
    """Generate xhtml:link tags for all language variants."""
    links = []
    for lang in LANGUAGES:
        url = get_article_url(slug, category, lang)
        links.append(f'    <xhtml:link rel="alternate" hreflang="{lang}" href="{url}"/>')
    return "\n".join(links)


def generate_sitemap_articles(articles: list[Article]) -> str:
    """Generate sitemap-articles.xml content."""
    urls = []

    for article in articles:
        lastmod = (article.updated_at or article.published_at or article.created_at)
        if lastmod:
            lastmod_str = lastmod.strftime("%Y-%m-%d")
        else:
            lastmod_str = datetime.now(timezone.utc).strftime("%Y-%m-%d")

        # Generate entry for each language variant
        for lang in LANGUAGES:
            url = get_article_url(article.slug, article.category, lang)
            hreflang_links = generate_hreflang_links(article.slug, article.category)

            urls.append(f"""  <url>
    <loc>{url}</loc>
    <lastmod>{lastmod_str}</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.7</priority>
{hreflang_links}
  </url>""")

    return f"""<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
{chr(10).join(urls)}
</urlset>
"""


def generate_sitemap_news(articles: list[Article]) -> str:
    """Generate sitemap-news.xml content for Google News (articles < 48h old)."""
    urls = []

    for article in articles:
        pub_date = article.published_at or article.created_at
        if not pub_date:
            continue

        pub_date_str = pub_date.strftime("%Y-%m-%dT%H:%M:%S+00:00")

        # Get English title for news sitemap
        title = article.title.get("en", "") if isinstance(article.title, dict) else str(article.title)
        # Escape XML special characters
        title = title.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

        url = get_article_url(article.slug, article.category, "en")
        hreflang_links = generate_hreflang_links(article.slug, article.category)

        urls.append(f"""  <url>
    <loc>{url}</loc>
    <news:news>
      <news:publication>
        <news:name>Neve26</news:name>
        <news:language>en</news:language>
      </news:publication>
      <news:publication_date>{pub_date_str}</news:publication_date>
      <news:title>{title}</news:title>
    </news:news>
{hreflang_links}
  </url>""")

    return f"""<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:news="http://www.google.com/schemas/sitemap-news/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
{chr(10).join(urls)}
</urlset>
"""


def generate_sitemap_index(today: str) -> str:
    """Generate the main sitemap.xml index."""
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>{BASE_URL}/sitemap-pages.xml</loc>
    <lastmod>{today}</lastmod>
  </sitemap>
  <sitemap>
    <loc>{BASE_URL}/sitemap-articles.xml</loc>
    <lastmod>{today}</lastmod>
  </sitemap>
  <sitemap>
    <loc>{BASE_URL}/sitemap-news.xml</loc>
    <lastmod>{today}</lastmod>
  </sitemap>
</sitemapindex>
"""


@router.post("/regenerate", response_model=SitemapResult)
async def regenerate_sitemaps():
    """
    Regenerate all sitemap files based on current published articles.

    This endpoint:
    - Generates sitemap-articles.xml with all published articles (11 language variants each)
    - Generates sitemap-news.xml with articles published in last 48 hours
    - Updates sitemap.xml index with current timestamps

    Files are written to HTML_OUTPUT_PATH for nginx to serve.
    """
    try:
        async with get_session() as session:
            # Fetch all published articles
            result = await session.execute(
                select(Article)
                .where(Article.status == "published")
                .order_by(Article.published_at.desc())
            )
            all_articles = list(result.scalars().all())

            # Filter for news sitemap (last 48 hours)
            cutoff = datetime.now(timezone.utc) - timedelta(hours=48)
            news_articles = [
                a for a in all_articles
                if a.published_at and a.published_at.replace(tzinfo=timezone.utc) > cutoff
            ]

            log.info(
                "Generating sitemaps",
                total_articles=len(all_articles),
                news_articles=len(news_articles)
            )

            # Generate sitemap content
            today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
            sitemap_articles = generate_sitemap_articles(all_articles)
            sitemap_news = generate_sitemap_news(news_articles)
            sitemap_index = generate_sitemap_index(today)

            # Write files to output directory
            files_written = []

            # Ensure output directory exists
            os.makedirs(HTML_OUTPUT_PATH, exist_ok=True)

            # Write sitemap files
            sitemap_files = [
                ("sitemap.xml", sitemap_index),
                ("sitemap-articles.xml", sitemap_articles),
                ("sitemap-news.xml", sitemap_news),
            ]

            for filename, content in sitemap_files:
                filepath = os.path.join(HTML_OUTPUT_PATH, filename)
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(content)
                files_written.append(filepath)
                log.info("Wrote sitemap file", path=filepath, size=len(content))

            return SitemapResult(
                success=True,
                articles_count=len(all_articles),
                news_count=len(news_articles),
                files_written=files_written,
                message=f"Generated sitemaps with {len(all_articles)} articles ({len(news_articles)} in news)"
            )

    except Exception as e:
        log.error("Failed to generate sitemaps", error=str(e))
        raise HTTPException(status_code=500, detail=f"Sitemap generation failed: {str(e)}")


@router.get("/status")
async def sitemap_status():
    """Check the current status of sitemap files."""
    files = ["sitemap.xml", "sitemap-articles.xml", "sitemap-news.xml", "sitemap-pages.xml"]
    status = {}

    for filename in files:
        filepath = os.path.join(HTML_OUTPUT_PATH, filename)
        if os.path.exists(filepath):
            stat = os.stat(filepath)
            status[filename] = {
                "exists": True,
                "size": stat.st_size,
                "modified": datetime.fromtimestamp(stat.st_mtime, tz=timezone.utc).isoformat()
            }
        else:
            status[filename] = {"exists": False}

    return {"files": status, "output_path": HTML_OUTPUT_PATH}
