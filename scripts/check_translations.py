#!/usr/bin/env python3
"""
Check translation status for all Neve26 articles.

This script identifies which articles have incomplete translations
(less than 80% of English content length).

Usage:
    python scripts/check_translations.py
"""

import json
import urllib.request
from typing import Optional

API_BASE = "https://api.neve26.com/api/v1"
LANGUAGES = ["de", "fr", "it", "es", "pt", "nl", "ar", "ja", "zh", "ko"]
COMPLETENESS_THRESHOLD = 0.80  # 80% of English content length


def fetch_json(url: str) -> Optional[dict]:
    """Fetch JSON from URL."""
    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None


def check_article_translations(slug: str) -> dict:
    """Check translation completeness for an article."""
    data = fetch_json(f"{API_BASE}/articles/{slug}/raw")
    if not data:
        return {"slug": slug, "error": "Failed to fetch"}

    en_content = data.get("content", {}).get("en", "")
    en_len = len(en_content)

    if en_len == 0:
        return {"slug": slug, "error": "No English content"}

    results = {
        "slug": slug,
        "category": data.get("category", ""),
        "en_length": en_len,
        "translations": {},
        "incomplete": []
    }

    for lang in LANGUAGES:
        lang_content = data.get("content", {}).get(lang, "")
        lang_len = len(lang_content)
        ratio = lang_len / en_len if en_len else 0

        results["translations"][lang] = {
            "length": lang_len,
            "ratio": ratio,
            "complete": ratio >= COMPLETENESS_THRESHOLD
        }

        if ratio < COMPLETENESS_THRESHOLD:
            results["incomplete"].append(lang)

    return results


def main():
    """Main function to check all articles."""
    # Fetch article list
    print("Fetching article list...")
    data = fetch_json(f"{API_BASE}/articles?limit=100")

    if not data:
        print("Failed to fetch article list")
        return

    articles = data.get("articles", [])
    print(f"Found {len(articles)} articles\n")

    # Check each article
    incomplete_articles = []
    complete_articles = []

    for i, article in enumerate(articles, 1):
        slug = article["slug"]
        print(f"[{i}/{len(articles)}] Checking {slug}...", end=" ")

        result = check_article_translations(slug)

        if result.get("error"):
            print(f"ERROR: {result['error']}")
            continue

        if result["incomplete"]:
            incomplete_articles.append(result)
            print(f"INCOMPLETE ({len(result['incomplete'])} languages)")
        else:
            complete_articles.append(result)
            print("COMPLETE")

    # Summary
    print("\n" + "="*60)
    print("TRANSLATION STATUS SUMMARY")
    print("="*60)
    print(f"Total articles: {len(articles)}")
    print(f"Complete: {len(complete_articles)}")
    print(f"Incomplete: {len(incomplete_articles)}")

    if incomplete_articles:
        print("\n" + "-"*60)
        print("ARTICLES NEEDING TRANSLATION:")
        print("-"*60)

        # Group by number of incomplete languages
        by_count = {}
        for article in incomplete_articles:
            count = len(article["incomplete"])
            if count not in by_count:
                by_count[count] = []
            by_count[count].append(article)

        for count in sorted(by_count.keys(), reverse=True):
            print(f"\n{count} languages incomplete:")
            for article in by_count[count]:
                incomplete_langs = ", ".join(article["incomplete"])
                print(f"  - {article['slug']} ({article['category']})")
                print(f"    Missing: {incomplete_langs}")

    # Save detailed results
    output_file = "/tmp/translation_status.json"
    with open(output_file, "w") as f:
        json.dump({
            "complete": complete_articles,
            "incomplete": incomplete_articles,
            "summary": {
                "total": len(articles),
                "complete": len(complete_articles),
                "incomplete": len(incomplete_articles)
            }
        }, f, indent=2)
    print(f"\nDetailed results saved to: {output_file}")


if __name__ == "__main__":
    main()
