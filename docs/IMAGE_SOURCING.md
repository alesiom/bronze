# Image Sourcing Guide for Bronze Articles

## Overview

This document outlines where to find free, legally-safe images for Bronze articles, and how to properly attribute them.

---

## Recommended Sources (Priority Order)

### Tier 1: Public Domain (No Attribution Required)

These sources provide images that are completely free to use commercially with no attribution needed.

| Source | URL | Best For | Notes |
|--------|-----|----------|-------|
| **LOC Skiing Archive** | [loc.getarchive.net/topics/skiing](https://loc.getarchive.net/topics/skiing) | Historical skiing photos | 495+ images, Library of Congress |
| **PICRYL Ski** | [picryl.com/topics/ski](https://picryl.com/topics/ski) | Historical Nordic skiing | 4,000+ images, includes 1930s Holmenkollen |
| **PICRYL Athletes** | [picryl.com/topics/athletes](https://picryl.com/topics/athletes) | General athlete photos | 93,000+ images |
| **Pixabay** | [pixabay.com](https://pixabay.com) | Modern action shots | CC0 license, search "biathlon", "skiing" |
| **Unsplash** | [unsplash.com](https://unsplash.com) | High-quality modern photos | CC0-like license |
| **Pikist** | [pikist.com](https://pikist.com) | Cross-country skiing | Royalty-free |

### Tier 2: Creative Commons (Attribution Recommended)

| Source | URL | License | Notes |
|--------|-----|---------|-------|
| **Wikimedia Commons** | [commons.wikimedia.org](https://commons.wikimedia.org) | Various CC | Check each image license |
| **Flickr CC** | [flickr.com/search/?license=4,5,6](https://flickr.com/search/) | CC-BY, CC-BY-SA | Filter by license |

### Tier 3: Historical Archives

| Source | URL | Best For |
|--------|-----|----------|
| **Austrian National Library** | Via Unsplash | Vintage European skiing |
| **Norwegian Digital Museum** | [digitaltmuseum.no](https://digitaltmuseum.no) | Nordic skiing history |
| **Swiss Federal Archives** | [bar.admin.ch](https://www.bar.admin.ch) | Swiss alpine history |

---

## Image Types by Article Category

### Alpine Skiing Articles
- **Historical context**: LOC Archive, PICRYL (vintage races, equipment)
- **Venue shots**: Wikimedia Commons (course maps, finish areas)
- **Action shots**: Pixabay, Unsplash (generic skiing, NOT specific athletes)
- **Atmosphere**: Unsplash (Swiss Alps, snow, crowds)

### Biathlon Articles
- **Action shots**: Pixabay (search "biathlon")
- **Venue photos**: Wikimedia Commons
- **Historical**: PICRYL (search "biathlon", "cross-country skiing")

### Athlete Profiles
- **CAUTION**: Modern athlete photos are usually copyrighted by agencies (Getty, AP)
- **Safe options**:
  - Wikimedia Commons (check license carefully)
  - Official federation press kits (if available)
  - Generic action shots without identifying features

---

## Search Tips

### Effective Search Queries

```
Pixabay/Unsplash:
- "giant slalom skiing"
- "alpine skiing race"
- "biathlon winter"
- "ski jumping holmenkollen"
- "cross country skiing competition"

PICRYL/LOC:
- "skiing" + country name
- "winter sports" + decade
- "ski jump" + location
- Specific venue names: "Holmenkollen", "St. Moritz"
```

### What to Avoid
- Named athletes (copyright issues)
- Recent competition photos (likely agency-owned)
- Images with visible Olympic rings or branding
- Photos from official Olympic/Paralympic events

---

## Image Implementation

### HTML Structure (WCAG AAA Compliant)

```html
<!-- Standard article image -->
<figure class="article-image">
  <img src="/images/articles/[slug]/[image-name].jpg"
       alt="[Descriptive alt text for screen readers]"
       width="800"
       height="450"
       loading="lazy">
  <figcaption>
    [Caption describing the image].
    <span class="image-credit">Photo: [Source/Public Domain]</span>
  </figcaption>
</figure>

<!-- Full-width hero image -->
<figure class="article-image article-image--hero">
  <img src="..." alt="..." width="1200" height="600" loading="lazy">
  <figcaption>...</figcaption>
</figure>

<!-- Inline/float image -->
<figure class="article-image article-image--inline">
  <img src="..." alt="..." width="400" height="300" loading="lazy">
  <figcaption>...</figcaption>
</figure>
```

### Alt Text Guidelines (WCAG AAA)

**DO:**
- Describe the action and context: "Skier in blue racing suit carving through giant slalom gate on steep slope"
- Include relevant details: "Historical black and white photo of ski jumpers at Holmenkollen, Oslo, 1934"
- Be concise but complete: aim for 125 characters or less

**DON'T:**
- Start with "Image of..." or "Photo of..."
- Use vague descriptions: "skiing photo"
- Include copyright/source info in alt text (use figcaption)

### Image Optimization

Before uploading images:

1. **Resize**: Max 1200px wide for hero, 800px for standard
2. **Compress**: Use TinyPNG or similar (target <200KB)
3. **Format**: WebP preferred, JPEG fallback
4. **Naming**: `venue-action-year.jpg` (e.g., `adelboden-finish-area-2020.jpg`)

---

## File Organization

```
website/
  images/
    articles/
      [article-slug]/
        hero.jpg
        image-1.jpg
        image-2.jpg
    shared/
      venues/
        adelboden-chuenisbargli.jpg
        wengen-lauberhorn.jpg
      sports/
        alpine-skiing-generic.jpg
        biathlon-generic.jpg
```

---

## Attribution Templates

### Public Domain (no attribution required, but nice to include)
```html
<span class="image-credit">Public Domain</span>
<span class="image-credit">Source: Library of Congress</span>
```

### Creative Commons
```html
<span class="image-credit">Photo: [Author Name] / CC BY 4.0</span>
<span class="image-credit">Photo: [Author Name] via Wikimedia Commons / CC BY-SA 3.0</span>
```

### Pixabay/Unsplash (no attribution required)
```html
<span class="image-credit">Photo: Unsplash</span>
<span class="image-credit">Photo: Pixabay</span>
```

---

## Workflow Checklist

When adding images to an article:

- [ ] Search Tier 1 sources first (public domain)
- [ ] Verify license allows commercial use
- [ ] Download highest quality available
- [ ] Resize and compress for web
- [ ] Write descriptive alt text (WCAG AAA)
- [ ] Add proper attribution in figcaption
- [ ] Test image loads correctly
- [ ] Verify responsive display on mobile

---

## Legal Reminders

1. **NEVER use images containing Olympic branding** (rings, torch, "Olympic" text)
2. **Avoid photos from Olympic/Paralympic events** - these are usually rights-protected
3. **When in doubt, don't use it** - stick to clearly public domain sources
4. **Keep records** - note the source URL for each image used

---

## Quick Reference Card

| Need | Source | Search Term |
|------|--------|-------------|
| Historical skiing | PICRYL | "ski" + decade |
| Modern action | Pixabay | "alpine skiing race" |
| Atmosphere/scenery | Unsplash | "swiss alps snow" |
| Biathlon | Pixabay | "biathlon" |
| Venue exteriors | Wikimedia | venue name |
| Generic crowds | Unsplash | "ski resort crowd" |

---

## Social Media Embeds (Recommended for Live Content)

Social media embeds are **legal** and provide authentic, visual content directly from athletes.

### Priority

1. **Instagram** - Visual priority (celebration photos, podium shots, training)
2. **X/Twitter** - Quote priority (reactions, thanking fans, short statements)

### What's Legal

| Method | Legal? | Notes |
|--------|--------|-------|
| **Embed** (official code) | Yes | Uses platform's API, content hosted by them |
| **Quote in text** (with link) | Yes | Standard journalism practice |
| **Download & re-host** | No | Copyright infringement |
| **Screenshot** | No | Still copying |

### Instagram Embed

```html
<figure class="social-embed social-embed--instagram">
  <blockquote class="instagram-media"
    data-instgrm-permalink="https://www.instagram.com/p/POST_ID/"
    data-instgrm-version="14">
  </blockquote>
  <figcaption>Odermatt celebrates his fourth Adelboden victory.</figcaption>
</figure>

<!-- Add once before </body> -->
<script async src="//www.instagram.com/embed.js"></script>
```

**How to get embed code:**
1. Open post on Instagram (web browser)
2. Click "..." menu
3. Select "Embed"
4. Copy code

### X/Twitter Quote (in article text)

```html
<blockquote class="athlete-quote">
  <p>"This one means more than ever. The crowd, the atmosphere - Adelboden is magic."</p>
  <cite>— Marco Odermatt, <a href="https://twitter.com/MarcoOdermatt/status/123">via X</a></cite>
</blockquote>
```

### X/Twitter Full Embed

```html
<figure class="social-embed social-embed--twitter">
  <blockquote class="twitter-tweet">
    <a href="https://twitter.com/MarcoOdermatt/status/123"></a>
  </blockquote>
  <figcaption>Odermatt's post-race reaction.</figcaption>
</figure>

<!-- Add once before </body> -->
<script async src="https://platform.twitter.com/widgets.js"></script>
```

### Embed Caveats

| Risk | Mitigation |
|------|------------|
| Post deleted | Content disappears from your article |
| Account goes private | Embed stops working |
| Platform outage | Temporary blank space |
| Slow loading | Use `loading="lazy"` where possible |

### Post-Race Content Workflow

```
Race Ends
    ↓
Check athlete's Instagram (posts within 1-2 hours typically)
    ↓
Good visual? → Embed Instagram post
    ↓
Check X/Twitter for reaction quotes
    ↓
Good quote? → Add as blockquote with link
    ↓
Publish article with fresh social content
```

### Athlete Handles Reference

See: `docs/ATHLETE_SOCIAL_HANDLES.md` for full list of athlete Instagram and X accounts.

---

## Copyright Duration Reference

When do photos become public domain?

| Situation | When Free |
|-----------|-----------|
| **USA pre-1923** | Now (all free) |
| **USA 1923-1977** | 95 years from publication |
| **USA/EU post-1978** | Life + 70 years |
| **No © notice (USA pre-1989)** | Immediate public domain |

**20-year-old photo**: Still copyrighted (photographer would need to have died 70+ years ago)
