#!/usr/bin/env python3
"""
Sitemap Generator for Neve26
Generates sitemap-news.xml and sitemap-articles.xml from the API.

Usage:
    python generate_sitemaps.py [--api-url URL] [--output-dir DIR]

Should be run:
    - After publishing new articles (via n8n webhook)
    - On a cron schedule (every 15-30 minutes)
"""

import argparse
import json
import os
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Optional
from urllib.request import urlopen, Request
from urllib.error import URLError
from xml.etree.ElementTree import Element, SubElement, tostring
from xml.dom import minidom

# Configuration
DEFAULT_API_URL = "http://localhost:8000"
DEFAULT_OUTPUT_DIR = Path(__file__).parent.parent  # website/ directory
SITE_URL = "https://neve26.com"
LANGUAGES = ["en", "de", "fr", "it", "es", "pt", "nl", "ar", "ja", "zh", "ko"]

# News sitemap only includes articles from last 2 days (Google requirement)
NEWS_MAX_AGE_DAYS = 2


def fetch_articles(api_url: str, limit: int = 100) -> list:
    """Fetch published articles from the API (max 100 per request)."""
    url = f"{api_url}/api/v1/articles?limit={limit}"
    try:
        req = Request(url, headers={"Accept": "application/json"})
        with urlopen(req, timeout=30) as response:
            data = json.loads(response.read().decode())
            articles = data.get("articles", [])
            # Filter for only published articles (have published_at date)
            return [a for a in articles if a.get("published_at")]
    except URLError as e:
        print(f"Error fetching articles: {e}", file=sys.stderr)
        return []
    except json.JSONDecodeError as e:
        print(f"Error parsing API response: {e}", file=sys.stderr)
        return []


def parse_date(date_str: Optional[str]) -> Optional[datetime]:
    """Parse ISO date string to datetime."""
    if not date_str:
        return None
    try:
        # Handle various ISO formats
        date_str = date_str.replace("Z", "+00:00")
        return datetime.fromisoformat(date_str)
    except ValueError:
        return None


def generate_news_sitemap(articles: list, output_path: Path) -> int:
    """
    Generate Google News sitemap (only articles from last 2 days).
    Returns count of articles included.
    """
    # News namespace
    nsmap = {
        "xmlns": "http://www.sitemaps.org/schemas/sitemap/0.9",
        "xmlns:news": "http://www.google.com/schemas/sitemap-news/0.9",
        "xmlns:xhtml": "http://www.w3.org/1999/xhtml"
    }

    urlset = Element("urlset")
    for key, value in nsmap.items():
        urlset.set(key, value)

    cutoff = datetime.now(timezone.utc) - timedelta(days=NEWS_MAX_AGE_DAYS)
    count = 0

    for article in articles:
        pub_date = parse_date(article.get("published_at"))
        if not pub_date or pub_date < cutoff:
            continue

        slug = article.get("slug")
        if not slug:
            continue

        # Add URL for each language
        for lang in LANGUAGES:
            url_elem = SubElement(urlset, "url")

            # Location
            if lang == "en":
                loc = f"{SITE_URL}/{slug}/"
            else:
                loc = f"{SITE_URL}/{lang}/{slug}/"
            SubElement(url_elem, "loc").text = loc

            # News metadata
            news = SubElement(url_elem, "news:news")

            publication = SubElement(news, "news:publication")
            SubElement(publication, "news:name").text = "Neve26"
            SubElement(publication, "news:language").text = lang

            SubElement(news, "news:publication_date").text = pub_date.strftime("%Y-%m-%dT%H:%M:%S+00:00")
            SubElement(news, "news:title").text = article.get("title", slug)

            # Hreflang alternates
            for alt_lang in LANGUAGES:
                xhtml_link = SubElement(url_elem, "xhtml:link")
                xhtml_link.set("rel", "alternate")
                xhtml_link.set("hreflang", alt_lang)
                if alt_lang == "en":
                    xhtml_link.set("href", f"{SITE_URL}/{slug}/")
                else:
                    xhtml_link.set("href", f"{SITE_URL}/{alt_lang}/{slug}/")

        count += 1

    # Pretty print XML
    xml_str = tostring(urlset, encoding="unicode")
    dom = minidom.parseString(xml_str)
    pretty_xml = dom.toprettyxml(indent="  ", encoding="UTF-8")

    # Remove extra blank lines
    lines = pretty_xml.decode().split("\n")
    clean_lines = [line for line in lines if line.strip()]

    output_path.write_text("\n".join(clean_lines) + "\n")
    return count


def generate_articles_sitemap(articles: list, output_path: Path) -> int:
    """
    Generate full articles sitemap (all articles, not just recent).
    Returns count of articles included.
    """
    nsmap = {
        "xmlns": "http://www.sitemaps.org/schemas/sitemap/0.9",
        "xmlns:xhtml": "http://www.w3.org/1999/xhtml"
    }

    urlset = Element("urlset")
    for key, value in nsmap.items():
        urlset.set(key, value)

    count = 0

    for article in articles:
        slug = article.get("slug")
        if not slug:
            continue

        pub_date = parse_date(article.get("published_at"))
        lastmod = pub_date.strftime("%Y-%m-%d") if pub_date else datetime.now().strftime("%Y-%m-%d")

        # Add URL for each language
        for lang in LANGUAGES:
            url_elem = SubElement(urlset, "url")

            # Location
            if lang == "en":
                loc = f"{SITE_URL}/{slug}/"
            else:
                loc = f"{SITE_URL}/{lang}/{slug}/"
            SubElement(url_elem, "loc").text = loc
            SubElement(url_elem, "lastmod").text = lastmod
            SubElement(url_elem, "changefreq").text = "weekly"
            SubElement(url_elem, "priority").text = "0.7"

            # Hreflang alternates
            for alt_lang in LANGUAGES:
                xhtml_link = SubElement(url_elem, "xhtml:link")
                xhtml_link.set("rel", "alternate")
                xhtml_link.set("hreflang", alt_lang)
                if alt_lang == "en":
                    xhtml_link.set("href", f"{SITE_URL}/{slug}/")
                else:
                    xhtml_link.set("href", f"{SITE_URL}/{alt_lang}/{slug}/")

        count += 1

    # Pretty print XML
    xml_str = tostring(urlset, encoding="unicode")
    dom = minidom.parseString(xml_str)
    pretty_xml = dom.toprettyxml(indent="  ", encoding="UTF-8")

    lines = pretty_xml.decode().split("\n")
    clean_lines = [line for line in lines if line.strip()]

    output_path.write_text("\n".join(clean_lines) + "\n")
    return count


def generate_sitemap_index(output_dir: Path):
    """Generate sitemap index file pointing to all sitemaps."""
    today = datetime.now().strftime("%Y-%m-%d")

    sitemaps = [
        ("sitemap-pages.xml", today, "0.9"),
        ("sitemap-articles.xml", today, "0.8"),
        ("sitemap-news.xml", today, "1.0"),
    ]

    urlset = Element("sitemapindex")
    urlset.set("xmlns", "http://www.sitemaps.org/schemas/sitemap/0.9")

    for filename, lastmod, _ in sitemaps:
        sitemap_path = output_dir / filename
        if sitemap_path.exists():
            sitemap = SubElement(urlset, "sitemap")
            SubElement(sitemap, "loc").text = f"{SITE_URL}/{filename}"
            SubElement(sitemap, "lastmod").text = lastmod

    xml_str = tostring(urlset, encoding="unicode")
    dom = minidom.parseString(xml_str)
    pretty_xml = dom.toprettyxml(indent="  ", encoding="UTF-8")

    lines = pretty_xml.decode().split("\n")
    clean_lines = [line for line in lines if line.strip()]

    (output_dir / "sitemap.xml").write_text("\n".join(clean_lines) + "\n")


def main():
    parser = argparse.ArgumentParser(description="Generate sitemaps for Neve26")
    parser.add_argument("--api-url", default=DEFAULT_API_URL, help="API base URL")
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR, help="Output directory")
    args = parser.parse_args()

    print(f"Fetching articles from {args.api_url}...")
    articles = fetch_articles(args.api_url)
    print(f"Found {len(articles)} published articles")

    if articles:
        # Generate news sitemap (last 2 days only)
        news_path = args.output_dir / "sitemap-news.xml"
        news_count = generate_news_sitemap(articles, news_path)
        print(f"Generated {news_path.name}: {news_count} articles (last {NEWS_MAX_AGE_DAYS} days)")

        # Generate full articles sitemap
        articles_path = args.output_dir / "sitemap-articles.xml"
        articles_count = generate_articles_sitemap(articles, articles_path)
        print(f"Generated {articles_path.name}: {articles_count} articles (all time)")
    else:
        # Create empty sitemaps
        for name in ["sitemap-news.xml", "sitemap-articles.xml"]:
            path = args.output_dir / name
            path.write_text('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"></urlset>\n')
            print(f"Generated empty {name}")

    # Generate sitemap index
    generate_sitemap_index(args.output_dir)
    print(f"Generated sitemap.xml (index)")

    print("Done!")


if __name__ == "__main__":
    main()
