# Neve26 Project Vision

**Neve26** is an **ad-free, fully accessible (WCAG AAA) independent sports news platform** with a companion mobile app for schedules and notifications.

**This is a time-boxed project** — Phase 1 covers the Winter 2026 season (January-April 2026).

---

## Product Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                         NEVE26 ECOSYSTEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  WEBSITE (neve26.com) - FREE                                   │
│  ├─ All news articles                                          │
│  ├─ Athlete profiles                                           │
│  ├─ Sport explainers                                           │
│  ├─ 11 languages                                               │
│  ├─ WCAG AAA accessible                                        │
│  ├─ Ad-free                                                    │
│  └─ NO schedule, NO notifications, NO favorites                │
│                                                                 │
│  APP (iOS + Android) - PAID $2.99                              │
│  ├─ Event schedule/calendar                                    │
│  ├─ Push notifications                                         │
│  ├─ Favorites (athletes, events, sports)                       │
│  ├─ Offline mode                                               │
│  ├─ News (same content as website)                             │
│  ├─ 11 languages                                               │
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
- **Premium positioning**: Differentiate on accessibility + ad-free

---

## Target Users

| Segment | Description | Why They Pay |
|---------|-------------|--------------|
| Event attendees | Tourists/fans physically at events | Need schedule + alerts |
| Accessibility community | Blind/low-vision sports fans | Finally a platform that works |
| Casual fans | Follow sports casually | Want reminders for favorite events |

---

## Content Strategy

### What We Cover

- **FIS World Cup**: Alpine skiing, cross-country, ski jumping, Nordic combined
- **IBU Biathlon World Cup**: All races and standings
- **Other winter events**: X Games, freestyle, snowboard
- **Athlete profiles**: Career stats, World Cup victories, bios

### Content Categories

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

### Current Content Inventory (2026-01-12)

| Category | Count | Status |
|----------|-------|--------|
| Athlete Profiles | 37 | 93% complete |
| Sport Explainers | 11 | 92% complete |
| Venue Guides | 15 | 100% complete |
| Historical | 15 | 100% complete |
| **Total** | **78** | **95%** |

See `docs/content-plan.md` for full inventory.

---

## Differentiators

| Differentiator | What It Means | Competitive Advantage |
|----------------|---------------|----------------------|
| **WCAG AAA** | Highest accessibility standard | Only sports platform at this level |
| **Ad-free** | No ads anywhere, ever | Clean experience |
| **Independent** | Not affiliated with any org | Neutral coverage |
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

---

## Time Horizon

### Phase 1: Winter 2026 (Jan - Apr 2026)

- Cover FIS/IBU World Cup season
- Validate business model
- Learn what works

### Phase 2: Decision Point (May 2026)

- Evaluate: Revenue? User satisfaction?
- If yes: Expand to summer sports
- If no: Post-mortem and close gracefully

---

## Domains

| Domain | Purpose |
|--------|---------|
| neve26.com | Main website |
| neve26.app | App Store redirect |
| api.neve26.com | REST API |
| n8n.neve26.com | Workflow automation |
| matomo.neve26.com | Analytics |

---

## Brand Identity

- **Name**: Neve26 (neve = snow in Italian)
- **Tagline**: "Independent Winter Sports News"
- **Languages**: 11 (EN, DE, FR, IT, ES, PT, NL, AR, JA, ZH, KO)
- **Design**: Clean, accessible, no visual clutter
