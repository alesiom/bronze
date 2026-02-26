# FIS Scraper Research - TICKET-004

**Date**: January 8, 2026
**Status**: Complete
**Target**: Adelboden World Cup (Jan 10-11, 2026)

---

## Executive Summary

FIS uses **Next.js static site generation (SSG)** for results pages. There is **no public API** - the `/api/` path is blocked in robots.txt. However, results pages are well-structured HTML tables that are straightforward to scrape.

**Recommended approach**: HTTP scraping of results HTML pages with BeautifulSoup/lxml.

---

## URL Patterns

### Calendar/Results List
```
https://www.fis-ski.com/DB/alpine-skiing/calendar-results.html
  ?sectorcode=AL           # AL=Alpine, CC=Cross-Country, JP=Ski Jumping
  &seasoncode=2026         # Season year
  &categorycode=WC         # WC=World Cup, EC=Europa Cup, FIS=FIS race
  &disciplinecode=GS       # GS, SL, DH, SG, AC (combined)
  &gendercode=M            # M=Men, W=Women
```

### Event Details (multi-race weekend)
```
https://www.fis-ski.com/DB/general/event-details.html
  ?sectorcode=AL
  &eventid=58544           # Unique event ID
  &seasoncode=2026
```

### Individual Race Results
```
https://www.fis-ski.com/DB/general/results.html
  ?sectorcode=AL
  &raceid=127374           # Unique race ID (different from eventid!)
```

### Athlete Biography
```
https://www.fis-ski.com/DB/general/athlete-biography.html
  ?sectorcode=AL
  &competitorid=194364     # Unique athlete ID
```

---

## Adelboden 2026 Specific URLs

| Race | Date | URL |
|------|------|-----|
| Men's GS | Jan 10, 2026 | `results.html?sectorcode=AL&raceid=127374` |
| Men's SL | Jan 11, 2026 | `results.html?sectorcode=AL&raceid=127375` (estimated) |

**Event page**: `event-details.html?sectorcode=AL&eventid=58544&seasoncode=2026`

---

## HTML Structure

### Results Table Columns

| Column | Content | Example |
|--------|---------|---------|
| 1 | Rank | 1, 2, 3... or DNF, DNS, DSQ |
| 2 | Bib Number | 1-30 for top seeds |
| 3 | FIS Code | 6-digit athlete ID |
| 4 | Athlete Name | Linked to biography |
| 5 | Birth Year | 1997 |
| 6 | Nation | 3-letter code (SUI, AUT, ITA) |
| 7 | Run 1 Time | 1:15.49 |
| 8 | Run 2 Time | 1:12.06 |
| 9 | Total Time | 2:27.55 |
| 10 | Difference | +0.20, +1.14 |
| 11 | FIS Points | 0.00 for winner |
| 12 | Cup Points | 100, 80, 60... |

### Sample Result Row (2025 Adelboden)
```
| 1 | Marco Odermatt | SUI | 1:15.49 | 1:12.06 | 2:27.55 | — |
| 2 | Loic Meillard | SUI | 1:15.15 | 1:12.60 | 2:27.75 | +0.20 |
| 3 | Luca De Aliprandini | ITA | 1:16.55 | 1:11.69 | 2:28.24 | +0.69 |
```

### Embedded JSON Metadata

Every results page contains `window.fisProperties`:

```javascript
window.fisProperties = {
  "pageType": "results",
  "seasonCode": 2026,
  "disciplineCode": "AL",
  "competitionCodex": 939,
  "eventId": 55594,
  "genderCode": "M"
}
```

This can be extracted for additional metadata without parsing HTML.

---

## Rate Limits & robots.txt

### robots.txt Summary
```
User-agent: *
Disallow: /api/
Disallow: /_next/
Disallow: /search
Disallow: /portal/
Allow: /
Sitemap: https://www.fis-ski.com/sitemap.xml
```

### Key Points
- **No crawl delay specified** - no explicit rate limit
- `/api/` is blocked - confirms no public API
- Results pages (`/DB/`) are allowed
- Sitemap available for discovering pages

### Recommended Rate Limits (self-imposed)
- **Normal**: 1 request per 2 seconds
- **Race day**: 1 request per 30 seconds (during live timing)
- **Burst**: Max 5 requests, then 10-second pause

---

## Live Timing

**URL**: `https://live.fis-ski.com/lv-al[XXXX].htm`

**Status**: Uses **legacy Flash player** - not directly scrapeable.

**Alternative**: Poll the regular results page every 30-60 seconds during races. Results are updated in near-real-time on the main site once runs complete.

---

## Scraping Strategy for n8n

### Workflow: Post-Race Results

1. **Trigger**: Cron every 5 minutes on race days (10:00-15:00 CET)
2. **HTTP Request**: GET results page URL
3. **Check**: Compare with cached version (hash or timestamp)
4. **Parse**: Extract results table using regex or HTML parser
5. **Transform**: Convert to article-ready format
6. **Generate**: Claude API creates article from results
7. **Validate**: Check against legal blocklist
8. **Store**: POST to Bronze API

### n8n Node Recommendations

| Step | n8n Node | Config |
|------|----------|--------|
| Fetch | HTTP Request | GET, no auth, User-Agent header |
| Parse | HTML Extract | CSS selector for results table |
| Compare | Code | JavaScript hash comparison |
| Generate | HTTP Request | Claude API call |
| Store | HTTP Request | POST to api.bronze.news |

---

## Data Extraction Code (Python Reference)

```python
import httpx
from bs4 import BeautifulSoup
import json
import re

def fetch_race_results(race_id: str) -> dict:
    """Fetch and parse FIS race results."""
    url = f"https://www.fis-ski.com/DB/general/results.html?sectorcode=AL&raceid={race_id}"

    headers = {
        "User-Agent": "Bronze-Bot/1.0 (news aggregator; contact@bronze.news)"
    }

    response = httpx.get(url, headers=headers, timeout=30)
    response.raise_for_status()

    soup = BeautifulSoup(response.text, "lxml")

    # Extract embedded metadata
    script_tags = soup.find_all("script")
    metadata = {}
    for script in script_tags:
        if "window.fisProperties" in str(script):
            match = re.search(r'window\.fisProperties\s*=\s*({.*?});', str(script), re.DOTALL)
            if match:
                metadata = json.loads(match.group(1))

    # Extract results table
    results = []
    table = soup.find("table", class_="g-lg-14")  # Adjust selector as needed
    if table:
        rows = table.find_all("tr")[1:]  # Skip header
        for row in rows:
            cells = row.find_all("td")
            if len(cells) >= 9:
                results.append({
                    "rank": cells[0].text.strip(),
                    "bib": cells[1].text.strip(),
                    "fis_code": cells[2].text.strip(),
                    "name": cells[3].text.strip(),
                    "year": cells[4].text.strip(),
                    "nation": cells[5].text.strip(),
                    "run1": cells[6].text.strip(),
                    "run2": cells[7].text.strip(),
                    "total": cells[8].text.strip(),
                    "diff": cells[9].text.strip() if len(cells) > 9 else ""
                })

    return {
        "metadata": metadata,
        "results": results
    }
```

---

## Key Athletes to Track (World Cup Leaders)

| Athlete | Nation | Discipline | FIS Code |
|---------|--------|------------|----------|
| Marco Odermatt | SUI | GS, SG, DH | 194364 |
| Loic Meillard | SUI | GS, SL | 194364 |
| Henrik Kristoffersen | NOR | GS, SL | 422469 |
| Manuel Feller | AUT | SL | 54320 |
| Clement Noel | FRA | SL | 6293775 |
| Mikaela Shiffrin | USA | SL, GS | 539909 |
| Lara Gut-Behrami | SUI | GS, SG, DH | 516138 |
| Federica Brignone | ITA | GS, SG | 297601 |

---

## Risk Assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| IP blocking | Medium | Use residential proxy, respect rate limits |
| HTML structure change | Low | Monitor for changes, use flexible selectors |
| Legal (data usage) | Low | Public data, factual reporting only |
| Race cancellation | Medium | Check event status before generating articles |

---

## Next Steps

1. **TICKET-005**: Build n8n workflow using this research
2. **Test scraper**: Run against historical race (2025 Adelboden)
3. **Cache layer**: Store raw HTML to avoid re-fetching
4. **Monitoring**: Alert if scraper fails or structure changes

---

## Sources

- [FIS Alpine Calendar](https://www.fis-ski.com/DB/alpine-skiing/calendar-results.html)
- [Adelboden 2026 Event](https://www.fis-ski.com/DB/general/event-details.html?sectorcode=AL&eventid=58544&seasoncode=2026)
- [2025 Adelboden Results (reference)](https://www.fis-ski.com/DB/general/results.html?sectorcode=AL&raceid=122802)
- [FIS robots.txt](https://www.fis-ski.com/robots.txt)
