#!/usr/bin/env python3
"""
Batch translation script for Neve26 articles.
Uses Claude Batch API for cost-effective full translations.

Usage:
    export ANTHROPIC_API_KEY=sk-ant-...
    python3 scripts/batch_translate.py
"""

import json
import os
import sys
import time
import subprocess
from pathlib import Path

# Languages to translate to (excluding English)
LANGUAGES = {
    "de": "German",
    "fr": "French",
    "it": "Italian",
    "es": "Spanish",
    "pt": "Portuguese",
    "nl": "Dutch",
    "ar": "Arabic",
    "ja": "Japanese",
    "zh": "Chinese (Simplified)",
    "ko": "Korean"
}

TRANSLATION_PROMPT = """You are a professional translator for a winter sports news website. Translate the following article from English to {language}.

CRITICAL REQUIREMENTS:
1. Translate the FULL article - do not summarize or shorten
2. Maintain the exact same HTML structure and tags
3. Keep all athlete names in their original form (do not transliterate)
4. Keep venue/location names in their commonly used form for {language} speakers
5. Preserve all links exactly as they are (href values unchanged)
6. Match the tone and style of professional sports journalism in {language}
7. The translation should be the same length and depth as the original

Article Title (English):
{title}

Article Content (English, with HTML):
{content}

Article Excerpt (English):
{excerpt}

Respond with a JSON object containing:
{{
    "title": "translated title",
    "content": "translated content with HTML preserved",
    "excerpt": "translated excerpt"
}}

Only output the JSON, nothing else."""


def get_articles_from_db():
    """Fetch all published articles from database."""
    result = subprocess.run([
        "ssh", "ubuntu@neve26.com",
        "docker exec neve26-db psql -U postgres -d neve26 -t -A -c \"SELECT json_agg(json_build_object('slug', slug, 'title_en', title->>'en', 'content_en', content->>'en', 'excerpt_en', COALESCE(excerpt->>'en', ''), 'category', category)) FROM articles WHERE status='published'\""
    ], capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error fetching articles: {result.stderr}")
        sys.exit(1)

    return json.loads(result.stdout.strip())


def create_batch_requests(articles):
    """Create JSONL batch request file."""
    requests = []

    for article in articles:
        slug = article['slug']
        title = article['title_en']
        content = article['content_en']
        excerpt = article['excerpt_en'] or ''

        for lang_code, lang_name in LANGUAGES.items():
            request = {
                "custom_id": f"{slug}_{lang_code}",
                "params": {
                    "model": "claude-sonnet-4-20250514",
                    "max_tokens": 8000,
                    "messages": [
                        {
                            "role": "user",
                            "content": TRANSLATION_PROMPT.format(
                                language=lang_name,
                                title=title,
                                content=content,
                                excerpt=excerpt
                            )
                        }
                    ]
                }
            }
            requests.append(request)

    return requests


def write_batch_file(requests, output_path):
    """Write requests to JSONL file."""
    with open(output_path, 'w') as f:
        for req in requests:
            f.write(json.dumps(req) + '\n')
    print(f"Written {len(requests)} requests to {output_path}")


def submit_batch(batch_file):
    """Submit batch to Anthropic API."""
    import anthropic

    client = anthropic.Anthropic()

    # Upload the batch file
    with open(batch_file, 'r') as f:
        requests = [json.loads(line) for line in f]

    print(f"Submitting batch with {len(requests)} requests...")

    # Create batch
    batch = client.messages.batches.create(requests=requests)

    print(f"Batch created: {batch.id}")
    print(f"Status: {batch.processing_status}")

    return batch.id


def check_batch_status(batch_id):
    """Check batch status."""
    import anthropic
    client = anthropic.Anthropic()

    batch = client.messages.batches.retrieve(batch_id)
    print(f"Status: {batch.processing_status}")
    print(f"Requests: {batch.request_counts}")

    return batch


def download_results(batch_id, output_path):
    """Download batch results."""
    import anthropic
    client = anthropic.Anthropic()

    results = []
    for result in client.messages.batches.results(batch_id):
        results.append({
            "custom_id": result.custom_id,
            "result": result.result
        })

    with open(output_path, 'w') as f:
        json.dump(results, f, indent=2)

    print(f"Downloaded {len(results)} results to {output_path}")
    return results


def update_database(results):
    """Update database with translations."""
    updates = []

    for result in results:
        custom_id = result['custom_id']
        slug, lang = custom_id.rsplit('_', 1)

        if result['result']['type'] == 'succeeded':
            content = result['result']['message']['content'][0]['text']
            try:
                translation = json.loads(content)
                updates.append({
                    'slug': slug,
                    'lang': lang,
                    'title': translation['title'],
                    'content': translation['content'],
                    'excerpt': translation.get('excerpt', '')
                })
            except json.JSONDecodeError:
                print(f"Failed to parse JSON for {custom_id}")
        else:
            print(f"Request failed for {custom_id}: {result['result']}")

    # Update database
    for update in updates:
        sql = f"""
        UPDATE articles SET
            title = jsonb_set(title, '{{{update['lang']}}}', to_jsonb(%s::text)),
            content = jsonb_set(content, '{{{update['lang']}}}', to_jsonb(%s::text)),
            excerpt = jsonb_set(COALESCE(excerpt, '{{}}'), '{{{update['lang']}}}', to_jsonb(%s::text))
        WHERE slug = %s
        """
        # Execute via SSH
        escaped_title = update['title'].replace("'", "''")
        escaped_content = update['content'].replace("'", "''")
        escaped_excerpt = update['excerpt'].replace("'", "''")

        cmd = f"""docker exec neve26-db psql -U postgres -d neve26 -c "
        UPDATE articles SET
            title = jsonb_set(title, '{{\"{update['lang']}\"}}', '\"{escaped_title}\"'::jsonb),
            content = jsonb_set(content, '{{\"{update['lang']}\"}}', to_jsonb('{escaped_content}'::text)),
            excerpt = jsonb_set(COALESCE(excerpt, '{{}}'), '{{\"{update['lang']}\"}}', to_jsonb('{escaped_excerpt}'::text))
        WHERE slug = '{update['slug']}'
        " """

        subprocess.run(["ssh", "ubuntu@neve26.com", cmd], capture_output=True)
        print(f"Updated {update['slug']} - {update['lang']}")

    print(f"Updated {len(updates)} translations in database")


def main():
    if not os.environ.get('ANTHROPIC_API_KEY'):
        print("Error: ANTHROPIC_API_KEY environment variable not set")
        print("Set it with: export ANTHROPIC_API_KEY=sk-ant-...")
        sys.exit(1)

    script_dir = Path(__file__).parent
    batch_file = script_dir / "batch_requests.jsonl"
    results_file = script_dir / "batch_results.json"
    batch_id_file = script_dir / "batch_id.txt"

    # Check if we're resuming
    if batch_id_file.exists():
        batch_id = batch_id_file.read_text().strip()
        print(f"Resuming batch: {batch_id}")

        batch = check_batch_status(batch_id)

        if batch.processing_status == "ended":
            print("Batch completed! Downloading results...")
            results = download_results(batch_id, results_file)
            print("Updating database...")
            update_database(results)
            print("Done!")
            batch_id_file.unlink()
        else:
            print(f"Batch still processing. Check again later.")
            print(f"Run this script again to check status.")
        return

    # Create new batch
    print("Fetching articles from database...")
    articles = get_articles_from_db()
    print(f"Found {len(articles)} articles")

    print("Creating batch requests...")
    requests = create_batch_requests(articles)
    print(f"Created {len(requests)} translation requests")

    write_batch_file(requests, batch_file)

    print("Submitting batch to Anthropic API...")
    batch_id = submit_batch(batch_file)

    batch_id_file.write_text(batch_id)
    print(f"Batch ID saved to {batch_id_file}")
    print("Run this script again to check status and download results.")


if __name__ == "__main__":
    main()
