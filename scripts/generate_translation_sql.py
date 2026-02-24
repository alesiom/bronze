#!/usr/bin/env python3
"""
Generate SQL update statements for article translations.

This script generates SQL that can be run directly on the PostgreSQL database
to update article translations, bypassing the API.

The SQL updates the JSONB fields directly using PostgreSQL's jsonb_set function.

Usage:
    # Generate SQL for all incomplete translations
    python scripts/generate_translation_sql.py > translations.sql

    # Generate for specific slug
    python scripts/generate_translation_sql.py --slug sofia-goggia-profile

    # Generate for specific language
    python scripts/generate_translation_sql.py --lang de
"""

import argparse
import json
import os
import re
import sys
import urllib.request
from typing import Optional

API_BASE = "https://api.bronze.news/api/v1"
ANTHROPIC_API_KEY = os.environ.get("ANTHROPIC_API_KEY")

LANGUAGES = {
    "de": {"name": "German", "native": "Deutsch"},
    "fr": {"name": "French", "native": "Français"},
}

COMPLETENESS_THRESHOLD = 0.80


def fetch_json(url: str) -> Optional[dict]:
    """Fetch JSON from URL."""
    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"-- Error fetching {url}: {e}", file=sys.stderr)
        return None


def call_claude(prompt: str) -> Optional[str]:
    """Call Claude API for translation."""
    if not ANTHROPIC_API_KEY:
        return None

    url = "https://api.anthropic.com/v1/messages"

    payload = {
        "model": "claude-sonnet-4-20250514",
        "max_tokens": 8192,
        "messages": [{"role": "user", "content": prompt}]
    }

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "Content-Type": "application/json",
            "x-api-key": ANTHROPIC_API_KEY,
            "anthropic-version": "2023-06-01"
        }
    )

    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            result = json.loads(response.read().decode())
            return result["content"][0]["text"]
    except Exception as e:
        print(f"-- Claude API error: {e}", file=sys.stderr)
        return None


def escape_sql_string(s: str) -> str:
    """Escape a string for SQL single quotes."""
    if s is None:
        return ""
    # Escape single quotes by doubling them
    return s.replace("'", "''")


def translate_article(
    slug: str,
    lang: str,
    title_en: str,
    excerpt_en: str,
    content_en: str,
    category: str
) -> Optional[dict]:
    """Translate article content to target language."""
    lang_info = LANGUAGES[lang]

    prompt = f"""You are a professional sports journalist translator. Translate the following winter sports article from English to {lang_info['name']} ({lang_info['native']}).

CRITICAL REQUIREMENTS:
1. PRESERVE ALL HTML TAGS EXACTLY - do not modify, add, or remove any HTML tags
2. TRANSLATE the text content between tags, not the tags themselves
3. Keep all athlete names unchanged (e.g., "Marco Odermatt" stays "Marco Odermatt")
4. Keep all venue names unchanged (e.g., "Kitzbühel" stays "Kitzbühel")
5. Update internal links to include language prefix:
   - /athletes/... → /{lang}/athletes/...
   - /alpine-skiing/... → /{lang}/alpine-skiing/...
   - etc.
6. Use professional sports journalism tone appropriate for {lang_info['name']} readers
7. This is a FULL translation, not a summary - translate ALL content

Category: {category}

---
TITLE (translate this):
{title_en}

---
EXCERPT (translate this):
{excerpt_en}

---
CONTENT (translate this, preserving ALL HTML tags):
{content_en}

---
Respond with ONLY a JSON object in this exact format:
{{
  "title": "translated title here",
  "excerpt": "translated excerpt here",
  "content": "translated content here with HTML preserved"
}}

Do not include any other text, explanations, or markdown code blocks - just the raw JSON object."""

    response = call_claude(prompt)
    if not response:
        return None

    try:
        response = response.strip()
        if response.startswith("```"):
            response = re.sub(r"^```(?:json)?\n?", "", response)
            response = re.sub(r"\n?```$", "", response)

        result = json.loads(response)
        return {
            "title": result["title"],
            "excerpt": result.get("excerpt", ""),
            "content": result["content"]
        }
    except json.JSONDecodeError as e:
        print(f"-- Failed to parse Claude response: {e}", file=sys.stderr)
        return None


def generate_sql_update(slug: str, lang: str, title: str, excerpt: str, content: str) -> str:
    """Generate SQL UPDATE statement for a translation."""
    title_escaped = escape_sql_string(title)
    excerpt_escaped = escape_sql_string(excerpt)
    content_escaped = escape_sql_string(content)

    sql = f"""
-- Translation: {slug} -> {lang}
UPDATE articles
SET
    title = jsonb_set(COALESCE(title, '{{}}'::jsonb), '{{{lang}}}', '"{title_escaped}"'::jsonb),
    excerpt = jsonb_set(COALESCE(excerpt, '{{}}'::jsonb), '{{{lang}}}', '"{excerpt_escaped}"'::jsonb),
    content = jsonb_set(COALESCE(content, '{{}}'::jsonb), '{{{lang}}}', '"{content_escaped}"'::jsonb),
    updated_at = NOW()
WHERE slug = '{slug}';
"""
    return sql


def get_incomplete_translations(slug: str = None) -> list:
    """Get list of articles needing translation."""
    data = fetch_json(f"{API_BASE}/articles?limit=100")
    if not data:
        return []

    articles = data.get("articles", [])
    incomplete = []

    for article in articles:
        if slug and article["slug"] != slug:
            continue

        raw = fetch_json(f"{API_BASE}/articles/{article['slug']}/raw")
        if not raw:
            continue

        en_content = raw.get("content", {}).get("en", "")
        en_len = len(en_content)

        if en_len == 0:
            continue

        missing_langs = []
        for lang in LANGUAGES.keys():
            lang_content = raw.get("content", {}).get(lang, "")
            lang_len = len(lang_content)
            ratio = lang_len / en_len if en_len else 0

            if ratio < COMPLETENESS_THRESHOLD:
                missing_langs.append(lang)

        if missing_langs:
            incomplete.append({
                "slug": article["slug"],
                "category": article.get("category", ""),
                "title_en": raw.get("title", {}).get("en", ""),
                "excerpt_en": raw.get("excerpt", {}).get("en", ""),
                "content_en": en_content,
                "missing_langs": missing_langs
            })

    return incomplete


def main():
    parser = argparse.ArgumentParser(description="Generate translation SQL")
    parser.add_argument("--slug", help="Specific article slug")
    parser.add_argument("--lang", help="Specific language")
    parser.add_argument("--limit", type=int, help="Limit articles")
    args = parser.parse_args()

    if not ANTHROPIC_API_KEY:
        print("-- ERROR: Set ANTHROPIC_API_KEY environment variable", file=sys.stderr)
        sys.exit(1)

    print("-- Bronze Translation SQL Generator")
    print("-- Generated by scripts/generate_translation_sql.py")
    print("-- ")
    print("-- Run this SQL on the neve26 database:")
    print("--   docker exec -i bronze-db psql -U postgres -d neve26 < translations.sql")
    print("")
    print("BEGIN;")
    print("")

    # Get articles needing translation
    print("-- Fetching articles...", file=sys.stderr)
    incomplete = get_incomplete_translations(args.slug)

    if not incomplete:
        print("-- No articles need translation!")
        print("COMMIT;")
        return

    # Filter by language
    if args.lang:
        incomplete = [
            a for a in incomplete
            if args.lang in a["missing_langs"]
        ]
        for a in incomplete:
            a["missing_langs"] = [args.lang]

    # Apply limit
    if args.limit:
        incomplete = incomplete[:args.limit]

    total = sum(len(a["missing_langs"]) for a in incomplete)
    print(f"-- Processing {len(incomplete)} articles, {total} translations", file=sys.stderr)

    # Process each article
    for i, article in enumerate(incomplete, 1):
        slug = article["slug"]
        print(f"-- [{i}/{len(incomplete)}] {slug}", file=sys.stderr)

        for lang in article["missing_langs"]:
            print(f"--   Translating to {lang}...", file=sys.stderr)

            translation = translate_article(
                slug=slug,
                lang=lang,
                title_en=article["title_en"],
                excerpt_en=article["excerpt_en"],
                content_en=article["content_en"],
                category=article["category"]
            )

            if translation:
                sql = generate_sql_update(
                    slug=slug,
                    lang=lang,
                    title=translation["title"],
                    excerpt=translation["excerpt"],
                    content=translation["content"]
                )
                print(sql)
            else:
                print(f"-- FAILED: {slug} -> {lang}")

    print("")
    print("COMMIT;")
    print("")
    print("-- Translation SQL generation complete")


if __name__ == "__main__":
    main()
