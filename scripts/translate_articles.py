#!/usr/bin/env python3
"""
Translate Neve26 articles from English to 10 languages.

This script:
1. Fetches articles needing translation from the API
2. Uses Claude to translate content preserving HTML structure
3. Updates the database via the PATCH /articles/{slug}/translation endpoint

Requirements:
- ANTHROPIC_API_KEY environment variable
- API endpoint must have PATCH /articles/{slug}/translation deployed

Usage:
    # Set API key
    export ANTHROPIC_API_KEY=your_key_here

    # Run all translations
    python scripts/translate_articles.py

    # Run for specific language
    python scripts/translate_articles.py --lang de

    # Run for specific article
    python scripts/translate_articles.py --slug sofia-goggia-profile

    # Dry run (don't save)
    python scripts/translate_articles.py --dry-run
"""

import argparse
import json
import os
import re
import sys
import time
import urllib.request
from typing import Optional

# API configuration
API_BASE = "https://api.neve26.com/api/v1"
ANTHROPIC_API_KEY = os.environ.get("ANTHROPIC_API_KEY")

# Language configurations
LANGUAGES = {
    "de": {"name": "German", "native": "Deutsch"},
    "fr": {"name": "French", "native": "Français"},
    "it": {"name": "Italian", "native": "Italiano"},
    "es": {"name": "Spanish", "native": "Español"},
    "pt": {"name": "Portuguese", "native": "Português"},
    "nl": {"name": "Dutch", "native": "Nederlands"},
    "ar": {"name": "Arabic", "native": "العربية"},
    "ja": {"name": "Japanese", "native": "日本語"},
    "zh": {"name": "Chinese (Simplified)", "native": "中文"},
    "ko": {"name": "Korean", "native": "한국어"},
}

COMPLETENESS_THRESHOLD = 0.80


def fetch_json(url: str) -> Optional[dict]:
    """Fetch JSON from URL."""
    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None


def patch_translation(slug: str, lang: str, title: str, excerpt: str, content: str) -> bool:
    """Send PATCH request to update translation."""
    url = f"{API_BASE}/articles/{slug}/translation"

    payload = {
        "lang": lang,
        "title": title,
        "excerpt": excerpt,
        "content": content,
    }

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method="PATCH",
        headers={"Content-Type": "application/json"}
    )

    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            return response.status == 200
    except urllib.error.HTTPError as e:
        print(f"HTTP Error: {e.code} - {e.read().decode()}")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False


def call_claude(prompt: str) -> Optional[str]:
    """Call Claude API for translation."""
    if not ANTHROPIC_API_KEY:
        print("ERROR: ANTHROPIC_API_KEY not set")
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
        print(f"Claude API error: {e}")
        return None


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

    # Build the translation prompt
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

    # Call Claude
    response = call_claude(prompt)
    if not response:
        return None

    # Parse JSON response
    try:
        # Clean up response if it has markdown code blocks
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
        print(f"Failed to parse Claude response: {e}")
        print(f"Response was: {response[:500]}...")
        return None


def get_incomplete_translations(slug: str = None) -> list:
    """Get list of articles needing translation."""
    # Fetch all articles
    data = fetch_json(f"{API_BASE}/articles?limit=100")
    if not data:
        return []

    articles = data.get("articles", [])
    incomplete = []

    for article in articles:
        if slug and article["slug"] != slug:
            continue

        # Fetch raw content
        raw = fetch_json(f"{API_BASE}/articles/{article['slug']}/raw")
        if not raw:
            continue

        en_content = raw.get("content", {}).get("en", "")
        en_len = len(en_content)

        if en_len == 0:
            continue

        # Check each language
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
    parser = argparse.ArgumentParser(description="Translate Neve26 articles")
    parser.add_argument("--slug", help="Specific article slug to translate")
    parser.add_argument("--lang", help="Specific language to translate to")
    parser.add_argument("--dry-run", action="store_true", help="Don't save translations")
    parser.add_argument("--limit", type=int, help="Limit number of articles to process")
    args = parser.parse_args()

    if not ANTHROPIC_API_KEY:
        print("ERROR: Set ANTHROPIC_API_KEY environment variable")
        sys.exit(1)

    print("="*60)
    print("NEVE26 ARTICLE TRANSLATION")
    print("="*60)

    # Get articles needing translation
    print("\nFetching articles needing translation...")
    incomplete = get_incomplete_translations(args.slug)

    if not incomplete:
        print("No articles need translation!")
        return

    # Filter by language if specified
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

    # Calculate totals
    total_translations = sum(len(a["missing_langs"]) for a in incomplete)
    print(f"Found {len(incomplete)} articles needing {total_translations} translations")

    if args.dry_run:
        print("\n*** DRY RUN - translations will not be saved ***")

    # Process each article
    success_count = 0
    error_count = 0

    for i, article in enumerate(incomplete, 1):
        slug = article["slug"]
        print(f"\n[{i}/{len(incomplete)}] {slug}")
        print(f"  Category: {article['category']}")
        print(f"  Missing: {', '.join(article['missing_langs'])}")

        for lang in article["missing_langs"]:
            print(f"  Translating to {lang}...", end=" ", flush=True)

            # Translate
            translation = translate_article(
                slug=slug,
                lang=lang,
                title_en=article["title_en"],
                excerpt_en=article["excerpt_en"],
                content_en=article["content_en"],
                category=article["category"]
            )

            if not translation:
                print("FAILED (translation error)")
                error_count += 1
                continue

            if args.dry_run:
                print(f"OK (dry run, title: {translation['title'][:50]}...)")
                success_count += 1
            else:
                # Save to API
                if patch_translation(
                    slug=slug,
                    lang=lang,
                    title=translation["title"],
                    excerpt=translation["excerpt"],
                    content=translation["content"]
                ):
                    print("SAVED")
                    success_count += 1
                else:
                    print("FAILED (API error)")
                    error_count += 1

            # Rate limiting
            time.sleep(1)

    # Summary
    print("\n" + "="*60)
    print("TRANSLATION COMPLETE")
    print("="*60)
    print(f"Successful: {success_count}")
    print(f"Failed: {error_count}")
    print(f"Total: {success_count + error_count}")


if __name__ == "__main__":
    main()
