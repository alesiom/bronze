# SEO & Sitemaps

This document covers the SEO infrastructure for Neve26, including robots.txt, sitemaps, and automation.

---

## Overview

Neve26 uses a multi-sitemap strategy optimized for news websites:

| File | Purpose | Update Frequency |
|------|---------|------------------|
| `robots.txt` | Crawler instructions + sitemap locations | Rarely |
| `sitemap.xml` | Index pointing to all sitemaps | When sitemaps change |
| `sitemap-pages.xml` | Static pages (homepage, app, legal) | Monthly |
| `sitemap-articles.xml` | All published articles | After each publish |
| `sitemap-news.xml` | Google News (last 2 days only) | After each publish |

---

## File Locations

```
website/
├── robots.txt
├── sitemap.xml           # Sitemap index
├── sitemap-pages.xml     # Static pages
├── sitemap-articles.xml  # All articles (generated)
├── sitemap-news.xml      # News articles (generated)
└── scripts/
    └── generate_sitemaps.py
```

---

## robots.txt

Located at `website/robots.txt`. Key sections:

```txt
# Allow all search engines
User-agent: *
Allow: /

# Sitemaps
Sitemap: https://neve26.com/sitemap.xml
Sitemap: https://neve26.com/sitemap-news.xml

# Block non-content paths
Disallow: /api/
Disallow: /scripts/
Disallow: /templates/

# AI Crawlers - explicitly allowed for visibility
User-agent: GPTBot
Allow: /

User-agent: Google-Extended
Allow: /

User-agent: ClaudeBot
Allow: /
```

### AI Crawler Policy

We explicitly allow AI crawlers to ensure Neve26 content appears in:
- ChatGPT/OpenAI responses (GPTBot)
- Google Gemini/Bard (Google-Extended)
- Claude (ClaudeBot)
- Common Crawl datasets (CCBot)

To block AI crawlers in the future, change `Allow: /` to `Disallow: /` for each bot.

---

## Sitemaps

### sitemap.xml (Index)

Points to all other sitemaps:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>https://neve26.com/sitemap-pages.xml</loc>
    <lastmod>2026-01-11</lastmod>
  </sitemap>
  <sitemap>
    <loc>https://neve26.com/sitemap-articles.xml</loc>
    <lastmod>2026-01-11</lastmod>
  </sitemap>
  <sitemap>
    <loc>https://neve26.com/sitemap-news.xml</loc>
    <lastmod>2026-01-11</lastmod>
  </sitemap>
</sitemapindex>
```

### sitemap-pages.xml (Static)

Manually maintained. Contains:
- Homepage (`/`) with all hreflang alternates
- App page (`/app`)
- Privacy policy (`/privacy`)
- Terms of service (`/terms`)
- Support (`/support`)

### sitemap-articles.xml (Generated)

All published articles with:
- URLs for all 11 languages
- `xhtml:link` hreflang alternates
- Last modification date
- Weekly change frequency

Example entry:
```xml
<url>
  <loc>https://neve26.com/adelboden-giant-slalom-preview-2026/</loc>
  <lastmod>2026-01-08</lastmod>
  <changefreq>weekly</changefreq>
  <priority>0.7</priority>
  <xhtml:link rel="alternate" hreflang="en" href="https://neve26.com/adelboden-giant-slalom-preview-2026/"/>
  <xhtml:link rel="alternate" hreflang="de" href="https://neve26.com/de/adelboden-giant-slalom-preview-2026/"/>
  <!-- ... all 11 languages -->
</url>
```

### sitemap-news.xml (Google News)

Special sitemap for Google News with:
- Only articles from last 2 days (Google requirement)
- `<news:news>` metadata tags
- Publication name, language, date, title

Example entry:
```xml
<url>
  <loc>https://neve26.com/article-slug/</loc>
  <news:news>
    <news:publication>
      <news:name>Neve26</news:name>
      <news:language>en</news:language>
    </news:publication>
    <news:publication_date>2026-01-11T10:30:00+00:00</news:publication_date>
    <news:title>Article Title Here</news:title>
  </news:news>
</url>
```

---

## Sitemap Generator Script

### Location

`website/scripts/generate_sitemaps.py`

### Usage

```bash
# Local development
python3 website/scripts/generate_sitemaps.py --api-url http://localhost:8000

# Production
python3 website/scripts/generate_sitemaps.py --api-url https://api.neve26.com

# Custom output directory
python3 website/scripts/generate_sitemaps.py --output-dir /var/www/neve26
```

### What It Does

1. Fetches all published articles from the API
2. Generates `sitemap-news.xml` (articles from last 2 days)
3. Generates `sitemap-articles.xml` (all articles)
4. Updates `sitemap.xml` index with current dates

### Output

```
Fetching articles from http://localhost:8000...
Found 15 published articles
Generated sitemap-news.xml: 3 articles (last 2 days)
Generated sitemap-articles.xml: 15 articles (all time)
Generated sitemap.xml (index)
Done!
```

---

## Automation Options

### Option 1: n8n Workflow (Recommended)

Add to the article publishing workflow in n8n:

```
[Article Generated] → [Save to DB] → [Generate HTML] → [Regenerate Sitemaps]
```

**n8n HTTP Request node configuration:**

| Field | Value |
|-------|-------|
| Method | POST |
| URL | `https://api.neve26.com/api/v1/sitemaps/generate` |
| Authentication | API Key |

Or use an Execute Command node:
```bash
python3 /var/www/neve26/scripts/generate_sitemaps.py --api-url https://api.neve26.com
```

**Pros:**
- Sitemaps update immediately after publish
- No unnecessary regeneration
- Integrated with existing workflow

### Option 2: Cron Job

Add to server crontab:

```bash
# Edit crontab
crontab -e

# Add line (runs every 15 minutes)
*/15 * * * * cd /var/www/neve26 && python3 scripts/generate_sitemaps.py --api-url https://api.neve26.com >> /var/log/neve26/sitemap.log 2>&1
```

**Pros:**
- Simple to set up
- Works as backup if n8n fails
- Catches any manual database changes

**Cons:**
- Up to 15-minute delay for new content
- Runs even when no changes

### Option 3: Both (Recommended for Production)

Use n8n for immediate updates + cron as backup:

1. n8n triggers on each article publish
2. Cron runs every 30 minutes as safety net

---

## Google Search Console Setup

After deploying sitemaps:

1. Go to [Google Search Console](https://search.google.com/search-console)
2. Add property: `https://neve26.com`
3. Verify ownership (DNS TXT record or HTML file)
4. Go to **Sitemaps** section
5. Submit: `https://neve26.com/sitemap.xml`

Google will automatically discover all linked sitemaps from the index.

### Monitoring

Check Search Console weekly for:
- Crawl errors
- Indexing status
- Coverage issues

---

## Multilingual SEO

Each article URL includes hreflang tags for all 11 languages:

| Code | Language |
|------|----------|
| `en` | English (default) |
| `de` | German |
| `fr` | French |
| `it` | Italian |
| `es` | Spanish |
| `pt` | Portuguese |
| `nl` | Dutch |
| `ar` | Arabic |
| `ja` | Japanese |
| `zh` | Chinese |
| `ko` | Korean |

URL structure:
- English: `neve26.com/article-slug/`
- Other: `neve26.com/{lang}/article-slug/`

---

## Limits & Constraints

| Constraint | Limit | Notes |
|------------|-------|-------|
| Sitemap file size | 50 MB | Uncompressed |
| URLs per sitemap | 50,000 | Use sitemap index if exceeded |
| News sitemap age | 2 days | Google ignores older articles |
| News sitemap URLs | 1,000 | Max `<news:news>` tags per file |
| API limit | 100 | Articles per request |

If article count exceeds limits, the script will need pagination support.

---

## Troubleshooting

### Sitemaps not updating

1. Check API is accessible: `curl https://api.neve26.com/api/v1/articles`
2. Check script permissions: `chmod +x scripts/generate_sitemaps.py`
3. Check output directory is writable

### Google not indexing

1. Verify sitemap submitted in Search Console
2. Check for crawl errors in Search Console
3. Ensure articles have `published_at` date set
4. Verify HTML files exist at sitemap URLs

### News articles not appearing

Google News sitemap only includes articles from last 2 days. Older articles appear in `sitemap-articles.xml` but not `sitemap-news.xml`.

---

## References

- [Google: Build and Submit a Sitemap](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap)
- [Google: Create a News Sitemap](https://developers.google.com/search/docs/crawling-indexing/sitemaps/news-sitemap)
- [Robots.txt SEO Best Practices 2026](https://searchengineland.com/robots-txt-seo-453779)
- [Sitemap Best Practices Guide](https://searchengineland.com/guide/sitemap)
