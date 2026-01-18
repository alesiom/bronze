# Neve26 Architecture Decisions

This document records key architectural decisions for the Neve26 platform.

---

## URL Structure

**Decision Date:** 2026-01-11

### Hierarchical URL Pattern

All content follows a hierarchical URL structure for better SEO and user navigation:

```
/{category}/{slug}/
/{lang}/{category}/{slug}/   (for non-English)
```

### Category URL Mappings

| Category | URL Path | Content Type |
|----------|----------|--------------|
| `athlete-profile` | `/athletes/` | Athlete profiles and bios |
| `venue-guide` | `/venues/` | Venue/location guides |
| `historical` | `/history/` | Historical articles |
| `sport-explainer` | `/guides/` | Sport explainers and how-to |
| `alpine-skiing` | `/alpine-skiing/` | Alpine skiing news |
| `biathlon` | `/biathlon/` | Biathlon news |
| `cross-country` | `/cross-country/` | Cross-country skiing news |
| `ski-jumping` | `/ski-jumping/` | Ski jumping news |
| `freestyle` | `/freestyle/` | Freestyle skiing news |
| `snowboard` | `/snowboard/` | Snowboard news |
| `nordic-combined` | `/nordic-combined/` | Nordic combined news |
| `news` | `/news/` | General winter sports news |

### URL Examples

```
# Athletes (actual slugs from database)
/athletes/marco-odermatt-profile/
/de/athletes/marco-odermatt-profile/
/athletes/mikaela-shiffrin-profile/
/fr/athletes/johannes-thingnes-boe-profile/

# Venues
/venues/kitzbuehel-venue-guide/
/venues/anterselva-antholz-venue-guide/
/de/venues/cortina-dampezzo-venue-guide/

# History
/history/the-streif-kitzbuehel-history/
/history/biathlon-world-cup-history/
/it/history/history-of-alpine-skiing/

# Sport Guides
/guides/alpine-skiing-disciplines-explained/
/guides/biathlon-explained-skiing-meets-shooting/
/ja/guides/ski-jumping-scoring-technique-explained/

# News by Sport (when news articles exist)
/alpine-skiing/adelboden-preview-2026/
/biathlon/giacomel-oberhof-victory/
```

### Internal Link Rules

**CRITICAL:** All internal links within article content must be language-aware:

| Content Language | Link Format |
|-----------------|-------------|
| English (`en`) | `/athletes/marco-odermatt-profile/` |
| German (`de`) | `/de/athletes/marco-odermatt-profile/` |
| French (`fr`) | `/fr/athletes/marco-odermatt-profile/` |
| ... | `/{lang}/...` |

This applies to:
- Links to other articles
- Links to category pages (`/alpine-skiing/`, `/biathlon/`, etc.)
- Navigation links in article content

**Exception:** Static pages (`/app`, `/privacy`, `/support`) don't use language prefixes.

---

## Content Filtering Rules

### Homepage (`/`)
- Shows ALL content types by default
- Filter buttons: All | News | Athletes | Venues | History | Guides
- Default filter: "All" (shows everything, most recent first)

### Category Pages

| Page | Shows | Excludes |
|------|-------|----------|
| `/athletes/` | Only `athlete-profile` | Everything else |
| `/venues/` | Only `venue-guide` | Everything else |
| `/history/` | Only `historical` | Everything else |
| `/guides/` | Only `sport-explainer` | Everything else |
| `/alpine-skiing/` | Alpine news + alpine venues + alpine history | Athletes, other sports |
| `/biathlon/` | Biathlon news + biathlon venues + biathlon history | Athletes, other sports |

**Key Rule:** Athletes NEVER appear on sport-specific pages. They only appear on:
1. Homepage (when "All" or "Athletes" filter is selected)
2. `/athletes/` page

---

## Navigation Structure

### Main Navigation
```
News | Alpine | Biathlon | Athletes | Get App
```

### Homepage Filters
```
All | News | Athletes | Venues | History | Guides
```

### Breadcrumbs Pattern
```
Home > Category > Article Title
```

Examples:
- Home > Athletes > Marco Odermatt
- Home > Venues > Kitzbühel
- Home > Alpine Skiing > Adelboden Preview

---

## Supported Languages

| Code | Name | Direction | URL Path |
|------|------|-----------|----------|
| en | English | LTR | `/` (default) |
| de | Deutsch | LTR | `/de/` |
| fr | Français | LTR | `/fr/` |
| it | Italiano | LTR | `/it/` |
| es | Español | LTR | `/es/` |
| pt | Português | LTR | `/pt/` |
| nl | Nederlands | LTR | `/nl/` |
| ar | العربية | RTL | `/ar/` |
| ja | 日本語 | LTR | `/ja/` |
| zh | 中文 | LTR | `/zh/` |
| ko | 한국어 | LTR | `/ko/` |

---

## File Storage

### Article HTML Files
- Location: `/var/www/neve26.com/` (Docker volume `html_content`)
- Pattern: `/{category}/{slug}/index.html`
- Language versions: `/{lang}/{category}/{slug}/index.html`

### Static Assets
- Location: `/usr/share/nginx/html/` (website container)
- Includes: logos, favicons, app.html, privacy.html, support.html

---

## Database Schema Notes

### Articles Table - Category Values
The `category` column uses these exact values:
- `athlete-profile`
- `venue-guide`
- `historical`
- `sport-explainer`
- `alpine-skiing`
- `biathlon`
- `cross-country`
- `ski-jumping`
- `freestyle`
- `snowboard`
- `nordic-combined`
- `news`

### Sport Codes
Used for filtering content by sport:
- `ALP` / `AS` - Alpine Skiing
- `BT` / `BTH` - Biathlon
- `CC` - Cross-Country
- `SJ` - Ski Jumping
- `NC` - Nordic Combined
- `FS` - Freestyle
- `SB` - Snowboard

---

## Social Media API Decision

**Decision:** Hybrid approach using Late.dev for posting + Native Instagram API for engagement.

| Function | Solution | Cost |
|----------|----------|------|
| Posting (all platforms) | Late.dev Accelerate | $33/mo ($396/yr) |
| Engagement (Instagram) | Native Graph API | $0 |

**Rationale:**
- Late.dev handles 12 platforms with one API (X, Instagram, TikTok, LinkedIn, Threads, etc.)
- X free tier is unusable (17 tweets/day app-wide) - Basic tier costs $1,200/yr alone
- Late.dev at $396/yr is 3x cheaper than X Basic alone
- Native Instagram adds comment reading/replying for free
- n8n integration built-in, no token refresh management

See `docs/archive/DECISION_social_media_api.md` for full research.

---

## Change Log

### 2026-01-12
- Added Internal Link Rules section documenting language-aware linking
- Updated URL examples with actual slugs from database
- Published 78 articles across all categories
- Fixed internal links in all articles to use correct category prefixes and language paths

### 2026-01-11
- Established hierarchical URL structure
- Defined category filtering rules (athletes only on /athletes/ and homepage)
- Documented all content categories and URL mappings
