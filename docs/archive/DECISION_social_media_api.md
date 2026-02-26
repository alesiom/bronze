# Social Media API Decision: Late.dev vs Native APIs

**Decision Required For:** T15 (blocks T16, T17, T18, T19)
**Prepared:** January 2026
**Status:** DECIDED

## Final Decision: Hybrid Approach

| Function | Solution | Cost |
|----------|----------|------|
| **Posting** (all platforms) | Late.dev Accelerate | $33/mo ($396/yr) |
| **Engagement** (Instagram) | Native Graph API | $0 |
| **Total** | | **$396/year** |

### Rationale
- Late.dev handles posting to 12 platforms with one API
- Native Instagram API adds comment reading/replying for free
- Avoids X Basic tier ($1,200/yr) since Late.dev includes X posting
- Future-proof: can expand to TikTok/LinkedIn/Threads without code changes
- No time for manual engagement, automation required

---

## Research (for reference)

---

## Bronze Social Media Requirements

From KNOWLEDGE.md:
- **Platforms:** Instagram (@bronzenews), X (@bronzenews)
- **Daily volume:** 2 feed posts + 5 stories + 1 reel = **8 posts/day**
- **Monthly volume:** ~240 posts/month
- **Integration:** n8n workflows for automation
- **Content types:** Images, stories, reels (video)

---

## Option A: Late.dev (Unified API)

### Pricing Tiers

| Plan | Monthly | Annual | Posts/mo | Profiles |
|------|---------|--------|----------|----------|
| Free | $0 | $0 | 10 | 2 |
| Build | $19 | $13/mo | 120 | 10 |
| **Accelerate** | $49 | **$33/mo** | Unlimited | 50 |
| Unlimited | $999 | $667/mo | Unlimited | Unlimited |

**For Bronze:** Accelerate plan at $33/mo (annual) = **$396/year**

### Supported Platforms
Twitter/X, Instagram, TikTok, LinkedIn, Facebook, YouTube, Threads, Reddit, Pinterest, Bluesky (12 total)

### Pros
- **Single API** for all platforms - one integration, done
- **n8n integration** already exists (official)
- **Handles rate limits** automatically - no manual throttling
- **Token refresh** managed by Late - no 60-day expiry issues
- **99.7% uptime SLA** with <50ms response times
- **Reels & Stories** supported
- **Future-proof:** Add TikTok/LinkedIn/Threads with zero code changes
- **No App Review** process required

### Cons
- **Cost:** $396/year (vs $0 for native)
- **Dependency:** Third-party service
- **No engagement features:** Can't read replies/comments via API (posting only)

### API Example
```bash
POST https://api.getlate.dev/posts
{
  "text": "Shiffrin wins in Adelboden! Full recap...",
  "mediaUrls": ["https://bronze.news/images/articles/shiffrin-win.jpg"],
  "profiles": ["instagram_xxx", "twitter_xxx"]
}
```

---

## Option B: Native Instagram Graph API

### Cost
**$0** (free)

### Requirements
1. Instagram Business or Creator account
2. Facebook Page linked to Instagram account
3. Facebook Developer App created
4. App Review submission and approval (days to weeks)
5. OAuth flow implementation
6. Token refresh workflow (every 60 days)

### Rate Limits
- 200 API calls per hour per account
- 25-50 posts per 24 hours (sufficient for Bronze)

### Pros
- **Free** - no ongoing cost
- **Full features** - can read comments, insights, engagement
- **Direct relationship** with Meta

### Cons
- **Complex setup:** Facebook Business Manager, App Review, OAuth flow
- **Token management:** Must refresh every 60 days or lose access
- **Instagram only:** Need separate X integration
- **Reels audio limitation:** No trending music via API (stripped/blocked)
- **Maintenance burden:** API changes, deprecations (Jan 2025 metrics deprecated)
- **No n8n native support:** Must build custom HTTP nodes

### Reels Limitation (Critical)
> "Scheduled Reels often lose their audio or fail to publish because copyright agreements for trending music do not extend to API-published content."

This means Bronze's daily reel would need **original audio only** - no trending sounds.

---

## Option C: Native X (Twitter) API

### Free Tier
- **17 tweets per 24 hours** (app-wide, not per user!)
- Read access: Basically none
- Only POST /2/tweets and GET /2/users/me

### Paid Tiers
| Plan | Cost | Posts/mo |
|------|------|----------|
| Free | $0 | ~500 |
| Basic | $100/mo | 50,000 |
| Pro | $5,000/mo | Unlimited |

### Reality Check
The free tier's **17 tweets/day app-wide** limit is unusable for any real automation. You'd hit the limit in 2 days of normal posting.

**For X posting, you need either:**
- Basic plan at $100/mo ($1,200/year), OR
- Late.dev which includes X

---

## Cost Comparison

| Approach | Year 1 Cost | Maintenance | Platforms |
|----------|-------------|-------------|-----------|
| Late.dev Accelerate | $396 | Low | 12 |
| Native Instagram + X Basic | $1,200 | High | 2 |
| Native Instagram + X Free | $0 | Very High | 1.5* |

*X free tier is barely functional

---

## Recommendation: Late.dev Accelerate

### Why?

1. **X's free tier is unusable** (17 tweets/day app-wide)
   - To post to X meaningfully, you need $100/mo Basic tier
   - Late.dev Accelerate ($33/mo) includes X + 11 other platforms

2. **Native Instagram complexity not worth $0 savings**
   - App Review process (unknown timeline)
   - Token refresh workflow maintenance
   - Reels audio stripped (major limitation)
   - No n8n native integration

3. **n8n integration is built-in**
   - Official Late + n8n connector exists
   - Reduces development time significantly

4. **Future flexibility**
   - Add TikTok, LinkedIn, Threads with zero code changes
   - Just connect profiles in Late dashboard

5. **Math**
   - Late.dev: $396/year for unlimited posts to all platforms
   - Native X alone: $1,200/year for just Twitter
   - **Late.dev is 3x cheaper** than X Basic alone

### Action Items if Approved

1. Sign up at https://getlate.dev (free tier to test)
2. Connect @bronzenews (Instagram) via OAuth
3. Connect @bronzenews (X) via OAuth
4. Get API key
5. Add credentials to n8n
6. Proceed with T16 (posting workflow)

---

## Alternative: Hybrid Approach

If engagement features matter later:

1. **Publishing:** Late.dev (all platforms)
2. **Reading/Engagement:** Native Instagram API (add later if needed)

This lets you start fast with Late.dev and add native read access only if you actually need to respond to comments programmatically.

---

## Sources

- [Late.dev Pricing](https://getlate.dev/pricing)
- [Late.dev Social Media API](https://getlate.dev)
- [Twitter/X API Pricing Breakdown](https://getlate.dev/blog/twitter-api-pricing)
- [Instagram Graph API Guide 2025](https://elfsight.com/blog/instagram-graph-api-complete-developer-guide-for-2025/)
- [Instagram API Guide 2026](https://tagembed.com/blog/instagram-api/)
- [Instagram Reels API Guide](https://www.getphyllo.com/post/a-complete-guide-to-the-instagram-reels-api)
- [X API Rate Limits](https://docs.x.com/x-api/fundamentals/rate-limits)
