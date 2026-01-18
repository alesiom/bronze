# Neve26 Website Content Automation

## Overview

Fully automated content creation pipeline for neve26.com that:
- Monitors winter sports RSS feeds and events
- AI-generates articles using Claude
- Translates to all 11 languages
- Deploys HTML files to the website
- **Zero manual intervention required**

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     NEVE26 CONTENT AUTOMATION PIPELINE                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         TRIGGERS (Sources)                            │   │
│  ├──────────────────────────────────────────────────────────────────────┤   │
│  │  RSS Feeds              │  Calendar Events        │  Manual Webhooks  │   │
│  │  • fis-ski.com/feed     │  • Race start times     │  • Breaking news  │   │
│  │  • biathlonworld.com    │  • Results available    │  • Admin trigger  │   │
│  │  • olympics.com/news    │  • Preview windows      │                   │   │
│  │  • eurosport.com        │                         │                   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                      CONTENT DECISION ENGINE                          │   │
│  ├──────────────────────────────────────────────────────────────────────┤   │
│  │  • Duplicate detection (skip if similar article exists)              │   │
│  │  • Relevance scoring (winter sports focus filter)                    │   │
│  │  • Legal compliance check (no Olympic terms)                         │   │
│  │  • Priority classification (breaking/standard/preview)               │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    AI CONTENT GENERATION (Claude)                     │   │
│  ├──────────────────────────────────────────────────────────────────────┤   │
│  │  Input: Source article/data + legal constraints + brand guidelines   │   │
│  │  Output: Original article with:                                       │   │
│  │    • Title (SEO-optimized)                                           │   │
│  │    • Meta description                                                 │   │
│  │    • Full article content (800-1500 words)                           │   │
│  │    • Structured data (JSON-LD)                                       │   │
│  │    • Category and tags                                               │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                     TRANSLATION (11 Languages)                        │   │
│  ├──────────────────────────────────────────────────────────────────────┤   │
│  │  Parallel Claude calls for each language:                            │   │
│  │  en (source) → de, fr, it, es, pt, nl, ar, ja, zh, ko               │   │
│  │                                                                       │   │
│  │  Special handling:                                                    │   │
│  │  • RTL for Arabic (ar)                                               │   │
│  │  • Proper character encoding for CJK (ja, zh, ko)                    │   │
│  │  • Locale-specific date formatting                                   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                      HTML GENERATION                                  │   │
│  ├──────────────────────────────────────────────────────────────────────┤   │
│  │  Template: /website/templates/article.html                           │   │
│  │  Placeholders replaced:                                              │   │
│  │    {{TITLE}}, {{CONTENT}}, {{LANG}}, {{SLUG}}, {{META_DESCRIPTION}}  │   │
│  │    {{CATEGORY_NAME}}, {{PUBLISHED_ISO}}, {{STRUCTURED_DATA}}, etc.   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                                    ▼                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         DEPLOYMENT                                    │   │
│  ├──────────────────────────────────────────────────────────────────────┤   │
│  │  Option A: Direct file write to VPS                                  │   │
│  │  Option B: Git commit + push (auto-deploy via GitHub Actions)        │   │
│  │  Option C: S3/CDN upload                                             │   │
│  │                                                                       │   │
│  │  Files created:                                                       │   │
│  │    /[slug]/index.html                    (English - default)         │   │
│  │    /de/[slug]/index.html                 (German)                    │   │
│  │    /fr/[slug]/index.html                 (French)                    │   │
│  │    /it/[slug]/index.html                 (Italian)                   │   │
│  │    /es/[slug]/index.html                 (Spanish)                   │   │
│  │    /pt/[slug]/index.html                 (Portuguese)                │   │
│  │    /nl/[slug]/index.html                 (Dutch)                     │   │
│  │    /ar/[slug]/index.html                 (Arabic - RTL)              │   │
│  │    /ja/[slug]/index.html                 (Japanese)                  │   │
│  │    /zh/[slug]/index.html                 (Chinese)                   │   │
│  │    /ko/[slug]/index.html                 (Korean)                    │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## RSS Feed Sources

### Primary Sources (Winter Sports)

| Source | Feed URL | Update Frequency | Content Type |
|--------|----------|------------------|--------------|
| FIS Alpine News | `https://www.fis-ski.com/alpine-skiing/news/feed` | Hourly | Race results, standings |
| IBU Biathlon | `https://www.biathlonworld.com/feed` | Hourly | Biathlon news |
| Eurosport Winter Sports | `https://www.eurosport.com/rss/winter-sports.xml` | Hourly | Multi-sport coverage |
| Olympics.com News | `https://www.olympics.com/rss` | Daily | Official news |

### Backup/Additional Sources

| Source | Feed URL | Notes |
|--------|----------|-------|
| Ski Racing | `https://www.skiracing.com/feed` | US-focused coverage |
| Focus Biathlon | `https://focusbiathlon.com/feed` | Biathlon analysis |

### Monitoring Frequency

- **During race days**: Every 15 minutes
- **Non-race days**: Every 2 hours
- **Night (00:00-06:00 CET)**: Every 6 hours

---

## Content Types & Triggers

### 1. Race Results (Automatic)

**Trigger**: New RSS item containing result keywords OR race end time + 30 min

**Detection patterns**:
- Title contains: "wins", "victory", "results", "podium", "standings"
- Source URL matches known result patterns

**Article template**:
- Headline: "[Athlete] Wins [Event] at [Location]"
- Content: Race analysis, times, standings impact
- Length: 600-800 words

### 2. Race Previews (Scheduled)

**Trigger**: 24 hours before race start time (from schedule database)

**Article template**:
- Headline: "[Event] Preview: What to Watch in [Location]"
- Content: Favorites, course info, weather, historical context
- Length: 800-1200 words

### 3. Breaking News (RSS-triggered)

**Trigger**: RSS item with high-priority keywords

**Detection patterns**:
- Keywords: "breaking", "injury", "withdrawal", "cancelled", "postponed"
- Within 2 hours of publication

**Article template**:
- Quick turnaround version (400-600 words)
- Priority: Publish within 30 minutes of trigger

### 4. Athlete Features (Weekly)

**Trigger**: Scheduled (e.g., every Monday, Wednesday, Friday)

**Article template**:
- Deep dive on trending athletes
- Based on recent performance data
- Length: 1000-1500 words

---

## AI Content Generation Prompts

### System Prompt (All Articles)

```
You are a winter sports journalist writing for Neve26, an independent winter sports news website.

BRAND IDENTITY:
- Independent, ad-free, privacy-first winter sports coverage
- WCAG AAA accessible (write clearly, avoid complex jargon)
- Focus on World Cup events and athlete stories

CRITICAL LEGAL RULES - NEVER VIOLATE:
- NEVER use: Olympic, Olympics, Olympiad, Paralympic
- NEVER use: Milano Cortina 2026, Winter Games 2026
- NEVER use: "going for gold", "medal hopes", "Team USA/Italy"
- NEVER reference the February 2026 event in Italy by name
- NEVER imply any Olympic connection

SAFE TERMINOLOGY:
- FIS World Cup, Biathlon World Cup, X Games
- Athlete names and career statistics
- City names alone (Cortina, Bormio, Kitzbühel)
- #WinterSports #AlpineSkiing #Biathlon #FISAlpine

WRITING STYLE:
- Clear, accessible language (aim for reading level: general audience)
- Short paragraphs (2-3 sentences max)
- Active voice preferred
- Include relevant statistics and context
- Engaging but factual tone
```

### Race Result Prompt

```
Write a race result article based on this information:

EVENT: {{event_name}}
LOCATION: {{location}}
DATE: {{date}}
WINNER: {{winner_name}} ({{winner_country}})
PODIUM: 1. {{first}}, 2. {{second}}, 3. {{third}}
TIMES: {{times_data}}
CONTEXT: {{additional_context}}

Create:
1. SEO-optimized title (max 60 chars)
2. Meta description (max 155 chars)
3. Article body (600-800 words) with:
   - Lead paragraph with key result
   - Winner's performance analysis
   - Other notable performances
   - Standings implications
   - Quote placeholder: [QUOTE_PLACEHOLDER]
   - Looking ahead to next event

Format the body in clean HTML with <h2>, <p>, <strong> tags as appropriate.
```

### Preview Article Prompt

```
Write a race preview article based on this information:

EVENT: {{event_name}}
LOCATION: {{location}}
DATE: {{date}}
FAVORITES: {{favorites_list}}
COURSE INFO: {{course_details}}
WEATHER: {{weather_forecast}}
HISTORICAL DATA: {{past_results}}

Create:
1. SEO-optimized title (max 60 chars)
2. Meta description (max 155 chars)
3. Article body (800-1200 words) with:
   - Introduction setting the scene
   - Key contenders section
   - Course/venue analysis
   - Weather impact section
   - Historical context
   - Prediction/what to watch

Format the body in clean HTML with <h2>, <p>, <strong>, <ul> tags as appropriate.
```

### Translation Prompt

```
Translate this article to {{target_language}}.

ORIGINAL (English):
Title: {{title}}
Description: {{description}}
Content: {{content}}

TRANSLATION RULES:
1. Maintain the exact same structure and HTML tags
2. Keep athlete names in original form (do not translate names)
3. Keep venue/city names in original form
4. Translate all other text naturally
5. Use locale-appropriate date/time formats
6. For Arabic: prepare for RTL display
7. Maintain SEO keywords where natural

Return JSON:
{
  "title": "translated title",
  "description": "translated description",
  "content": "translated HTML content"
}
```

---

## Template Placeholders

The article template (`/website/templates/article.html`) uses these placeholders:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{{LANG}}` | ISO language code | `en`, `de`, `fr`, `ar` |
| `{{DIR}}` | Text direction | `ltr` or `rtl` |
| `{{TITLE}}` | Article title | `Odermatt Wins Adelboden Giant Slalom` |
| `{{META_DESCRIPTION}}` | SEO description | `Marco Odermatt claims his 40th...` |
| `{{EXCERPT}}` | Short excerpt | Same as meta or shorter |
| `{{SLUG}}` | URL slug | `odermatt-adelboden-giant-slalom-2026` |
| `{{LANG_PATH}}` | Language path prefix | `` (en), `de/`, `fr/` |
| `{{CATEGORY_SLUG}}` | Category URL | `alpine-skiing` |
| `{{CATEGORY_NAME}}` | Category display name | `Alpine Skiing` |
| `{{PUBLISHED_ISO}}` | ISO date | `2026-01-11T14:30:00+01:00` |
| `{{PUBLISHED_DATE}}` | Localized date | `January 11, 2026` |
| `{{READING_TIME}}` | Estimated read time | `4 min read` |
| `{{CONTENT}}` | Article body HTML | Full article content |
| `{{STRUCTURED_DATA}}` | JSON-LD schema | Article schema |
| `{{NAV_*}}` | Navigation labels | Localized nav text |
| `{{APP_BANNER_*}}` | App promo text | Localized app CTA |
| `{{FOOTER_*}}` | Footer text | Localized footer |
| `{{SKIP_LINK_TEXT}}` | Accessibility text | `Skip to content` |
| `{{SELECT_LANG}}` | Language selector label | `Select language` |
| `{{LANG_XX_SELECTED}}` | Selected attribute | `selected` or `` |

---

## Localized Strings Database

Each language needs these UI strings:

```json
{
  "en": {
    "nav_news": "News",
    "nav_alpine": "Alpine Skiing",
    "nav_biathlon": "Biathlon",
    "nav_athletes": "Athletes",
    "nav_app": "Get the App",
    "skip_link": "Skip to content",
    "select_lang": "Select language",
    "reading_time": "{{minutes}} min read",
    "app_banner_title": "Never Miss a Race",
    "app_banner_text": "Get notifications for schedule changes and save your favorites.",
    "app_banner_cta": "Download the App",
    "footer_app": "Get the App",
    "footer_privacy": "Privacy",
    "footer_support": "Support",
    "footer_disclaimer": "Independent winter sports coverage."
  },
  "de": {
    "nav_news": "Nachrichten",
    "nav_alpine": "Ski Alpin",
    "nav_biathlon": "Biathlon",
    "nav_athletes": "Athleten",
    "nav_app": "App herunterladen",
    "skip_link": "Zum Inhalt springen",
    "select_lang": "Sprache wählen",
    "reading_time": "{{minutes}} Min. Lesezeit",
    "app_banner_title": "Verpasse kein Rennen",
    "app_banner_text": "Erhalte Benachrichtigungen bei Programmänderungen und speichere deine Favoriten.",
    "app_banner_cta": "App herunterladen",
    "footer_app": "App herunterladen",
    "footer_privacy": "Datenschutz",
    "footer_support": "Support",
    "footer_disclaimer": "Unabhängige Wintersport-Berichterstattung."
  }
  // ... other languages
}
```

---

## n8n Workflow Structure

### Workflow 1: RSS Feed Monitor

**Nodes:**
1. **Schedule Trigger** → Every 15 minutes during race hours
2. **RSS Read** → Fetch from all configured feeds
3. **Filter** → Deduplicate, relevance check
4. **Legal Check (Code)** → Scan for forbidden terms
5. **Route** → Breaking news vs standard article
6. **Webhook** → Trigger content generation workflow

### Workflow 2: Content Generator

**Nodes:**
1. **Webhook Trigger** → Receive from RSS monitor or scheduler
2. **HTTP Request (Claude API)** → Generate English article
3. **Parse JSON** → Extract title, content, metadata
4. **Split In Batches** → 10 language translations
5. **HTTP Request (Claude API)** → Translate each
6. **Aggregate** → Collect all translations
7. **Code** → Generate HTML files from template
8. **HTTP Request/FTP** → Deploy files

### Workflow 3: Scheduled Previews

**Nodes:**
1. **Schedule Trigger** → Check schedule database
2. **Postgres/HTTP** → Get races starting in 24 hours
3. **Filter** → Skip if preview already exists
4. **Webhook** → Trigger content generation with preview type

### Workflow 4: Deployment

**Nodes:**
1. **Webhook Trigger** → Receive generated files
2. **SSH/SFTP** → Connect to VPS
3. **Write Files** → Create directory structure
4. **Verify** → Check files accessible
5. **Notify** → Log success/failure

---

## Deployment Options

### Option A: Direct VPS Deployment (Recommended)

```
n8n → SSH/SFTP → VPS (/var/www/neve26.com/)
```

Pros: Simplest, fastest
Cons: Requires SSH credentials in n8n

### Option B: Git-based Deployment

```
n8n → GitHub API (commit) → GitHub Actions → VPS
```

Pros: Version control, rollback capability
Cons: More complex, slight delay

### Option C: CDN/S3 Deployment

```
n8n → AWS S3 → CloudFront
```

Pros: Scalable, cheap
Cons: More infrastructure to manage

---

## File Output Structure

For each article, create 11 files:

```
/var/www/neve26.com/
├── odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # English (default)
├── de/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # German
├── fr/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # French
├── it/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Italian
├── es/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Spanish
├── pt/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Portuguese
├── nl/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Dutch
├── ar/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Arabic (RTL)
├── ja/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Japanese
├── zh/odermatt-adelboden-giant-slalom-2026/
│   └── index.html                          # Chinese
└── ko/odermatt-adelboden-giant-slalom-2026/
    └── index.html                          # Korean
```

---

## Monitoring & Logging

### Success Metrics

- Articles generated per day
- Translation success rate
- Deployment success rate
- Average time from trigger to live

### Error Handling

1. **RSS failure**: Retry 3 times, then alert
2. **Claude API failure**: Queue for retry, alert after 3 failures
3. **Deployment failure**: Store locally, manual intervention alert
4. **Legal check failure**: Block publication, alert for review

### Alerts

Configure n8n to send alerts via:
- Email
- Slack/Discord webhook
- Telegram

---

## Security Considerations

1. **API Keys**: Store in n8n credentials, never in workflow
2. **SSH Keys**: Use key-based auth, not passwords
3. **Content Validation**: Sanitize all generated HTML
4. **Rate Limiting**: Respect API limits (Claude, RSS sources)
5. **Backup**: Store article JSON before deployment

---

## Implementation Checklist

- [ ] Set up n8n workflows on VPS
- [ ] Configure Claude API credentials
- [ ] Set up RSS feed monitoring
- [ ] Create localized strings database
- [ ] Configure VPS deployment access
- [ ] Test with sample article
- [ ] Set up monitoring/alerts
- [ ] Document recovery procedures

---

## Cost Estimates

| Service | Usage | Monthly Cost |
|---------|-------|--------------|
| Claude API | ~100 articles × 12 calls | ~$50-100 |
| n8n Cloud (optional) | Starter plan | $24 |
| VPS (hosting) | Already have | $0 |

Total: ~$50-100/month for full automation

---

*Last updated: January 8, 2026*
