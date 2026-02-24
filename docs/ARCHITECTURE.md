# Bronze Architecture Decisions

This document records key architectural decisions for the Bronze platform.

---

## URL Structure

**Decision Date:** 2026-01-11 (Neve26), updated 2026-02-23 (Bronze pivot)

### Hierarchical URL Pattern

All content follows a hierarchical URL structure for better SEO and user navigation:

```
/{category}/{slug}/
/{lang}/{category}/{slug}/   (for non-English)
```

### Category URL Mappings

| Category | URL Path | Content Type |
|----------|----------|--------------|
| `news` | `/news/` | General sports news |
| `athlete-profile` | `/athletes/` | Athlete profiles and features |
| `sport-explainer` | `/guides/` | Sport explainers and how-to |
| `football` | `/football/` | Football coverage |
| `tennis` | `/tennis/` | Tennis coverage |
| `athletics` | `/athletics/` | Athletics / track & field |
| `cycling` | `/cycling/` | Cycling coverage |
| `motorsport` | `/motorsport/` | F1, MotoGP, etc. |
| `winter-sports` | `/winter-sports/` | Alpine, biathlon, XC, etc. |
| `swimming` | `/swimming/` | Swimming & aquatics |
| `other` | `/other/` | Everything else worth writing about |

> Category list will evolve. Start broad, refine based on what we actually cover.

### URL Examples

```
# Athletes
/athletes/carlos-alcaraz-profile/
/de/athletes/carlos-alcaraz-profile/
/athletes/sydney-mclaughlin-levrone-profile/
/fr/athletes/tadej-pogacar-profile/

# Sport Guides
/guides/tennis-scoring-explained/
/guides/cycling-grand-tours-explained/
/de/guides/football-offside-rule-explained/

# News by Sport
/football/champions-league-quarter-finals-recap/
/tennis/australian-open-final-preview/
/cycling/tour-de-france-stage-12-recap/
/winter-sports/biathlon-world-cup-ruhpolding/
/motorsport/f1-bahrain-gp-qualifying/
```

### Internal Link Rules

**CRITICAL:** All internal links within article content must be language-aware:

| Content Language | Link Format |
|-----------------|-------------|
| English (`en`) | `/athletes/carlos-alcaraz-profile/` |
| German (`de`) | `/de/athletes/carlos-alcaraz-profile/` |
| French (`fr`) | `/fr/athletes/carlos-alcaraz-profile/` |

This applies to:
- Links to other articles
- Links to category pages (`/football/`, `/tennis/`, etc.)
- Navigation links in article content

**Exception:** Static pages (`/app`, `/privacy`, `/support`) don't use language prefixes.

---

## Content Filtering Rules

### Homepage (`/`)
- Shows ALL content types by default
- Filter buttons: All | News | Athletes | Guides
- Default filter: "All" (shows everything, most recent first)

### Category Pages

| Page | Shows | Excludes |
|------|-------|----------|
| `/athletes/` | Only `athlete-profile` | Everything else |
| `/guides/` | Only `sport-explainer` | Everything else |
| `/football/` | Football news | Athletes, other sports |
| `/tennis/` | Tennis news | Athletes, other sports |
| `/athletics/` | Athletics news | Athletes, other sports |
| `/cycling/` | Cycling news | Athletes, other sports |
| `/motorsport/` | Motorsport news | Athletes, other sports |
| `/winter-sports/` | Winter sports news | Athletes, other sports |
| `/swimming/` | Swimming news | Athletes, other sports |
| `/other/` | Other sports news | Athletes, other sports |

**Key Rule:** Athletes NEVER appear on sport-specific pages. They only appear on:
1. Homepage (when "All" or "Athletes" filter is selected)
2. `/athletes/` page

---

## Navigation Structure

### Main Navigation
```
News | Football | Tennis | Cycling | Athletes | Get App
```

> Navigation will evolve as coverage grows. Start with the most popular sports.

### Homepage Filters
```
All | News | Athletes | Guides
```

### Breadcrumbs Pattern
```
Home > Category > Article Title
```

Examples:
- Home > Athletes > Carlos Alcaraz
- Home > Football > Champions League Recap
- Home > Cycling > Tour de France Stage 12

---

## Supported Languages

> **Updated Feb 2026**: Reduced from 11 to 3 languages to cut LLM generation costs.

| Code | Name | Direction | URL Path |
|------|------|-----------|----------|
| en | English (UK) | LTR | `/` (default) |
| fr | Français | LTR | `/fr/` |
| de | Deutsch | LTR | `/de/` |

### Removed Languages (from Neve26 era)

IT, ES, PT, NL, AR, JA, ZH, KO — may be re-added if/when local LLM generation becomes viable.

---

## File Storage

### Article HTML Files
- Location: `/var/www/bronze.news/` (Docker volume `html_content`)
- Pattern: `/{category}/{slug}/index.html`
- Language versions: `/{lang}/{category}/{slug}/index.html`

### Static Assets
- Location: `/usr/share/nginx/html/` (website container)
- Includes: logos, favicons, app.html, privacy.html, support.html

---

## Database Schema Notes

### Articles Table - Category Values
The `category` column uses these exact values:
- `news`
- `athlete-profile`
- `sport-explainer`
- `football`
- `tennis`
- `athletics`
- `cycling`
- `motorsport`
- `winter-sports`
- `swimming`
- `other`

> Legacy Neve26 categories (`venue-guide`, `historical`, `alpine-skiing`, `biathlon`, `cross-country`, `ski-jumping`, `freestyle`, `snowboard`, `nordic-combined`) may still exist in the database for older articles. New content uses the categories above.

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

### 2026-02-23
- **REBRAND**: Neve26 → Bronze
- **PIVOT**: Reduced languages from 11 to 3 (EN-GB, FR, DE)
- Scope expanded from winter sports to all sports
- Content categories updated to general sports (football, tennis, cycling, etc.)
- Navigation structure updated for general sports
- Database category values updated
- File storage paths updated to bronze.news
- AI-generated image requirements added to content pipeline
- URL examples updated for general sports

### 2026-01-12
- Added Internal Link Rules section documenting language-aware linking
- Updated URL examples with actual slugs from database
- Published 78 articles across all categories
- Fixed internal links in all articles to use correct category prefixes and language paths

### 2026-01-11
- Established hierarchical URL structure
- Defined category filtering rules (athletes only on /athletes/ and homepage)
- Documented all content categories and URL mappings
