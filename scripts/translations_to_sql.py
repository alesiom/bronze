#!/usr/bin/env python3
"""
Convert translation JSON files to SQL update statements.

This script reads translation JSON files from the translations/ directory
and generates SQL UPDATE statements that can be run on PostgreSQL.

Usage:
    python scripts/translations_to_sql.py > translations.sql

    # Then run on database:
    docker exec -i neve26-db psql -U postgres -d neve26 < translations.sql
"""

import json
import os
import sys
from pathlib import Path

TRANSLATIONS_DIR = Path(__file__).parent.parent / "translations"


def escape_sql_string(s: str) -> str:
    """Escape a string for SQL - handle quotes and special characters."""
    if s is None:
        return ""
    # Escape single quotes by doubling them
    escaped = s.replace("'", "''")
    # Escape backslashes
    escaped = escaped.replace("\\", "\\\\")
    return escaped


def json_escape(s: str) -> str:
    """Escape a string for JSON inside SQL."""
    if s is None:
        return ""
    # First escape for JSON (backslashes and quotes)
    escaped = s.replace("\\", "\\\\")
    escaped = escaped.replace('"', '\\"')
    escaped = escaped.replace("\n", "\\n")
    escaped = escaped.replace("\r", "\\r")
    escaped = escaped.replace("\t", "\\t")
    # Then escape single quotes for SQL
    escaped = escaped.replace("'", "''")
    return escaped


def generate_sql_for_translation(slug: str, lang: str, title: str, excerpt: str, content: str) -> str:
    """Generate SQL UPDATE statement for a single translation."""
    title_escaped = json_escape(title)
    excerpt_escaped = json_escape(excerpt)
    content_escaped = json_escape(content)

    # Using jsonb_set to update individual language keys
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


def process_translation_file(filepath: Path) -> list[str]:
    """Process a single translation JSON file and return SQL statements."""
    with open(filepath, "r", encoding="utf-8") as f:
        data = json.load(f)

    slug = data["slug"]
    translations = data.get("translations", {})

    sql_statements = []
    for lang, content in translations.items():
        sql = generate_sql_for_translation(
            slug=slug,
            lang=lang,
            title=content.get("title", ""),
            excerpt=content.get("excerpt", ""),
            content=content.get("content", "")
        )
        sql_statements.append(sql)

    return sql_statements


def main():
    if not TRANSLATIONS_DIR.exists():
        print(f"-- Error: Translations directory not found: {TRANSLATIONS_DIR}", file=sys.stderr)
        sys.exit(1)

    # Find all JSON files
    json_files = list(TRANSLATIONS_DIR.glob("*.json"))

    if not json_files:
        print("-- No translation files found", file=sys.stderr)
        sys.exit(1)

    print("-- Neve26 Translation SQL")
    print("-- Generated from translations/*.json files")
    print(f"-- Files: {len(json_files)}")
    print("--")
    print("-- Run with:")
    print("--   docker exec -i neve26-db psql -U postgres -d neve26 < translations.sql")
    print("")
    print("BEGIN;")

    total_translations = 0

    for filepath in sorted(json_files):
        print(f"\n-- File: {filepath.name}")
        sql_statements = process_translation_file(filepath)
        for sql in sql_statements:
            print(sql)
            total_translations += 1

    print("\nCOMMIT;")
    print(f"\n-- Total translations: {total_translations}")


if __name__ == "__main__":
    main()
