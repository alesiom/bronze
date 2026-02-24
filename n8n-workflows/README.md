# Bronze n8n Workflows

This directory contains n8n workflow definitions for automating Bronze content operations.

## Workflows

### 1. HTML Generator Workflow (`html-generator-workflow.json`)

Generates static HTML article pages from the database in all 3 languages.

#### Import Instructions

1. Open n8n at `https://n8n.bronze.news`
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
Split into 3 Languages
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
POST https://n8n.bronze.news/webhook/generate-html
```

**Payload:**
```json
{
  "slug": "mbappe-champions-league-hat-trick-2026"
}
```

**File Output Location:**
Files are written to `/var/www/bronze.news/` with this structure:
```
/var/www/bronze.news/
├── mbappe-champions-league-hat-trick-2026/
│   └── index.html           # English (default)
├── de/
│   └── mbappe-champions-league-hat-trick-2026/
│       └── index.html       # German
└── fr/
    └── mbappe-champions-league-hat-trick-2026/
        └── index.html       # French
```

#### Environment Requirements

- n8n must have filesystem access to `/var/www/bronze.news/`
- API must be accessible at `https://api.bronze.news`
- Node: `Read/Write File` node requires appropriate permissions

#### Testing Locally

1. Import the workflow
2. Replace file output path with local path (e.g., `/tmp/bronze/`)
3. Trigger manually with test payload:
   ```bash
   curl -X POST https://n8n.bronze.news/webhook/generate-html \
     -H "Content-Type: application/json" \
     -d '{"slug": "mbappe-champions-league-hat-trick-2026"}'
   ```

---

## Languages Supported

| Code | Language | Direction |
|------|----------|-----------|
| en | English | LTR |
| de | Deutsch | LTR |
| fr | Français | LTR |

---

## URL Structure

| Language | URL Pattern |
|----------|-------------|
| English | `bronze.news/{slug}/` |
| Others | `bronze.news/{lang}/{slug}/` |

Examples:
- `bronze.news/mbappe-champions-league-hat-trick-2026/`
- `bronze.news/de/mbappe-champions-league-hat-trick-2026/`
- `bronze.news/fr/mbappe-champions-league-hat-trick-2026/`

---

## Integration with Article Creation

The HTML generator workflow is triggered automatically by the Article Generation workflow:

```
Article Creation Workflow
    │
    ├─ 1. Generate article via Claude API
    ├─ 2. Validate legal compliance
    ├─ 3. Translate to 3 languages
    ├─ 4. Store in PostgreSQL
    │
    └─ 5. Call HTML Generator Webhook ──► Generates static files
```

---

## Troubleshooting

### Workflow fails to write files

1. Check n8n has write permissions:
   ```bash
   ls -la /var/www/bronze.news/
   ```

2. Ensure target directories exist:
   ```bash
   mkdir -p /var/www/bronze.news/{de,fr}
   ```

### API returns 404

1. Verify article exists:
   ```bash
   curl https://api.bronze.news/api/v1/articles/your-article-slug
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
curl -X POST https://n8n.bronze.news/webhook/generate-html \
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

- Generates 3 HTML files per article
- Typical execution time: 1-3 seconds
- Files are ~15-25 KB each (minified CSS)
- Total output per article: ~50-75 KB across all languages

---

## Social Media Workflows

These workflows are hosted directly in n8n (not as JSON files).

### 2. Quote Posts (`1ahAetO3d4KY71iW`)

Automated scheduled quote posts for brand building.

**Flow:**
```
Schedule Trigger → Quote Database → Format Post → Post to X → Record Post Time → Log
```

**Configuration Required:**
1. Add X/Twitter OAuth2 credentials to the "Post to X" node
2. Activate workflow

---

### 3. Article Generator (`kBp7MyP9YugCOMC3`)

Auto-generates news articles using Claude API.

**Flow:**
```
Webhook → Source Data → Claude Article Generation → Legal Validation →
Translate to 3 Languages → Store in PostgreSQL → Trigger HTML Generator
```

**Webhook URL:**
```
POST https://n8n.bronze.news/webhook/generate-article
```

**Configuration Required:**
1. Set `ANTHROPIC_API_KEY` environment variable in n8n
2. Configure PostgreSQL connection
3. Activate workflow

---

### 4. Engagement Auto-Reply (`pw0FjV5zOTM0n6T2`)

Monitors mentions and auto-replies with human-like timing.

**Polling:** Every 15 minutes (matches X API Free tier rate limit)

**Flow:**
```
Schedule (15 min) → Search to:bronzenews → Check daily limit →
Filter already replied → Calculate delay → Wait → Generate reply (Claude) → Post reply → Update counter
```

**Configuration Required:**
1. Add X/Twitter OAuth2 credentials
2. Set `ANTHROPIC_API_KEY` environment variable
3. Activate workflow

---

## Workflow Status Summary

| ID | Name | Status | Needs |
|----|------|--------|-------|
| - | HTML Generator | JSON file | Import + activate |
| `1ahAetO3d4KY71iW` | Quote Posts | Created | X credentials + activate |
| `kBp7MyP9YugCOMC3` | Article Generator | Created | Claude API key + PostgreSQL + activate |
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
   - Database: `neve26` (legacy name, intentional)
   - User: `postgres`
   - Password: (from docker-compose.yml)
