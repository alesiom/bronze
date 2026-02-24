# Project Vision

> **STATUS: REBRANDING (Feb 2026)**
> Evolved from Neve26 (winter-only, 2026-scoped) to **Bronze** — a general sports platform.

**Bronze** is an **ad-free, fully accessible (WCAG AAA), independent sports news platform** with a companion mobile app for schedules and notifications.

The voice is **smart-funny** — witty, warm, celebrating sports and sportsmanship. Think: the friend who actually watches the race and has something clever to say about it.

---

## What Changed (Feb 2026 Pivot)

| Before (Neve26) | After (Bronze) |
|------------------|-------------|
| Winter sports only | All sports |
| Tied to 2026 season | Ongoing / no expiry |
| 11 languages | 3 languages (EN-GB, FR, DE) |
| Neutral/informative tone | Smart-funny, celebratory |
| No visual identity per article | Key visual + secondary image per article |
| Stock/rights-free photos | 100% AI-generated images, clearly styled as AI |

### What Stays

- Ad-free, always
- WCAG AAA accessible
- Independent, no federation affiliation
- Privacy-first (Matomo)
- Same tech stack (FastAPI, PostgreSQL, nginx, n8n, Expo)
- Same product split (free website + paid app)

---

## Product Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                         Bronze ECOSYSTEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  WEBSITE (bronze.news) - FREE                                   │
│  ├─ All news articles                                          │
│  ├─ Athlete profiles                                           │
│  ├─ Sport explainers                                           │
│  ├─ 3 languages (EN-GB, FR, DE)                                │
│  ├─ WCAG AAA accessible                                        │
│  ├─ Ad-free                                                    │
│  ├─ AI-generated visuals (clearly labelled)                    │
│  └─ NO schedule, NO notifications, NO favorites                │
│                                                                 │
│  APP (iOS + Android) - PAID $2.99                              │
│  ├─ Event schedule/calendar                                    │
│  ├─ Push notifications                                         │
│  ├─ Favorites (athletes, events, sports)                       │
│  ├─ Offline mode                                               │
│  ├─ News (same content as website)                             │
│  ├─ 3 languages (EN-GB, FR, DE)                                │
│  └─ WCAG AAA accessible                                        │
│                                                                 │
│  Clear separation:                                              │
│  Website = News destination (free)                             │
│  App = Utility tool (paid)                                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Business Model

| Platform | Price | Rationale |
|----------|-------|-----------|
| iOS | $2.99 | Unified pricing, lower friction |
| Android | $2.99 | Same price, simpler messaging |

- **No free tier on app** - Full paid app, no freemium
- **No paid tier on website** - Full free access to all news
- **Premium positioning**: Differentiate on accessibility + ad-free + personality

---

## Target Users

| Segment | Description | Why They Pay |
|---------|-------------|--------------|
| Event attendees | Fans physically at events | Need schedule + alerts |
| Accessibility community | Blind/low-vision sports fans | Finally a platform that works |
| Casual fans | Follow sports casually | Want reminders + enjoy the tone |
| Sports-curious | Not hardcore fans, but enjoy good writing | The voice draws them in |

---

## Editorial Voice

### Tone: Smart-Funny

- **Witty, not snarky** — we celebrate athletes, we don't mock them
- **Warm, not detached** — we genuinely love sport and it shows
- **Clever, not try-hard** — the joke lands because the writing is sharp, not because we forced a pun
- **Inclusive** — sportsmanship and sportswomanship, always. Equal weight to all athletes
- **Honest** — if something was boring, we say so (kindly). If it was extraordinary, we lose our minds a little

### What We're NOT

- Not a hot-take factory
- Not ironic-detached sports Twitter
- Not a stats dump with no personality
- Not gendered in coverage (women's sport gets the same energy)

### Reference Points (for tone, not to copy)

- The Guardian's sports writing at its best
- Defector (the warmth, the specificity)
- Secret Base / Jon Bois (the love letter to sport angle)

---

## Content Strategy

### What We Cover

- **All major sports**: Football, tennis, athletics, cycling, swimming, motorsport, winter sports, and more
- **Big events**: World Cups, Grand Slams, Championships, Grand Tours
- **Athlete profiles**: Career arcs, personality, what makes them interesting
- **Sport explainers**: Make any sport accessible to newcomers
- **The moments**: The stories within the results — drama, joy, heartbreak, absurdity

### Content Categories

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

### Visual Strategy

Every article gets:

1. **Key visual** — AI-generated hero image, bold and stylised
2. **Secondary image** — AI-generated, in-article illustration or moment capture

**AI image principles:**
- Clearly AI-generated aesthetic — stylised, not photorealistic
- Consistent visual language across the platform (TBD: style guide)
- Alt text always (WCAG AAA)
- Labelled: "Image: AI-generated illustration" or similar
- No attempt to pass as photography

---

## Differentiators

| Differentiator | What It Means | Competitive Advantage |
|----------------|---------------|----------------------|
| **WCAG AAA** | Highest accessibility standard | Only sports platform at this level |
| **Ad-free** | No ads anywhere, ever | Clean experience |
| **Smart-funny voice** | Personality-driven writing | Stand out from wire-service rewrites |
| **AI-generated visuals** | Consistent, original, honest | No stock photo fatigue, transparent about AI |
| **Independent** | Not affiliated with any org | Neutral, opinionated coverage |
| **Privacy-first** | Matomo only, no tracking | Respects users |

---

## Tech Stack

| Component | Technology | Notes |
|-----------|------------|-------|
| Backend | Python + FastAPI | Async, fast |
| Database | PostgreSQL (Docker) | JSONB for multilingual |
| Website | Static HTML + nginx | WCAG AAA, fast |
| Automation | n8n | Article generation workflows |
| Analytics | Self-hosted Matomo | Privacy-friendly |
| Mobile | Expo (React Native) | Cross-platform |
| Push | Firebase Cloud Messaging | Free, cross-platform |
| Social | Late.dev + Instagram API | Hybrid posting + engagement |
| AI Images | TBD | Key visual + secondary image generation |

---

## Time Horizon

### Phase 1b: Relaunch (Feb-Mar 2026)

- Rebrand from Neve26 to Bronze
- Reduce languages to EN-GB, FR, DE
- Establish new editorial voice
- Set up AI image generation pipeline
- Expand to general sports coverage

### Phase 2: Growth (Apr 2026+)

- Build audience through consistent voice + visuals
- Evaluate: engagement, app revenue, content quality
- Expand sport coverage based on what resonates

---

## Domains

| Domain | Purpose | Status |
|--------|---------|--------|
| bronze.news | Main website | To acquire |
| bronzenews.com | Redirect to bronze.news | Available ($9) |
| api.bronze.news | REST API | Subdomain |
| n8n.bronze.news | Workflow automation | Subdomain |
| matomo.bronze.news | Analytics | Subdomain |

> bronze.com is not available ($750K). bronze.news is the primary domain.
> bronzenews.com redirects to bronze.news — catches the people who type .com by reflex.
> Neve26.com will redirect to bronze.news once established.

---

## Brand Identity

- **Name**: Bronze
- **Domain**: bronze.news
- **Tagline**: "Not everything has to be gold."
- **Philosophy**: Celebrating sport, sportsmanship, and the humans who show up — not just the winners
- **Languages**: 3 (EN-GB, FR, DE)
- **Design**: Clean, accessible, visually bold, personality-forward
- **Voice**: Smart-funny, warm, celebratory
- **Inspiration**: Beckett — "Fail again. Fail better."

### Why Bronze

- The word works in EN, FR, and DE — same spelling, universally understood
- Bronze medalists are scientifically proven to be happier than silver medalists
- It celebrates effort and presence, not just victory
- Short, one word, strong on a logo and app icon
- No existing sports news competitor uses the name
- The name carries meaning without needing explanation

### Future Domains

| Domain | Purpose | Status |
|--------|---------|--------|
| bronze.news | Primary website | To acquire |
| bronze.sports | Future primary (when .sports TLD launches) | Monitor |
| bronzenot.gold | Campaign/merch URL | To acquire if .gold available |

---

## Legacy: Neve26

The original Neve26 project (Jan 2026) focused on winter sports coverage for the 2026 season. 78 articles were published covering athlete profiles, venue guides, sport explainers, and historical pieces across 11 languages. The core infrastructure and lessons learned carry forward into the new platform.
