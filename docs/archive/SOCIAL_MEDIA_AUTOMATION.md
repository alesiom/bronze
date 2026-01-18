# Social Media Automation Strategy

Automated detection and integration of athlete social media content into Neve26 articles.

---

## Vision

When an athlete wins a race (or finishes on the podium), automatically:

1. Detect their latest Instagram post
2. Check if it's related to the race
3. Use the post to enrich the article (embed + quote)
4. Build a database of athlete social handles over time

This creates "live" feeling articles with authentic athlete content, without manual searching.

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     POST-RACE CONTENT ENRICHMENT                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────┐                                                       │
│  │ Race Results │  FIS/IBU publishes official results                   │
│  │   Published  │                                                       │
│  └──────┬───────┘                                                       │
│         ↓                                                               │
│  ┌──────────────┐                                                       │
│  │   Extract    │  Get athletes: 1st, 2nd, 3rd place                   │
│  │    Podium    │  Include: name, country, time, points                │
│  └──────┬───────┘                                                       │
│         ↓                                                               │
│  ┌──────────────┐     ┌─────────────────┐                              │
│  │   Lookup     │────→│  athlete_social │  PostgreSQL                  │
│  │   Handle     │     │      table      │                              │
│  └──────┬───────┘     └─────────────────┘                              │
│         │                                                               │
│    ┌────┴────┐                                                          │
│    ↓         ↓                                                          │
│  Found    Not Found                                                     │
│    │         │                                                          │
│    │    ┌────┴─────────┐                                                │
│    │    │ Search for   │  Try: firstname_lastname, team tags           │
│    │    │ Instagram    │  Verify: blue checkmark, follower count       │
│    │    └──────┬───────┘                                                │
│    │           │                                                        │
│    │    ┌──────┴───────┐                                                │
│    │    │ Save new     │  Store handle for future use                  │
│    │    │ handle to DB │                                                │
│    │    └──────┬───────┘                                                │
│    │           │                                                        │
│    └─────┬─────┘                                                        │
│          ↓                                                              │
│  ┌──────────────┐                                                       │
│  │ Fetch Latest │  Instagram Graph API                                 │
│  │    Post      │  Get: image, caption, timestamp, post URL            │
│  └──────┬───────┘                                                       │
│         ↓                                                               │
│  ┌──────────────┐                                                       │
│  │  AI Analysis │  Claude API                                          │
│  │              │  - Is post about today's race?                       │
│  │              │  - Extract usable quote from caption                 │
│  │              │  - Confidence score (0-1)                            │
│  └──────┬───────┘                                                       │
│         │                                                               │
│    ┌────┴────┐                                                          │
│    ↓         ↓                                                          │
│ Relevant  Not Relevant                                                  │
│ (>0.7)    (<0.7)                                                        │
│    │         │                                                          │
│    │         └─→ Skip embed, use generic content                       │
│    ↓                                                                    │
│  ┌──────────────┐                                                       │
│  │   Generate   │  Include in article:                                 │
│  │   Article    │  - Instagram embed code                              │
│  │              │  - Quote from caption                                │
│  │              │  - Context caption                                   │
│  └──────┬───────┘                                                       │
│         ↓                                                               │
│  ┌──────────────┐                                                       │
│  │    Track     │  Log post usage to avoid duplicates                  │
│  │  Post Usage  │  Store in social_posts_used table                    │
│  └──────────────┘                                                       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Feasibility Matrix

| Feature | Feasible | Method | Notes |
|---------|----------|--------|-------|
| Detect athlete's last Instagram post | ✅ Yes | Instagram Graph API | Requires business_discovery permission |
| Extract caption/text | ✅ Yes | Instagram Graph API | Part of media endpoint |
| Check if post is race-related | ✅ Yes | Claude API | Analyze caption + timing |
| Generate embed code | ✅ Yes | Construct from post URL | Standard oEmbed format |
| Save new athlete handles | ✅ Yes | PostgreSQL | Simple insert |
| Auto-comment congratulations | ❌ No | N/A | Instagram API blocks commenting on others' posts |
| Auto-DM athletes | ❌ No | N/A | Instagram API restricts automated DMs |
| Fetch X/Twitter posts | ✅ Yes | X API v2 | Requires Elevated access ($100/mo) or free tier (limited) |

### Why Auto-Commenting Isn't Possible

Instagram's API intentionally prevents automated commenting on other users' posts to combat spam. The only commenting allowed via API is:
- Replying to comments on your own posts
- Replying to comments that mention your account

**Alternative**: Manual engagement workflow (see below)

---

## Technical Requirements

### 1. Instagram Graph API

```
Setup Requirements:
├─ Meta Business Account
│   └─ Create at: business.facebook.com
│
├─ Instagram Business or Creator Account
│   └─ @neve.2026 must be Business/Creator (not Personal)
│   └─ Connected to a Facebook Page
│
├─ Meta Developer App
│   └─ Create at: developers.facebook.com
│   └─ Add "Instagram Graph API" product
│
├─ Permissions Needed:
│   ├─ instagram_basic (your account info)
│   ├─ instagram_manage_comments (your posts only)
│   ├─ business_discovery (view other business accounts)
│   └─ pages_read_engagement (for Page connection)
│
└─ App Review
    └─ Required for business_discovery
    └─ Takes 1-2 weeks
    └─ Need to demonstrate use case
```

### 2. API Endpoints Used

```
# Get athlete's Instagram Business ID (one-time lookup)
GET /ig_user_id?fields=business_discovery.username({handle}){id,username,name,followers_count}

# Get athlete's recent media
GET /{ig_user_id}?fields=business_discovery.username({handle}){media.limit(5){id,caption,timestamp,permalink,media_type,media_url}}

# Response example:
{
  "business_discovery": {
    "media": {
      "data": [
        {
          "id": "17895695668004550",
          "caption": "4th win in Adelboden! 🏆 Thank you for the incredible support! #Chuenisbärgli",
          "timestamp": "2026-01-11T15:30:00+0000",
          "permalink": "https://www.instagram.com/p/ABC123/",
          "media_type": "IMAGE"
        }
      ]
    }
  }
}
```

### 3. Rate Limits

| Endpoint | Limit | Window |
|----------|-------|--------|
| business_discovery | 10 calls | per user per hour |
| General API | 200 calls | per user per hour |

**Strategy**: Cache athlete IDs, batch lookups, respect limits

---

## Database Schema

### athlete_social

Stores known athlete social media handles.

```sql
CREATE TABLE athlete_social (
    id SERIAL PRIMARY KEY,

    -- Athlete identification
    athlete_name VARCHAR(255) NOT NULL,
    athlete_slug VARCHAR(255) UNIQUE,  -- marco-odermatt
    country_code CHAR(3),               -- SUI, NOR, USA
    sport VARCHAR(50),                  -- alpine-skiing, biathlon

    -- Instagram
    instagram_handle VARCHAR(100),      -- marco_odermatt (without @)
    instagram_id VARCHAR(50),           -- Instagram Business ID (for API)
    instagram_verified BOOLEAN DEFAULT FALSE,
    instagram_followers INTEGER,

    -- X/Twitter
    twitter_handle VARCHAR(100),        -- MarcoOdermatt (without @)
    twitter_id VARCHAR(50),

    -- Metadata
    discovery_method VARCHAR(50),       -- manual, auto-search, federation
    verified_at TIMESTAMPTZ,            -- When we confirmed this is correct
    last_checked_at TIMESTAMPTZ,        -- Last time we fetched their posts

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common lookups
CREATE INDEX idx_athlete_social_slug ON athlete_social(athlete_slug);
CREATE INDEX idx_athlete_social_instagram ON athlete_social(instagram_handle);
CREATE INDEX idx_athlete_social_sport ON athlete_social(sport);
```

### social_posts_used

Tracks which posts we've already used to avoid duplicates.

```sql
CREATE TABLE social_posts_used (
    id SERIAL PRIMARY KEY,

    -- Link to athlete
    athlete_id INTEGER REFERENCES athlete_social(id),

    -- Post details
    platform VARCHAR(20) NOT NULL,      -- 'instagram' or 'twitter'
    post_id VARCHAR(100) NOT NULL,      -- Platform's post ID
    post_url TEXT NOT NULL,             -- Full URL for embed
    caption TEXT,                       -- Original caption text
    posted_at TIMESTAMPTZ,              -- When athlete posted

    -- Usage tracking
    used_in_article VARCHAR(255),       -- Article slug where used
    used_at TIMESTAMPTZ DEFAULT NOW(),

    -- AI analysis results
    relevance_score FLOAT,              -- 0-1, how relevant to event
    extracted_quote TEXT,               -- Quote extracted by AI
    event_slug VARCHAR(255),            -- Which event it relates to

    -- Prevent duplicates
    UNIQUE(platform, post_id),

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for checking if post already used
CREATE INDEX idx_social_posts_post_id ON social_posts_used(platform, post_id);
CREATE INDEX idx_social_posts_article ON social_posts_used(used_in_article);
```

### Example Data

```sql
-- Athlete entry
INSERT INTO athlete_social (
    athlete_name, athlete_slug, country_code, sport,
    instagram_handle, instagram_verified, instagram_followers,
    twitter_handle, discovery_method, verified_at
) VALUES (
    'Marco Odermatt', 'marco-odermatt', 'SUI', 'alpine-skiing',
    'marco_odermatt', true, 850000,
    'MarcoOdermatt', 'manual', NOW()
);

-- Post usage entry
INSERT INTO social_posts_used (
    athlete_id, platform, post_id, post_url, caption, posted_at,
    used_in_article, relevance_score, extracted_quote, event_slug
) VALUES (
    1, 'instagram', 'ABC123XYZ',
    'https://www.instagram.com/p/ABC123XYZ/',
    '4th win in Adelboden! 🏆 Thank you for the incredible support! #Chuenisbärgli',
    '2026-01-11 15:30:00+00',
    'adelboden-giant-slalom-results-2026',
    0.95,
    'Thank you for the incredible support!',
    'adelboden-gs-men-2026'
);
```

---

## n8n Workflow Design

### Workflow: Post-Race Social Enrichment

```
Trigger: Webhook (from race results scraper)
         OR Schedule (check every 30 min during race weekends)

┌─────────────────────────────────────────────────────────────┐
│ Node 1: Webhook Trigger                                     │
│ Receives: { event_slug, podium: [{name, country, place}] } │
└─────────────────────┬───────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 2: Loop Over Podium                                    │
│ For each athlete in podium (1st, 2nd, 3rd)                 │
└─────────────────────┬───────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 3: PostgreSQL - Lookup Handle                          │
│ SELECT * FROM athlete_social                                │
│ WHERE athlete_slug = {{ $json.athlete_slug }}              │
└─────────────────────┬───────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 4: IF - Handle Found?                                  │
│ Check if query returned results                             │
└──────────┬──────────────────────────────┬───────────────────┘
           ↓                              ↓
      [Found]                        [Not Found]
           ↓                              ↓
           │                 ┌────────────────────────────────┐
           │                 │ Node 5a: Search Instagram      │
           │                 │ Try common patterns:           │
           │                 │ - firstname_lastname           │
           │                 │ - firstnamelastname            │
           │                 │ - Search via federation tags   │
           │                 └─────────────┬──────────────────┘
           │                               ↓
           │                 ┌────────────────────────────────┐
           │                 │ Node 5b: Save New Handle       │
           │                 │ INSERT INTO athlete_social     │
           │                 └─────────────┬──────────────────┘
           │                               │
           └───────────────┬───────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 6: HTTP Request - Instagram Graph API                  │
│ GET business_discovery for athlete's recent posts          │
└─────────────────────┬───────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 7: Claude API - Analyze Post                           │
│ Prompt: "Is this post about [event]? Extract quote."       │
│ Returns: { relevant: true, score: 0.92, quote: "..." }     │
└─────────────────────┬───────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 8: IF - Relevance Score > 0.7?                        │
└──────────┬──────────────────────────────┬───────────────────┘
           ↓                              ↓
      [Relevant]                    [Not Relevant]
           ↓                              ↓
┌──────────────────────┐        ┌─────────────────────┐
│ Node 9a: Build       │        │ Node 9b: Skip       │
│ embed code + quote   │        │ No social content   │
└──────────┬───────────┘        └─────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 10: PostgreSQL - Track Post Usage                      │
│ INSERT INTO social_posts_used                               │
└─────────────────────┬───────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────────┐
│ Node 11: Output - Return Enrichment Data                    │
│ { embed_html, quote, caption_context, athlete_handle }     │
└─────────────────────────────────────────────────────────────┘
```

---

## AI Analysis Prompt

For Claude API to analyze if a post is relevant:

```
You are analyzing an Instagram post to determine if it's about a specific sports event.

Event Details:
- Event: {{ event_name }} (e.g., "Adelboden Giant Slalom")
- Date: {{ event_date }}
- Sport: {{ sport }}
- Athlete finished: {{ place }} place

Instagram Post:
- Posted at: {{ post_timestamp }}
- Caption: {{ caption }}

Tasks:
1. Determine if this post is about the event (not a sponsor post, old photo, etc.)
2. Extract a usable quote (1-2 sentences, clean up emojis if needed)
3. Suggest a caption for embedding in an article

Return JSON:
{
  "is_relevant": true/false,
  "confidence": 0.0-1.0,
  "reasoning": "Brief explanation",
  "extracted_quote": "Clean quote from caption",
  "suggested_caption": "Context for article embed"
}

Rules:
- Post must be within 24 hours of event to be relevant
- Sponsor-only posts (no race mention) are not relevant
- Training/throwback posts are not relevant
- If caption is in another language, translate the quote to English
```

---

## Manual Engagement Workflow

Since auto-commenting isn't possible, here's a manual workflow:

### Post-Race Engagement Checklist

```
After publishing article with athlete social content:

□ Open @neve.2026 Instagram
□ For each podium athlete:
  □ Go to their embedded post
  □ Like the post
  □ Leave genuine comment:
      "Congratulations on [result]! 🎿 Great performance at [venue]!"
  □ Follow if not already following
□ Share article link in @neve.2026 story
  □ Tag athletes: @marco_odermatt @athlete2 @athlete3
□ Post on X (@neve2026):
  □ Article link + congratulations
  □ Tag athletes' X handles
```

### Comment Templates

```
Giant Slalom Winner:
"Incredible skiing! 🏆 Congratulations on the victory at [Venue]!"

Podium Finish:
"Amazing race! 🎿 Congratulations on [2nd/3rd] place at [Venue]!"

Home Crowd Win:
"What a moment! 🇨🇭 [Venue] celebrates with you! Congratulations!"

Record/Milestone:
"History made! 🏆 [X consecutive wins / career victory #Y] - Congratulations!"
```

---

## Implementation Phases

### Phase 1: Database Setup (Day 1)
- [ ] Create `athlete_social` table
- [ ] Create `social_posts_used` table
- [ ] Seed initial data from `ATHLETE_SOCIAL_HANDLES.md`

### Phase 2: Instagram API Setup (Week 1)
- [ ] Create Meta Business Account (if not exists)
- [ ] Convert @neve.2026 to Business Account
- [ ] Create Meta Developer App
- [ ] Request `business_discovery` permission
- [ ] Submit for App Review

### Phase 3: Basic n8n Workflow (Week 2)
- [ ] Create workflow: manual trigger
- [ ] Implement handle lookup
- [ ] Implement Instagram API fetch
- [ ] Test with known athletes

### Phase 4: AI Analysis (Week 2-3)
- [ ] Create Claude prompt for post analysis
- [ ] Add relevance scoring
- [ ] Add quote extraction
- [ ] Test accuracy with sample posts

### Phase 5: Full Automation (Week 3-4)
- [ ] Connect to race results trigger
- [ ] Add new handle discovery
- [ ] Add post usage tracking
- [ ] Integrate with article generation workflow

### Phase 6: Monitoring & Iteration (Ongoing)
- [ ] Monitor API rate limits
- [ ] Track embed success rate
- [ ] Improve AI prompts based on results
- [ ] Expand athlete database

---

## API Cost Estimates

| Service | Cost | Usage |
|---------|------|-------|
| Instagram Graph API | Free | Up to 200 calls/hour |
| Claude API (Haiku) | ~$0.001/analysis | ~100 analyses/month = $0.10 |
| PostgreSQL | Included | Already running |
| n8n | Included | Self-hosted |

**Total additional cost**: ~$0.10/month (negligible)

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Instagram API approval denied | High | Prepare detailed use case, show editorial value |
| Rate limits exceeded | Medium | Cache aggressively, batch requests |
| Athlete changes handle | Low | Periodic verification, update DB |
| Post deleted after embed | Low | Graceful fallback in article CSS |
| Wrong post detected as relevant | Medium | High confidence threshold (0.7+), human review for edge cases |
| Athlete account is private | Medium | Skip private accounts, track in DB |

---

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Articles with social embeds | >50% | Count articles with embeds |
| Embed relevance accuracy | >90% | Manual review sample |
| New handles discovered/month | 5-10 | DB growth tracking |
| Time from race to enriched article | <2 hours | Timestamp tracking |
| Engagement on @neve.2026 | Growing | Instagram analytics |

---

## Related Documentation

- `docs/IMAGE_SOURCING.md` - General image and embed guidelines
- `docs/ATHLETE_SOCIAL_HANDLES.md` - Current known handles
- `website/CONTENT_AUTOMATION.md` - Article generation workflow
