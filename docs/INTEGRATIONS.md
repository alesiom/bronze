# External Integrations Reference

API examples and configuration for third-party services.

---

## Late.dev (Social Media Posting)

**Service:** https://getlate.dev
**Plan:** Accelerate ($33/mo annual = $396/yr)
**Platforms:** X, Instagram, TikTok, LinkedIn, Threads, Facebook, Pinterest, YouTube, Bluesky, Mastodon, Telegram, Discord

### Account IDs

| Platform | Account ID | Handle |
|----------|------------|--------|
| Profile | `6961bcd2da641c56044760a5` | Default Profile |
| X | `6961bcdc4207e06f4ca84a79` | Rename pending (was @neve2026) |
| Instagram | `6961bd064207e06f4ca84a7a` | Rename pending (was @neve.2026) |

### API Reference

**Base URL:** `https://getlate.dev/api/v1`
**Auth:** Header `X-API-Key: {key}`
**n8n Credential:** `Late API` (Header Auth)

### Post to X Only

```json
POST /posts
{
  "content": "Your post text here",
  "platforms": [
    {
      "platform": "twitter",
      "accountId": "6961bcdc4207e06f4ca84a79"
    }
  ],
  "publishNow": true
}
```

### Post to X + Instagram (with image)

```json
POST /posts
{
  "content": "Your post text here",
  "platforms": [
    {
      "platform": "twitter",
      "accountId": "6961bcdc4207e06f4ca84a79"
    },
    {
      "platform": "instagram",
      "accountId": "6961bd064207e06f4ca84a7a",
      "mediaItems": [
        {
          "url": "https://bronze.news/images/social/post-image.jpg"
        }
      ]
    }
  ],
  "publishNow": true
}
```

**Note:** Instagram requires `mediaItems` - text-only posts fail silently.

### Schedule a Post

```json
POST /posts
{
  "content": "Scheduled post text",
  "platforms": [
    {
      "platform": "twitter",
      "accountId": "6961bcdc4207e06f4ca84a79"
    }
  ],
  "scheduledAt": "2026-01-15T14:00:00Z"
}
```

---

## Instagram Graph API (Engagement)

**Purpose:** Read/reply to comments (Late.dev doesn't support this)
**Cost:** Free
**Requirements:**
- Business/Creator Instagram account
- Connected Facebook Page
- Facebook App with `instagram_basic`, `instagram_manage_comments` permissions
- App Review approval

### Token Refresh

Access tokens expire after 60 days. Automate refresh in n8n:

```
GET https://graph.instagram.com/refresh_access_token
  ?grant_type=ig_refresh_token
  &access_token={current_token}
```

---

## Firebase Cloud Messaging (Push Notifications)

**Purpose:** Push notifications for mobile app
**Cost:** Free

### Configuration

- **Project:** neve26-app (rename to bronze pending)
- **Server Key:** In `config/firebase-admin.json` (not in repo)
- **App Config:** `app/app.json` → `expo.android.googleServicesFile`

### Send Notification

```json
POST https://fcm.googleapis.com/fcm/send
Headers:
  Authorization: key={server_key}
  Content-Type: application/json

{
  "to": "{device_token}",
  "notification": {
    "title": "Event Starting Soon",
    "body": "Champions League semi-final starts in 2 hours"
  },
  "data": {
    "event_id": "123",
    "type": "reminder"
  }
}
```

---

## Matomo (Analytics)

**Instance:** https://matomo.bronze.news
**Site ID:** 1

### Tracking Code

Already embedded in website templates via `base.html.j2`.

### API Access

```
GET https://matomo.bronze.news/index.php
  ?module=API
  &method=VisitsSummary.get
  &idSite=1
  &period=day
  &date=today
  &format=JSON
  &token_auth={token}
```

---

## Claude API (Article Generation)

**Used in:** n8n workflows for article generation
**Model:** claude-sonnet-4-20250514

### n8n Integration

Use "HTTP Request" node with:
- **URL:** `https://api.anthropic.com/v1/messages`
- **Auth:** Header `x-api-key: {key}`
- **Header:** `anthropic-version: 2023-06-01`

---

## AI Image Generation

**Purpose:** Key visual + secondary image for every article
**Status:** Pipeline TBD

All article images are AI-generated with a clearly stylised aesthetic (not photorealistic). Images are labelled as AI-generated and always include descriptive alt text (WCAG AAA).

See `docs/PROJECT.md` → Visual Strategy for full principles.

---

## Social Media Embeds (in Articles)

### Instagram Post Embed

```html
<figure class="social-embed social-embed--instagram">
  <blockquote class="instagram-media"
    data-instgrm-permalink="https://www.instagram.com/p/POST_ID/"
    data-instgrm-version="14">
  </blockquote>
  <figcaption>Caption describing the post.</figcaption>
</figure>
```

Add script once per page (before `</body>`):
```html
<script async src="//www.instagram.com/embed.js"></script>
```

### X/Twitter Quote (text only)

```html
<blockquote class="athlete-quote">
  <p>"Quote text here."</p>
  <cite>— Athlete Name, <a href="https://twitter.com/handle/status/123">via X</a></cite>
</blockquote>
```

### X/Twitter Full Embed (visual)

```html
<figure class="social-embed social-embed--twitter">
  <blockquote class="twitter-tweet">
    <a href="https://twitter.com/handle/status/123"></a>
  </blockquote>
  <figcaption>Caption describing the tweet.</figcaption>
</figure>
```

Add script once per page:
```html
<script async src="https://platform.twitter.com/widgets.js"></script>
```
