# Neve26 n8n Workflows

This directory contains n8n workflow definitions for automating Neve26 content operations.

## Workflows

### 1. HTML Generator Workflow (`html-generator-workflow.json`)

Generates static HTML article pages from the database in all 11 languages.

#### Import Instructions

1. Open n8n at `https://n8n.neve26.com`
2. Go to **Workflows** → **Import from File**
3. Select `html-generator-workflow.json`
4. Activate the workflow

#### Workflow Steps

```
Webhook Trigger
    │
    ▼
Fetch Article from API
    │
    ▼
Split into 11 Languages
    │
    ▼
Prepare Template Data (for each language)
    │
    ▼
Generate HTML (apply template)
    │
    ▼
Write Files to Disk
    │
    ▼
Respond with Success
```

#### Configuration

**Webhook URL:**
```
POST https://n8n.neve26.com/webhook/generate-html
```

**Payload:**
```json
{
  "slug": "adelboden-giant-slalom-preview-2026"
}
```

**File Output Location:**
Files are written to `/var/www/neve26.com/` with this structure:
```
/var/www/neve26.com/
├── adelboden-giant-slalom-preview-2026/
│   └── index.html           # English (default)
├── de/
│   └── adelboden-giant-slalom-preview-2026/
│       └── index.html       # German
├── fr/
│   └── adelboden-giant-slalom-preview-2026/
│       └── index.html       # French
└── ... (all 11 languages)
```

#### Environment Requirements

- n8n must have filesystem access to `/var/www/neve26.com/`
- API must be accessible at `https://api.neve26.com`
- Node: `Read/Write File` node requires appropriate permissions

#### Testing Locally

1. Import the workflow
2. Replace file output path with local path (e.g., `/tmp/neve26/`)
3. Trigger manually with test payload:
   ```bash
   curl -X POST https://n8n.neve26.com/webhook/generate-html \
     -H "Content-Type: application/json" \
     -d '{"slug": "adelboden-giant-slalom-preview-2026"}'
   ```

---

## Languages Supported

| Code | Language | Direction |
|------|----------|-----------|
| en | English | LTR |
| de | Deutsch | LTR |
| fr | Français | LTR |
| it | Italiano | LTR |
| es | Español | LTR |
| pt | Português | LTR |
| nl | Nederlands | LTR |
| ar | العربية | RTL |
| ja | 日本語 | LTR |
| zh | 中文 | LTR |
| ko | 한국어 | LTR |

---

## URL Structure

| Language | URL Pattern |
|----------|-------------|
| English | `neve26.com/{slug}/` |
| Others | `neve26.com/{lang}/{slug}/` |

Examples:
- `neve26.com/adelboden-giant-slalom-preview-2026/`
- `neve26.com/de/adelboden-giant-slalom-preview-2026/`
- `neve26.com/ar/adelboden-giant-slalom-preview-2026/`

---

## Integration with Article Creation

The HTML generator workflow is triggered automatically by the Article Generation workflow:

```
Article Creation Workflow
    │
    ├─ 1. Scrape results from FIS/IBU
    ├─ 2. Generate article via Claude API
    ├─ 3. Validate legal compliance
    ├─ 4. Translate to 11 languages
    ├─ 5. Store in PostgreSQL
    │
    └─ 6. Call HTML Generator Webhook ──► Generates static files
```

---

## Troubleshooting

### Workflow fails to write files

1. Check n8n has write permissions:
   ```bash
   ls -la /var/www/neve26.com/
   ```

2. Ensure target directories exist:
   ```bash
   mkdir -p /var/www/neve26.com/{de,fr,it,es,pt,nl,ar,ja,zh,ko}
   ```

### API returns 404

1. Verify article exists:
   ```bash
   curl https://api.neve26.com/api/v1/articles/your-article-slug
   ```

2. Check article is published (status = 'published')

### HTML rendering issues

1. Check article content is valid HTML
2. Verify JSONB language keys match expected codes
3. Test with a simple article first

---

## Manual HTML Generation

If you need to regenerate HTML for an existing article:

```bash
# Via webhook
curl -X POST https://n8n.neve26.com/webhook/generate-html \
  -H "Content-Type: application/json" \
  -d '{"slug": "article-slug-here"}'

# Or trigger manually in n8n UI:
# 1. Open workflow
# 2. Click "Execute Workflow"
# 3. Provide test data in webhook node
```

---

## Customizing the Template

The HTML template is embedded in the "Generate HTML" code node. To modify:

1. Open the workflow in n8n
2. Edit the "Generate HTML" node
3. Modify the `template` variable
4. Save and test

Key template variables:
- `{{title}}` - Article title
- `{{content}}` - Article HTML content
- `{{publishedDate}}` - Formatted publish date
- `{{categoryName}}` - Localized category name
- `{{ui.*}}` - UI string translations
- `{{langSelected.*}}` - Language selector states

---

## Performance Notes

- Generates 11 HTML files per article
- Typical execution time: 2-5 seconds
- Files are ~15-25 KB each (minified CSS)
- Total output per article: ~180-250 KB across all languages

---

## Social Media Workflows

These workflows are hosted directly in n8n (not as JSON files). Created January 2026.

### 2. Quote Posts (`1ahAetO3d4KY71iW`)

Automated 8x daily scheduled quote posts for Phase 1 brand building.

**Schedule (CET):**
| Time | Content |
|------|---------|
| 07:00 | Alpine Skiing |
| 09:00 | General Motivation |
| 11:00 | Alpine Skiing |
| 13:00 | Biathlon |
| 15:00 | Sport Explainer |
| 17:00 | General Motivation |
| 19:00 | Figure Skating |
| 21:00 | Snowboarding |

**Flow:**
```
Schedule Trigger → Quote Database → Format Post → Post to X → Record Post Time → Log
```

**Configuration Required:**
1. Add X/Twitter OAuth2 credentials to the "Post to X" node
2. Activate workflow

**Phase 1 Rules (Jan 7-17):**
- NO app mentions
- NO website links
- Just engaging winter sports content + hashtags

---

### 3. Race Day Alerts (`qZ3EyJinwJi6XnKv`)

Webhook-triggered alerts for live race updates and results.

**Webhook URL:**
```
POST https://n8n.neve26.com/webhook/race-alert
```

**Payload:**
```json
{
  "type": "result",
  "event": "Adelboden Giant Slalom",
  "winner": "Marco Odermatt",
  "handle": "@marcodermatt",
  "sport": "alpine-skiing"
}
```

**Alert Types:**
- `start` - Race starting soon
- `live` - Race in progress
- `result` - Race finished with winner

**Configuration Required:**
1. Add X/Twitter OAuth2 credentials
2. Activate workflow
3. Call webhook from external trigger (FIS scraper, manual, etc.)

---

### 4. FIS Article Generator (`kBp7MyP9YugCOMC3`)

Auto-generates news articles from FIS race results using Claude API.

**Flow:**
```
Webhook → Fetch FIS Results → Claude Article Generation → Legal Validation →
Translate to 11 Languages → Store in PostgreSQL → Trigger HTML Generator
```

**Webhook URL:**
```
POST https://n8n.neve26.com/webhook/generate-article
```

**Payload:**
```json
{
  "race_id": "12345",
  "event": "Adelboden Giant Slalom",
  "date": "2026-01-11"
}
```

**Configuration Required:**
1. Set `ANTHROPIC_API_KEY` environment variable in n8n
2. Configure PostgreSQL connection
3. Activate workflow

**Legal Safeguards:**
- Auto-checks against `legal_blocklist` table
- Blocks: Olympic, Olympics, Milano Cortina, Winter Games 2026, Team USA/Italy, etc.
- Fine risk: €100K-€2.5M (Italian Law 31/2020)

---

### 5. Engagement Auto-Reply (`pw0FjV5zOTM0n6T2`)

Monitors mentions and auto-replies with human-like timing.

**Polling:** Every 15 minutes (matches X API Free tier rate limit)

**Rate Limits (X API Free Tier):**
| Resource | Limit | Our Usage |
|----------|-------|-----------|
| GET mentions | 1/15 min (96/day) | ✅ Plenty |
| POST tweets | 17/day total | 8 quotes + 9 replies |

**Daily Caps:**
- Quote Posts: 8/day (scheduled)
- Replies: 9/day (auto-limited in workflow)
- Total: 17/day (matches Free tier limit)

**Response Timing (Human-like):**
| Context | Delay Range |
|---------|-------------|
| CET daytime (07:00-22:00) | 8-67 minutes |
| CET nighttime (22:00-07:00) | 2-5 hours |

**Bot Personality:**
- Sports nerd energy (obscure stats, historic moments)
- Funny, quirky, cheeky
- ULTRA SHORT replies: "right?", "let's go!", "yep.", "100%", "absolute legend 🔥"
- Slang OK: "lowkey", "ngl", "fr fr", "massive W"
- Emojis sparingly: ⛷️🎿🔥

**Flow:**
```
Schedule (15 min) → Search to:neve2026 → Check daily limit (9 max) →
Filter already replied → Calculate delay → Wait → Generate reply (Claude) → Post reply → Update counter
```

**Configuration Required:**
1. Add X/Twitter OAuth2 credentials
2. Set `ANTHROPIC_API_KEY` environment variable
3. Activate workflow

**Banned Terms in Replies:**
- Olympic, Olympics
- Milano Cortina, Winter Games 2026
- Team USA, Team Italy, etc.

---

## Workflow Status Summary

| ID | Name | Status | Needs |
|----|------|--------|-------|
| - | HTML Generator | JSON file | Import + activate |
| `1ahAetO3d4KY71iW` | Quote Posts | Created | X credentials + activate |
| `qZ3EyJinwJi6XnKv` | Race Day Alerts | Created | X credentials + activate |
| `kBp7MyP9YugCOMC3` | FIS Article Generator | Created | Claude API key + PostgreSQL + activate |
| `pw0FjV5zOTM0n6T2` | Engagement Auto-Reply | Created | X credentials + Claude API key + activate |

---

## Required Credentials Setup

### X/Twitter OAuth2

1. Go to https://developer.twitter.com
2. Create app with read/write permissions
3. In n8n: Settings → Credentials → Add "Twitter OAuth2"
4. Enter Client ID and Client Secret
5. Authorize the connection

### Anthropic API Key

1. Get key from https://console.anthropic.com
2. In n8n: Settings → Variables
3. Add `ANTHROPIC_API_KEY` environment variable

### PostgreSQL

1. In n8n: Settings → Credentials → Add "Postgres"
2. Configure:
   - Host: `localhost` (or Docker network name)
   - Database: `neve26`
   - User: `postgres`
   - Password: (from docker-compose.yml)
