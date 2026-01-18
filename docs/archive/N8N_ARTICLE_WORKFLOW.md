# n8n FIS Article Generator Workflow - TICKET-005

**Date**: January 8, 2026
**Status**: Complete
**Location**: n8n.neve26.com

---

## Overview

Automated workflow to generate news articles from FIS World Cup race results.

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Cron       │────▶│  Fetch FIS  │────▶│  Parse HTML │
│  (5 min)    │     │  Results    │     │  + Extract  │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                    ┌─────────────┐     ┌──────▼──────┐
                    │  Legal      │◀────│  Claude API │
                    │  Validation │     │  Generate   │
                    └──────┬──────┘     └─────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            │            ▼
       ┌─────────────┐     │     ┌─────────────┐
       │  ❌ Log     │     │     │  ✅ POST to │
       │  Violation  │     │     │  Neve26 API │
       └─────────────┘     │     └──────┬──────┘
                           │            │
                           │     ┌──────▼──────┐
                           │     │  Trigger    │
                           │     │  Translation│
                           │     └─────────────┘
```

---

## Import Instructions

### Step 1: Import Workflow

1. Open n8n.neve26.com
2. Go to **Workflows** → **Import from File**
3. Select `/workflows/fis-article-generator.json`
4. Click **Import**

### Step 2: Configure Credentials

#### Anthropic API Key
1. Go to **Settings** → **Credentials**
2. Create new **Header Auth** credential
3. Name: `Anthropic API`
4. Header Name: `x-api-key`
5. Header Value: `sk-ant-...` (your Claude API key)

#### Neve26 API Key (if using auth)
1. Create new **Header Auth** credential
2. Name: `Neve26 API`
3. Header Name: `Authorization`
4. Header Value: `Bearer <your-token>`

### Step 3: Set Race ID

Before each race day, update the workflow:

1. Open **Fetch FIS Results** node
2. Update URL parameter with race ID:
   ```
   https://www.fis-ski.com/DB/general/results.html?sectorcode=AL&raceid=127374
   ```

**Adelboden 2026 Race IDs:**
| Race | Date | Race ID |
|------|------|---------|
| Men's GS | Jan 10 | 127374 |
| Men's SL | Jan 11 | 127375 |

---

## Workflow Nodes

### 1. Race Day Cron
- **Type**: Schedule Trigger
- **Interval**: Every 5 minutes
- **Note**: Manually enable/disable on race days

### 2. Fetch FIS Results
- **Type**: HTTP Request
- **Method**: GET
- **URL**: FIS results page (set race ID)
- **Headers**: Custom User-Agent

### 3. Parse FIS HTML
- **Type**: Code (JavaScript)
- **Function**:
  - Extract `window.fisProperties` metadata
  - Parse results table with regex
  - Generate content hash for change detection
  - Return structured results data

### 4. Has Results?
- **Type**: IF
- **Condition**: `resultCount > 0`
- **True**: Continue to article generation
- **False**: Stop (race not finished)

### 5. Generate Article (Claude)
- **Type**: HTTP Request
- **URL**: `https://api.anthropic.com/v1/messages`
- **Model**: claude-sonnet-4-20250514
- **Prompt**: Includes race data + legal rules + format instructions

### 6. Parse & Legal Check
- **Type**: Code (JavaScript)
- **Function**:
  - Parse Claude JSON response
  - Check against legal blocklist
  - Generate URL slug
  - Return validated article or error

### 7. Legal Check Passed?
- **Type**: IF
- **Condition**: `legalCheck === 'passed'`
- **True**: Create article
- **False**: Log violation (manual review)

### 8. Create Article in API
- **Type**: HTTP Request
- **Method**: POST
- **URL**: `https://api.neve26.com/api/v1/articles`
- **Body**: Article JSON with multilingual structure

### 9. Trigger Translation Workflow
- **Type**: HTTP Request (Webhook)
- **URL**: `https://n8n.neve26.com/webhook/translate-article`
- **Purpose**: Starts separate workflow for 10-language translation

---

## Legal Blocklist

The workflow automatically rejects articles containing:

```javascript
const blocklist = [
  'olympic', 'olympics', 'olympiad', 'olimpico', 'olimpiade',
  'paralympic', 'paralimpico',
  'milano cortina 2026', 'cortina 2026', 'milano 2026',
  'winter games 2026', 'games of 2026', 'the games',
  'going for gold', 'medal hopes',
  'team usa', 'team italy', 'team canada', 'team france', 'team germany'
];
```

**On violation**: Article is logged but NOT published. Manual review required.

---

## Claude Prompt

```
Write a news article about this FIS Alpine Skiing World Cup race result.

RACE DATA:
{{ podium results JSON }}

WINNER: {{ name }} ({{ nation }}) - {{ total time }}

RULES:
1. Write in English, 200-300 words
2. Focus on the winner and podium
3. Include specific times and margins
4. NEVER use these banned terms: Olympic, Olympics, Milano Cortina 2026, Winter Games 2026, going for gold, Team USA, Team Italy
5. Use only: FIS World Cup, Alpine Skiing, athlete names, venue names
6. Professional sports journalism tone
7. Include a compelling headline

Format as JSON:
{
  "headline": "...",
  "excerpt": "One sentence summary...",
  "content": "Full article HTML with <p> tags..."
}
```

---

## API Payload Format

```json
{
  "slug": "odermatt-dominates-adelboden-giant-slalom",
  "title": {
    "en": "Odermatt Dominates Adelboden Giant Slalom"
  },
  "excerpt": {
    "en": "Swiss star claims fourth consecutive victory..."
  },
  "content": {
    "en": "<p>Marco Odermatt continued his incredible form...</p>"
  },
  "category": "alpine-skiing",
  "sport_code": "ALP",
  "status": "draft"
}
```

---

## Race Day Checklist

### Before Race
- [ ] Verify race ID from FIS calendar
- [ ] Update race ID in workflow
- [ ] Enable cron trigger
- [ ] Test with manual execution (expect "no results")

### During Race
- [ ] Monitor n8n executions
- [ ] Check for parse errors
- [ ] Watch for legal violations

### After Race
- [ ] Verify article created in API
- [ ] Review article quality
- [ ] Approve for publication (change status to 'published')
- [ ] Disable cron until next race

---

## Troubleshooting

### No Results Parsed
- Check if race has finished (results posted ~15min after final run)
- Verify race ID is correct
- Check FIS website manually

### Legal Violation
- Review the violations list in logs
- Manually edit article to remove terms
- Re-trigger via API

### Claude Parse Error
- Check Claude API response format
- Verify API key is valid
- Check rate limits

### API Post Failed
- Verify API endpoint is running
- Check authentication
- Review request payload format

---

## Related Files

- **Workflow JSON**: `/workflows/fis-article-generator.json`
- **FIS Research**: `/docs/FIS_SCRAPER_RESEARCH.md`
- **Project Context**: `/docs/PARALLEL_WORK_CONTEXT.md`

---

## Next: Translation Workflow (TICKET-006)

After article is created in English, trigger translation workflow to generate 10 additional languages via Claude API.
