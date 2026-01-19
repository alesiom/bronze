#!/usr/bin/env python3
"""
Generate complete winter sports World Cup calendar for 2025-26 season.
Includes events from January 19, 2026 through end of winter season.

Federations covered:
- FIS: Alpine, Cross-Country, Ski Jumping, Nordic Combined, Freestyle, Snowboard
- IBU: Biathlon
- IBSF: Bobsled, Skeleton
- FIL: Luge
- ISU: Speed Skating, Short Track, Figure Skating
- IOC: Winter Olympics (Milano Cortina 2026)
"""

import json
from datetime import datetime, timedelta
from pathlib import Path

# Output paths
SCRIPT_DIR = Path(__file__).parent
OUTPUT_DIR = SCRIPT_DIR.parent / "data"
OUTPUT_FILE = OUTPUT_DIR / "world_cup_events.json"


def generate_event_id(federation: str, sport_code: str, counter: int) -> str:
    """Generate unique event ID."""
    return f"{federation}-{sport_code}-{counter:04d}"


# ============================================================================
# FIS ALPINE SKIING WORLD CUP
# ============================================================================
FIS_ALPINE_EVENTS = [
    # Wengen (M) - Jan 17-19 (continuing from Jan 13)
    {"date": "2026-01-19", "venue": "Lauberhorn", "city": "Wengen", "country": "SUI", "event": "Men's Slalom", "medal": True},

    # Cortina (W) - Jan 18-19
    {"date": "2026-01-19", "venue": "Olympia delle Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Super-G", "medal": True},

    # Kitzbühel (M) - Jan 24-26
    {"date": "2026-01-24", "venue": "Streif", "city": "Kitzbühel", "country": "AUT", "event": "Men's Downhill", "medal": True},
    {"date": "2026-01-25", "venue": "Streif", "city": "Kitzbühel", "country": "AUT", "event": "Men's Downhill", "medal": True},
    {"date": "2026-01-26", "venue": "Streif", "city": "Kitzbühel", "country": "AUT", "event": "Men's Super-G", "medal": True},

    # Kronplatz (W) - Jan 21
    {"date": "2026-01-21", "venue": "Erta", "city": "Kronplatz", "country": "ITA", "event": "Women's Giant Slalom", "medal": True},

    # Garmisch-Partenkirchen (W) - Jan 25-26
    {"date": "2026-01-25", "venue": "Kandahar", "city": "Garmisch-Partenkirchen", "country": "GER", "event": "Women's Downhill", "medal": True},
    {"date": "2026-01-26", "venue": "Kandahar", "city": "Garmisch-Partenkirchen", "country": "GER", "event": "Women's Super-G", "medal": True},

    # Schladming (M) - Jan 28
    {"date": "2026-01-28", "venue": "Planai", "city": "Schladming", "country": "AUT", "event": "Men's Night Slalom", "medal": True},

    # Courchevel (W) - Jan 30 - Feb 1 (before Olympics)
    {"date": "2026-01-30", "venue": "Emile Allais", "city": "Courchevel", "country": "FRA", "event": "Women's Giant Slalom", "medal": True},
    {"date": "2026-01-31", "venue": "Emile Allais", "city": "Courchevel", "country": "FRA", "event": "Women's Slalom", "medal": True},

    # === OLYMPICS BREAK: Feb 4-22 ===

    # Post-Olympics: Crans-Montana (W) - Feb 28 - Mar 1
    {"date": "2026-02-28", "venue": "Mont Lachaux", "city": "Crans-Montana", "country": "SUI", "event": "Women's Downhill", "medal": True},
    {"date": "2026-03-01", "venue": "Mont Lachaux", "city": "Crans-Montana", "country": "SUI", "event": "Women's Super-G", "medal": True},

    # Kvitfjell (M) - Mar 7-8
    {"date": "2026-03-07", "venue": "Olympiabakken", "city": "Kvitfjell", "country": "NOR", "event": "Men's Downhill", "medal": True},
    {"date": "2026-03-08", "venue": "Olympiabakken", "city": "Kvitfjell", "country": "NOR", "event": "Men's Super-G", "medal": True},

    # Kranjska Gora (M) - Mar 8-9
    {"date": "2026-03-08", "venue": "Podkoren", "city": "Kranjska Gora", "country": "SLO", "event": "Men's Giant Slalom", "medal": True},
    {"date": "2026-03-09", "venue": "Podkoren", "city": "Kranjska Gora", "country": "SLO", "event": "Men's Slalom", "medal": True},

    # La Thuile (W) - Mar 14-15
    {"date": "2026-03-14", "venue": "Franco Berthod", "city": "La Thuile", "country": "ITA", "event": "Women's Downhill", "medal": True},
    {"date": "2026-03-15", "venue": "Franco Berthod", "city": "La Thuile", "country": "ITA", "event": "Women's Super-G", "medal": True},

    # Are (W) - Mar 14-15
    {"date": "2026-03-14", "venue": "Åreskutan", "city": "Åre", "country": "SWE", "event": "Women's Giant Slalom", "medal": True},
    {"date": "2026-03-15", "venue": "Åreskutan", "city": "Åre", "country": "SWE", "event": "Women's Slalom", "medal": True},

    # World Cup Finals - Lillehammer (Mar 21-25)
    {"date": "2026-03-21", "venue": "Kvitfjell", "city": "Lillehammer", "country": "NOR", "event": "Men's Downhill Final", "medal": True},
    {"date": "2026-03-21", "venue": "Kvitfjell", "city": "Lillehammer", "country": "NOR", "event": "Women's Downhill Final", "medal": True},
    {"date": "2026-03-22", "venue": "Kvitfjell", "city": "Lillehammer", "country": "NOR", "event": "Men's Super-G Final", "medal": True},
    {"date": "2026-03-22", "venue": "Kvitfjell", "city": "Lillehammer", "country": "NOR", "event": "Women's Super-G Final", "medal": True},
    {"date": "2026-03-23", "venue": "Hafjell", "city": "Lillehammer", "country": "NOR", "event": "Men's Giant Slalom Final", "medal": True},
    {"date": "2026-03-23", "venue": "Hafjell", "city": "Lillehammer", "country": "NOR", "event": "Women's Giant Slalom Final", "medal": True},
    {"date": "2026-03-25", "venue": "Hafjell", "city": "Lillehammer", "country": "NOR", "event": "Men's Slalom Final", "medal": True},
    {"date": "2026-03-25", "venue": "Hafjell", "city": "Lillehammer", "country": "NOR", "event": "Women's Slalom Final", "medal": True},
]


# ============================================================================
# IBU BIATHLON WORLD CUP
# ============================================================================
IBU_BIATHLON_EVENTS = [
    # Ruhpolding (GER) - Jan 14-18 (some events may be before Jan 19)
    {"date": "2026-01-19", "venue": "Chiemgau Arena", "city": "Ruhpolding", "country": "GER", "event": "Women's Mass Start 12.5km", "medal": True},
    {"date": "2026-01-19", "venue": "Chiemgau Arena", "city": "Ruhpolding", "country": "GER", "event": "Men's Mass Start 15km", "medal": True},

    # Nove Mesto (CZE) - Jan 22-25
    {"date": "2026-01-22", "venue": "Vysocina Arena", "city": "Nove Mesto na Morave", "country": "CZE", "event": "Women's Sprint 7.5km", "medal": True},
    {"date": "2026-01-22", "venue": "Vysocina Arena", "city": "Nove Mesto na Morave", "country": "CZE", "event": "Men's Sprint 10km", "medal": True},
    {"date": "2026-01-24", "venue": "Vysocina Arena", "city": "Nove Mesto na Morave", "country": "CZE", "event": "Women's Pursuit 10km", "medal": True},
    {"date": "2026-01-24", "venue": "Vysocina Arena", "city": "Nove Mesto na Morave", "country": "CZE", "event": "Men's Pursuit 12.5km", "medal": True},
    {"date": "2026-01-25", "venue": "Vysocina Arena", "city": "Nove Mesto na Morave", "country": "CZE", "event": "Single Mixed Relay", "medal": True},
    {"date": "2026-01-25", "venue": "Vysocina Arena", "city": "Nove Mesto na Morave", "country": "CZE", "event": "Mixed Relay", "medal": True},

    # === OLYMPICS BREAK: Feb 8-21 at Antholz ===

    # Kontiolahti (FIN) - Mar 5-8
    {"date": "2026-03-05", "venue": "Kontiolahti Biathlon Stadium", "city": "Kontiolahti", "country": "FIN", "event": "Women's Sprint 7.5km", "medal": True},
    {"date": "2026-03-05", "venue": "Kontiolahti Biathlon Stadium", "city": "Kontiolahti", "country": "FIN", "event": "Men's Sprint 10km", "medal": True},
    {"date": "2026-03-07", "venue": "Kontiolahti Biathlon Stadium", "city": "Kontiolahti", "country": "FIN", "event": "Women's Pursuit 10km", "medal": True},
    {"date": "2026-03-07", "venue": "Kontiolahti Biathlon Stadium", "city": "Kontiolahti", "country": "FIN", "event": "Men's Pursuit 12.5km", "medal": True},
    {"date": "2026-03-08", "venue": "Kontiolahti Biathlon Stadium", "city": "Kontiolahti", "country": "FIN", "event": "Women's Relay 4x6km", "medal": True},
    {"date": "2026-03-08", "venue": "Kontiolahti Biathlon Stadium", "city": "Kontiolahti", "country": "FIN", "event": "Men's Relay 4x7.5km", "medal": True},

    # Otepää (EST) - Mar 12-15
    {"date": "2026-03-12", "venue": "Tehvandi Sports Centre", "city": "Otepää", "country": "EST", "event": "Women's Sprint 7.5km", "medal": True},
    {"date": "2026-03-12", "venue": "Tehvandi Sports Centre", "city": "Otepää", "country": "EST", "event": "Men's Sprint 10km", "medal": True},
    {"date": "2026-03-14", "venue": "Tehvandi Sports Centre", "city": "Otepää", "country": "EST", "event": "Women's Pursuit 10km", "medal": True},
    {"date": "2026-03-14", "venue": "Tehvandi Sports Centre", "city": "Otepää", "country": "EST", "event": "Men's Pursuit 12.5km", "medal": True},
    {"date": "2026-03-15", "venue": "Tehvandi Sports Centre", "city": "Otepää", "country": "EST", "event": "Single Mixed Relay", "medal": True},
    {"date": "2026-03-15", "venue": "Tehvandi Sports Centre", "city": "Otepää", "country": "EST", "event": "Mixed Relay", "medal": True},

    # Holmenkollen Finals (NOR) - Mar 19-22
    {"date": "2026-03-19", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Women's Sprint 7.5km", "medal": True},
    {"date": "2026-03-19", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Men's Sprint 10km", "medal": True},
    {"date": "2026-03-21", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Women's Pursuit 10km", "medal": True},
    {"date": "2026-03-21", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Men's Pursuit 12.5km", "medal": True},
    {"date": "2026-03-22", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Women's Mass Start 12.5km", "medal": True},
    {"date": "2026-03-22", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Men's Mass Start 15km", "medal": True},
]


# ============================================================================
# FIS CROSS-COUNTRY SKIING WORLD CUP
# ============================================================================
FIS_CROSS_COUNTRY_EVENTS = [
    # Goms (SUI) - Jan 23-25
    {"date": "2026-01-23", "venue": "Goms Nordic Arena", "city": "Goms", "country": "SUI", "event": "Team Sprint Freestyle", "medal": True},
    {"date": "2026-01-24", "venue": "Goms Nordic Arena", "city": "Goms", "country": "SUI", "event": "Women's Sprint Classic", "medal": True},
    {"date": "2026-01-24", "venue": "Goms Nordic Arena", "city": "Goms", "country": "SUI", "event": "Men's Sprint Classic", "medal": True},
    {"date": "2026-01-25", "venue": "Goms Nordic Arena", "city": "Goms", "country": "SUI", "event": "Women's 20km Mass Start Classic", "medal": True},
    {"date": "2026-01-25", "venue": "Goms Nordic Arena", "city": "Goms", "country": "SUI", "event": "Men's 20km Mass Start Classic", "medal": True},

    # === OLYMPICS BREAK ===

    # Falun (SWE) - Feb 28 - Mar 1
    {"date": "2026-02-28", "venue": "Lugnet", "city": "Falun", "country": "SWE", "event": "Women's Sprint Freestyle", "medal": True},
    {"date": "2026-02-28", "venue": "Lugnet", "city": "Falun", "country": "SWE", "event": "Men's Sprint Freestyle", "medal": True},
    {"date": "2026-03-01", "venue": "Lugnet", "city": "Falun", "country": "SWE", "event": "Women's 20km Skiathlon", "medal": True},
    {"date": "2026-03-01", "venue": "Lugnet", "city": "Falun", "country": "SWE", "event": "Men's 20km Skiathlon", "medal": True},

    # Lahti (FIN) - Mar 7-8
    {"date": "2026-03-07", "venue": "Lahti Sports Centre", "city": "Lahti", "country": "FIN", "event": "Women's Sprint Freestyle", "medal": True},
    {"date": "2026-03-07", "venue": "Lahti Sports Centre", "city": "Lahti", "country": "FIN", "event": "Men's Sprint Freestyle", "medal": True},
    {"date": "2026-03-08", "venue": "Lahti Sports Centre", "city": "Lahti", "country": "FIN", "event": "Women's 10km Interval Start Freestyle", "medal": True},
    {"date": "2026-03-08", "venue": "Lahti Sports Centre", "city": "Lahti", "country": "FIN", "event": "Men's 10km Interval Start Freestyle", "medal": True},

    # Drammen - Oslo (NOR) - Mar 12-15
    {"date": "2026-03-12", "venue": "Drammen City Sprint", "city": "Drammen", "country": "NOR", "event": "Women's Sprint Classic", "medal": True},
    {"date": "2026-03-12", "venue": "Drammen City Sprint", "city": "Drammen", "country": "NOR", "event": "Men's Sprint Classic", "medal": True},
    {"date": "2026-03-14", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Women's 50km Mass Start Freestyle", "medal": True},
    {"date": "2026-03-14", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Men's 50km Mass Start Freestyle", "medal": True},

    # Lake Placid Finals (USA) - Mar 20-22
    {"date": "2026-03-20", "venue": "Mt. Van Hoevenberg", "city": "Lake Placid", "country": "USA", "event": "Women's 10km Interval Start Classic", "medal": True},
    {"date": "2026-03-20", "venue": "Mt. Van Hoevenberg", "city": "Lake Placid", "country": "USA", "event": "Men's 10km Interval Start Classic", "medal": True},
    {"date": "2026-03-21", "venue": "Mt. Van Hoevenberg", "city": "Lake Placid", "country": "USA", "event": "Women's Sprint Freestyle", "medal": True},
    {"date": "2026-03-21", "venue": "Mt. Van Hoevenberg", "city": "Lake Placid", "country": "USA", "event": "Men's Sprint Freestyle", "medal": True},
    {"date": "2026-03-22", "venue": "Mt. Van Hoevenberg", "city": "Lake Placid", "country": "USA", "event": "Women's 20km Mass Start Freestyle", "medal": True},
    {"date": "2026-03-22", "venue": "Mt. Van Hoevenberg", "city": "Lake Placid", "country": "USA", "event": "Men's 20km Mass Start Freestyle", "medal": True},
]


# ============================================================================
# FIS SKI JUMPING WORLD CUP
# ============================================================================
FIS_SKI_JUMPING_EVENTS = [
    # Zakopane (POL) - Jan 19
    {"date": "2026-01-19", "venue": "Wielka Krokiew", "city": "Zakopane", "country": "POL", "event": "Men's Individual HS134", "medal": True},

    # Ski Flying World Championships Oberstdorf (GER) - Jan 22-25
    {"date": "2026-01-22", "venue": "Heini-Klopfer-Skiflugschanze", "city": "Oberstdorf", "country": "GER", "event": "Ski Flying Qualification HS235", "medal": False},
    {"date": "2026-01-23", "venue": "Heini-Klopfer-Skiflugschanze", "city": "Oberstdorf", "country": "GER", "event": "Men's Individual Ski Flying HS235 (1)", "medal": True},
    {"date": "2026-01-24", "venue": "Heini-Klopfer-Skiflugschanze", "city": "Oberstdorf", "country": "GER", "event": "Men's Individual Ski Flying HS235 (2)", "medal": True},
    {"date": "2026-01-25", "venue": "Heini-Klopfer-Skiflugschanze", "city": "Oberstdorf", "country": "GER", "event": "Men's Team Ski Flying HS235", "medal": True},

    # Willingen (GER) - Jan 31 - Feb 1
    {"date": "2026-01-31", "venue": "Mühlenkopfschanze", "city": "Willingen", "country": "GER", "event": "Men's Individual HS147", "medal": True},
    {"date": "2026-02-01", "venue": "Mühlenkopfschanze", "city": "Willingen", "country": "GER", "event": "Men's Individual HS147", "medal": True},

    # === OLYMPICS BREAK ===

    # Lahti (FIN) - Feb 28 - Mar 1
    {"date": "2026-02-28", "venue": "Salpausselkä", "city": "Lahti", "country": "FIN", "event": "Men's Individual HS130", "medal": True},
    {"date": "2026-03-01", "venue": "Salpausselkä", "city": "Lahti", "country": "FIN", "event": "Men's Team HS130", "medal": True},

    # Oslo Raw Air (NOR) - Mar 6-7
    {"date": "2026-03-06", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Men's Individual HS134", "medal": True},
    {"date": "2026-03-07", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Men's Individual HS134", "medal": True},

    # Lillehammer Raw Air (NOR) - Mar 10-11
    {"date": "2026-03-10", "venue": "Lysgårdsbakken", "city": "Lillehammer", "country": "NOR", "event": "Men's Individual HS140", "medal": True},
    {"date": "2026-03-11", "venue": "Lysgårdsbakken", "city": "Lillehammer", "country": "NOR", "event": "Men's Individual HS140", "medal": True},

    # Trondheim Raw Air (NOR) - Mar 13-14
    {"date": "2026-03-13", "venue": "Granåsen", "city": "Trondheim", "country": "NOR", "event": "Men's Individual HS138", "medal": True},
    {"date": "2026-03-14", "venue": "Granåsen", "city": "Trondheim", "country": "NOR", "event": "Men's Individual HS138", "medal": True},

    # Vikersund Raw Air (NOR) - Mar 20-22
    {"date": "2026-03-20", "venue": "Vikersundbakken", "city": "Vikersund", "country": "NOR", "event": "Ski Flying Qualification HS240", "medal": False},
    {"date": "2026-03-21", "venue": "Vikersundbakken", "city": "Vikersund", "country": "NOR", "event": "Men's Individual Ski Flying HS240", "medal": True},
    {"date": "2026-03-22", "venue": "Vikersundbakken", "city": "Vikersund", "country": "NOR", "event": "Men's Team Ski Flying HS240", "medal": True},

    # Planica Finals (SLO) - Mar 26-29
    {"date": "2026-03-26", "venue": "Letalnica bratov Gorišek", "city": "Planica", "country": "SLO", "event": "Ski Flying Qualification HS240", "medal": False},
    {"date": "2026-03-27", "venue": "Letalnica bratov Gorišek", "city": "Planica", "country": "SLO", "event": "Men's Individual Ski Flying HS240", "medal": True},
    {"date": "2026-03-28", "venue": "Letalnica bratov Gorišek", "city": "Planica", "country": "SLO", "event": "Men's Team Ski Flying HS240", "medal": True},
    {"date": "2026-03-29", "venue": "Letalnica bratov Gorišek", "city": "Planica", "country": "SLO", "event": "Men's Individual Ski Flying HS240 Final", "medal": True},

    # Women's Ski Jumping events
    {"date": "2026-01-19", "venue": "Wielka Krokiew", "city": "Zakopane", "country": "POL", "event": "Women's Individual HS134", "medal": True},
    {"date": "2026-01-25", "venue": "Willingen", "city": "Willingen", "country": "GER", "event": "Women's Individual HS147", "medal": True},
    {"date": "2026-02-28", "venue": "Salpausselkä", "city": "Lahti", "country": "FIN", "event": "Women's Individual HS100", "medal": True},
    {"date": "2026-03-07", "venue": "Holmenkollen", "city": "Oslo", "country": "NOR", "event": "Women's Individual HS134", "medal": True},
    {"date": "2026-03-14", "venue": "Granåsen", "city": "Trondheim", "country": "NOR", "event": "Women's Individual HS138", "medal": True},
    {"date": "2026-03-28", "venue": "Letalnica bratov Gorišek", "city": "Planica", "country": "SLO", "event": "Women's Individual HS94", "medal": True},
]


# ============================================================================
# FIL LUGE WORLD CUP
# ============================================================================
FIL_LUGE_EVENTS = [
    # Altenberg (GER) World Cup Finals - Mar 3-8
    {"date": "2026-03-03", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Training Runs", "medal": False},
    {"date": "2026-03-05", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Women's Singles Run 1", "medal": False},
    {"date": "2026-03-05", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Women's Singles Run 2", "medal": True},
    {"date": "2026-03-06", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Men's Singles Run 1", "medal": False},
    {"date": "2026-03-06", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Men's Singles Run 2", "medal": True},
    {"date": "2026-03-07", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Women's Doubles", "medal": True},
    {"date": "2026-03-07", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Men's Doubles", "medal": True},
    {"date": "2026-03-08", "venue": "Altenberg Track", "city": "Altenberg", "country": "GER", "event": "Team Relay", "medal": True},
]


# ============================================================================
# ISU SPEED SKATING WORLD CUP
# ============================================================================
ISU_SPEED_SKATING_EVENTS = [
    # Inzell (GER) - Jan 23-25
    {"date": "2026-01-23", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Women's 500m", "medal": True},
    {"date": "2026-01-23", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Men's 500m", "medal": True},
    {"date": "2026-01-23", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Women's 3000m", "medal": True},
    {"date": "2026-01-24", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Men's 5000m", "medal": True},
    {"date": "2026-01-24", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Women's 1500m", "medal": True},
    {"date": "2026-01-24", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Men's 1500m", "medal": True},
    {"date": "2026-01-25", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Women's 1000m", "medal": True},
    {"date": "2026-01-25", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Men's 1000m", "medal": True},
    {"date": "2026-01-25", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Women's Team Pursuit", "medal": True},
    {"date": "2026-01-25", "venue": "Max Aicher Arena", "city": "Inzell", "country": "GER", "event": "Men's Team Pursuit", "medal": True},

    # World Championships Heerenveen (NED) - Mar 5-8
    {"date": "2026-03-05", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's 3000m World Championship", "medal": True},
    {"date": "2026-03-05", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's 5000m World Championship", "medal": True},
    {"date": "2026-03-06", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's 500m World Championship", "medal": True},
    {"date": "2026-03-06", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's 500m World Championship", "medal": True},
    {"date": "2026-03-06", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's 1500m World Championship", "medal": True},
    {"date": "2026-03-06", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's 1500m World Championship", "medal": True},
    {"date": "2026-03-07", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's 1000m World Championship", "medal": True},
    {"date": "2026-03-07", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's 1000m World Championship", "medal": True},
    {"date": "2026-03-07", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's Team Sprint World Championship", "medal": True},
    {"date": "2026-03-07", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's Team Sprint World Championship", "medal": True},
    {"date": "2026-03-08", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's 5000m World Championship", "medal": True},
    {"date": "2026-03-08", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's 10000m World Championship", "medal": True},
    {"date": "2026-03-08", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Women's Mass Start World Championship", "medal": True},
    {"date": "2026-03-08", "venue": "Thialf", "city": "Heerenveen", "country": "NED", "event": "Men's Mass Start World Championship", "medal": True},
]


# ============================================================================
# FIS FREESTYLE SKIING WORLD CUP
# ============================================================================
FIS_FREESTYLE_EVENTS = [
    # Deer Valley (USA) - Jan 16-18
    {"date": "2026-01-19", "venue": "Deer Valley Resort", "city": "Deer Valley", "country": "USA", "event": "Women's Aerials", "medal": True},
    {"date": "2026-01-19", "venue": "Deer Valley Resort", "city": "Deer Valley", "country": "USA", "event": "Men's Aerials", "medal": True},

    # Almaty (KAZ) - Jan 24-25
    {"date": "2026-01-24", "venue": "Sunkar", "city": "Almaty", "country": "KAZ", "event": "Women's Aerials", "medal": True},
    {"date": "2026-01-24", "venue": "Sunkar", "city": "Almaty", "country": "KAZ", "event": "Men's Aerials", "medal": True},
    {"date": "2026-01-25", "venue": "Sunkar", "city": "Almaty", "country": "KAZ", "event": "Team Aerials", "medal": True},

    # Moguls - various events
    {"date": "2026-01-23", "venue": "Alpe d'Huez", "city": "Alpe d'Huez", "country": "FRA", "event": "Women's Moguls", "medal": True},
    {"date": "2026-01-23", "venue": "Alpe d'Huez", "city": "Alpe d'Huez", "country": "FRA", "event": "Men's Moguls", "medal": True},
    {"date": "2026-01-24", "venue": "Alpe d'Huez", "city": "Alpe d'Huez", "country": "FRA", "event": "Women's Dual Moguls", "medal": True},
    {"date": "2026-01-24", "venue": "Alpe d'Huez", "city": "Alpe d'Huez", "country": "FRA", "event": "Men's Dual Moguls", "medal": True},

    # Ski Cross - Arosa (SUI) - Mar 20-22
    {"date": "2026-03-20", "venue": "Arosa Lenzerheide", "city": "Arosa", "country": "SUI", "event": "Women's Ski Cross Qualification", "medal": False},
    {"date": "2026-03-20", "venue": "Arosa Lenzerheide", "city": "Arosa", "country": "SUI", "event": "Men's Ski Cross Qualification", "medal": False},
    {"date": "2026-03-21", "venue": "Arosa Lenzerheide", "city": "Arosa", "country": "SUI", "event": "Women's Ski Cross Final", "medal": True},
    {"date": "2026-03-21", "venue": "Arosa Lenzerheide", "city": "Arosa", "country": "SUI", "event": "Men's Ski Cross Final", "medal": True},
    {"date": "2026-03-22", "venue": "Arosa Lenzerheide", "city": "Arosa", "country": "SUI", "event": "Team Ski Cross", "medal": True},

    # Moguls Finals - Idre Fjäll (SWE) - Mar 27-29
    {"date": "2026-03-27", "venue": "Idre Fjäll", "city": "Idre", "country": "SWE", "event": "Women's Moguls Final", "medal": True},
    {"date": "2026-03-27", "venue": "Idre Fjäll", "city": "Idre", "country": "SWE", "event": "Men's Moguls Final", "medal": True},
    {"date": "2026-03-28", "venue": "Idre Fjäll", "city": "Idre", "country": "SWE", "event": "Women's Dual Moguls Final", "medal": True},
    {"date": "2026-03-28", "venue": "Idre Fjäll", "city": "Idre", "country": "SWE", "event": "Men's Dual Moguls Final", "medal": True},
]


# ============================================================================
# FIS SNOWBOARD WORLD CUP
# ============================================================================
FIS_SNOWBOARD_EVENTS = [
    # Rogla (SLO) - Jan 19
    {"date": "2026-01-19", "venue": "Rogla", "city": "Rogla", "country": "SLO", "event": "Women's Parallel Giant Slalom", "medal": True},
    {"date": "2026-01-19", "venue": "Rogla", "city": "Rogla", "country": "SLO", "event": "Men's Parallel Giant Slalom", "medal": True},

    # Bansko (BUL) - Jan 25
    {"date": "2026-01-25", "venue": "Bansko", "city": "Bansko", "country": "BUL", "event": "Women's Parallel Giant Slalom", "medal": True},
    {"date": "2026-01-25", "venue": "Bansko", "city": "Bansko", "country": "BUL", "event": "Men's Parallel Giant Slalom", "medal": True},

    # Snowboard Cross - various locations
    {"date": "2026-01-23", "venue": "Reiteralm", "city": "Reiteralm", "country": "AUT", "event": "Women's Snowboard Cross", "medal": True},
    {"date": "2026-01-23", "venue": "Reiteralm", "city": "Reiteralm", "country": "AUT", "event": "Men's Snowboard Cross", "medal": True},
    {"date": "2026-01-24", "venue": "Reiteralm", "city": "Reiteralm", "country": "AUT", "event": "Mixed Team Snowboard Cross", "medal": True},

    # Finals - Winterberg (GER) - Mar 21-22
    {"date": "2026-03-21", "venue": "Winterberg", "city": "Winterberg", "country": "GER", "event": "Women's Parallel Slalom Final", "medal": True},
    {"date": "2026-03-21", "venue": "Winterberg", "city": "Winterberg", "country": "GER", "event": "Men's Parallel Slalom Final", "medal": True},
    {"date": "2026-03-22", "venue": "Winterberg", "city": "Winterberg", "country": "GER", "event": "Team Parallel Slalom Final", "medal": True},

    # Halfpipe/Slopestyle/Big Air events at Laax (SUI)
    {"date": "2026-01-20", "venue": "Laax", "city": "Laax", "country": "SUI", "event": "Women's Halfpipe", "medal": True},
    {"date": "2026-01-20", "venue": "Laax", "city": "Laax", "country": "SUI", "event": "Men's Halfpipe", "medal": True},
    {"date": "2026-01-21", "venue": "Laax", "city": "Laax", "country": "SUI", "event": "Women's Slopestyle", "medal": True},
    {"date": "2026-01-21", "venue": "Laax", "city": "Laax", "country": "SUI", "event": "Men's Slopestyle", "medal": True},
]


# ============================================================================
# WINTER OLYMPICS MILANO CORTINA 2026
# ============================================================================
OLYMPICS_EVENTS = [
    # Opening Ceremony
    {"date": "2026-02-06", "venue": "San Siro Stadium", "city": "Milano", "country": "ITA", "event": "Opening Ceremony", "medal": False, "sport": "Ceremony", "sport_code": "CER"},

    # Alpine Skiing
    {"date": "2026-02-09", "venue": "Stelvio", "city": "Bormio", "country": "ITA", "event": "Men's Downhill", "medal": True, "sport": "Alpine Skiing", "sport_code": "ALP"},
    {"date": "2026-02-10", "venue": "Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Giant Slalom", "medal": True},
    {"date": "2026-02-11", "venue": "Stelvio", "city": "Bormio", "country": "ITA", "event": "Men's Super-G", "medal": True},
    {"date": "2026-02-12", "venue": "Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Slalom", "medal": True},
    {"date": "2026-02-13", "venue": "Stelvio", "city": "Bormio", "country": "ITA", "event": "Men's Giant Slalom", "medal": True},
    {"date": "2026-02-15", "venue": "Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Downhill", "medal": True},
    {"date": "2026-02-16", "venue": "Stelvio", "city": "Bormio", "country": "ITA", "event": "Men's Slalom", "medal": True},
    {"date": "2026-02-17", "venue": "Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Super-G", "medal": True},
    {"date": "2026-02-18", "venue": "Stelvio", "city": "Bormio", "country": "ITA", "event": "Men's Combined", "medal": True},
    {"date": "2026-02-19", "venue": "Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Combined", "medal": True},
    {"date": "2026-02-21", "venue": "Tofane", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Mixed Team Parallel", "medal": True},

    # Biathlon
    {"date": "2026-02-08", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Mixed Relay", "medal": True},
    {"date": "2026-02-10", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Women's 15km Individual", "medal": True},
    {"date": "2026-02-11", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Men's 20km Individual", "medal": True},
    {"date": "2026-02-13", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Women's 7.5km Sprint", "medal": True},
    {"date": "2026-02-14", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Men's 10km Sprint", "medal": True},
    {"date": "2026-02-15", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Women's 10km Pursuit", "medal": True},
    {"date": "2026-02-16", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Men's 12.5km Pursuit", "medal": True},
    {"date": "2026-02-18", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Women's 4x6km Relay", "medal": True},
    {"date": "2026-02-19", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Men's 4x7.5km Relay", "medal": True},
    {"date": "2026-02-20", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Women's 12.5km Mass Start", "medal": True},
    {"date": "2026-02-21", "venue": "Anterselva Arena", "city": "Anterselva", "country": "ITA", "event": "Men's 15km Mass Start", "medal": True},

    # Cross-Country
    {"date": "2026-02-08", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Women's 7.5+7.5km Skiathlon", "medal": True},
    {"date": "2026-02-09", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Men's 15+15km Skiathlon", "medal": True},
    {"date": "2026-02-11", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Women's Sprint Free", "medal": True},
    {"date": "2026-02-11", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Men's Sprint Free", "medal": True},
    {"date": "2026-02-14", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Women's 10km Classic", "medal": True},
    {"date": "2026-02-15", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Men's 15km Classic", "medal": True},
    {"date": "2026-02-17", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Women's Team Sprint", "medal": True},
    {"date": "2026-02-17", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Men's Team Sprint", "medal": True},
    {"date": "2026-02-19", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Women's 4x5km Relay", "medal": True},
    {"date": "2026-02-20", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Men's 4x10km Relay", "medal": True},
    {"date": "2026-02-21", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Women's 30km Mass Start Free", "medal": True},
    {"date": "2026-02-22", "venue": "Tesero Stadium", "city": "Tesero", "country": "ITA", "event": "Men's 50km Mass Start Free", "medal": True},

    # Ski Jumping
    {"date": "2026-02-08", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Women's Normal Hill", "medal": True},
    {"date": "2026-02-09", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Men's Normal Hill", "medal": True},
    {"date": "2026-02-11", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Mixed Team Normal Hill", "medal": True},
    {"date": "2026-02-14", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Men's Large Hill", "medal": True},
    {"date": "2026-02-15", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Women's Large Hill", "medal": True},
    {"date": "2026-02-17", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Men's Team Large Hill", "medal": True},

    # Bobsled
    {"date": "2026-02-15", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Monobob", "medal": True},
    {"date": "2026-02-17", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Two-Woman Bobsled", "medal": True},
    {"date": "2026-02-18", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Two-Man Bobsled", "medal": True},
    {"date": "2026-02-22", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Four-Man Bobsled", "medal": True},

    # Luge
    {"date": "2026-02-08", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Men's Singles Luge", "medal": True},
    {"date": "2026-02-10", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Singles Luge", "medal": True},
    {"date": "2026-02-12", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Doubles Luge", "medal": True},
    {"date": "2026-02-13", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Team Relay Luge", "medal": True},

    # Skeleton
    {"date": "2026-02-13", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Men's Skeleton", "medal": True},
    {"date": "2026-02-14", "venue": "Cortina Sliding Centre", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Skeleton", "medal": True},

    # Figure Skating
    {"date": "2026-02-07", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Team Event", "medal": True},
    {"date": "2026-02-11", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Pairs Short Program", "medal": False},
    {"date": "2026-02-12", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Pairs Free Skating", "medal": True},
    {"date": "2026-02-14", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Men's Short Program", "medal": False},
    {"date": "2026-02-15", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Men's Free Skating", "medal": True},
    {"date": "2026-02-17", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Ice Dance Rhythm Dance", "medal": False},
    {"date": "2026-02-18", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Ice Dance Free Dance", "medal": True},
    {"date": "2026-02-19", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Women's Short Program", "medal": False},
    {"date": "2026-02-21", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Women's Free Skating", "medal": True},

    # Speed Skating
    {"date": "2026-02-08", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's 5000m", "medal": True},
    {"date": "2026-02-08", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's 3000m", "medal": True},
    {"date": "2026-02-10", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's 1500m", "medal": True},
    {"date": "2026-02-10", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's 1500m", "medal": True},
    {"date": "2026-02-12", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's 500m", "medal": True},
    {"date": "2026-02-13", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's 500m", "medal": True},
    {"date": "2026-02-15", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's 1000m", "medal": True},
    {"date": "2026-02-15", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's 1000m", "medal": True},
    {"date": "2026-02-17", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's Team Pursuit", "medal": True},
    {"date": "2026-02-17", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's Team Pursuit", "medal": True},
    {"date": "2026-02-19", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's 10000m", "medal": True},
    {"date": "2026-02-20", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's 5000m", "medal": True},
    {"date": "2026-02-21", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Men's Mass Start", "medal": True},
    {"date": "2026-02-21", "venue": "Milano Speed Skating Arena", "city": "Milano", "country": "ITA", "event": "Women's Mass Start", "medal": True},

    # Short Track
    {"date": "2026-02-08", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Mixed Team Relay", "medal": True},
    {"date": "2026-02-12", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Women's 500m", "medal": True},
    {"date": "2026-02-13", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Men's 1000m", "medal": True},
    {"date": "2026-02-14", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Women's 1500m", "medal": True},
    {"date": "2026-02-15", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Men's 500m", "medal": True},
    {"date": "2026-02-17", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Women's 1000m", "medal": True},
    {"date": "2026-02-18", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Men's 1500m", "medal": True},
    {"date": "2026-02-19", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Women's 3000m Relay", "medal": True},
    {"date": "2026-02-21", "venue": "Milano Ice Arena", "city": "Milano", "country": "ITA", "event": "Men's 5000m Relay", "medal": True},

    # Freestyle Skiing
    {"date": "2026-02-08", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Moguls", "medal": True},
    {"date": "2026-02-09", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Moguls", "medal": True},
    {"date": "2026-02-11", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Big Air", "medal": True},
    {"date": "2026-02-12", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Big Air", "medal": True},
    {"date": "2026-02-14", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Slopestyle", "medal": True},
    {"date": "2026-02-15", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Slopestyle", "medal": True},
    {"date": "2026-02-16", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Aerials", "medal": True},
    {"date": "2026-02-17", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Aerials", "medal": True},
    {"date": "2026-02-18", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Mixed Team Aerials", "medal": True},
    {"date": "2026-02-19", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Halfpipe", "medal": True},
    {"date": "2026-02-20", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Halfpipe", "medal": True},
    {"date": "2026-02-21", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Ski Cross", "medal": True},
    {"date": "2026-02-22", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Ski Cross", "medal": True},

    # Snowboard
    {"date": "2026-02-08", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Slopestyle", "medal": True},
    {"date": "2026-02-09", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Slopestyle", "medal": True},
    {"date": "2026-02-11", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Parallel Giant Slalom", "medal": True},
    {"date": "2026-02-11", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Parallel Giant Slalom", "medal": True},
    {"date": "2026-02-13", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Halfpipe", "medal": True},
    {"date": "2026-02-14", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Halfpipe", "medal": True},
    {"date": "2026-02-15", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Big Air", "medal": True},
    {"date": "2026-02-16", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Big Air", "medal": True},
    {"date": "2026-02-18", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Mixed Team Snowboard Cross", "medal": True},
    {"date": "2026-02-19", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Women's Snowboard Cross", "medal": True},
    {"date": "2026-02-20", "venue": "Livigno Snow Park", "city": "Livigno", "country": "ITA", "event": "Men's Snowboard Cross", "medal": True},

    # Nordic Combined
    {"date": "2026-02-13", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Individual Normal Hill/10km", "medal": True},
    {"date": "2026-02-17", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Individual Large Hill/10km", "medal": True},
    {"date": "2026-02-20", "venue": "Predazzo Stadium", "city": "Predazzo", "country": "ITA", "event": "Team Large Hill/4x5km", "medal": True},

    # Curling
    {"date": "2026-02-06", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Mixed Doubles Round Robin", "medal": False},
    {"date": "2026-02-10", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Mixed Doubles Gold Medal", "medal": True},
    {"date": "2026-02-11", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Men's Round Robin", "medal": False},
    {"date": "2026-02-11", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Round Robin", "medal": False},
    {"date": "2026-02-19", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Men's Semifinal", "medal": False},
    {"date": "2026-02-19", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Semifinal", "medal": False},
    {"date": "2026-02-21", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Women's Gold Medal", "medal": True},
    {"date": "2026-02-22", "venue": "Cortina Olympic Ice Stadium", "city": "Cortina d'Ampezzo", "country": "ITA", "event": "Men's Gold Medal", "medal": True},

    # Ice Hockey
    {"date": "2026-02-08", "venue": "Milano Hockey Arena", "city": "Milano", "country": "ITA", "event": "Women's Preliminary Round", "medal": False},
    {"date": "2026-02-09", "venue": "Milano Hockey Arena", "city": "Milano", "country": "ITA", "event": "Men's Preliminary Round", "medal": False},
    {"date": "2026-02-18", "venue": "Milano Hockey Arena", "city": "Milano", "country": "ITA", "event": "Women's Semifinal", "medal": False},
    {"date": "2026-02-19", "venue": "Milano Hockey Arena", "city": "Milano", "country": "ITA", "event": "Men's Semifinal", "medal": False},
    {"date": "2026-02-20", "venue": "Milano Hockey Arena", "city": "Milano", "country": "ITA", "event": "Women's Gold Medal", "medal": True},
    {"date": "2026-02-22", "venue": "Milano Hockey Arena", "city": "Milano", "country": "ITA", "event": "Men's Gold Medal", "medal": True},

    # Closing Ceremony
    {"date": "2026-02-22", "venue": "Verona Arena", "city": "Verona", "country": "ITA", "event": "Closing Ceremony", "medal": False},
]


# Sport code mapping
SPORT_CODES = {
    "Alpine Skiing": "ALP",
    "Biathlon": "BTH",
    "Bobsled": "BOB",
    "Cross-Country Skiing": "CCS",
    "Curling": "CUR",
    "Figure Skating": "FSK",
    "Freestyle Skiing": "FRS",
    "Ice Hockey": "IHO",
    "Luge": "LUG",
    "Nordic Combined": "NCB",
    "Short Track": "STK",
    "Skeleton": "SKN",
    "Ski Jumping": "SJP",
    "Snowboard": "SBD",
    "Speed Skating": "SSK",
}


def get_sport_from_event(event_name: str, venue: str = "") -> tuple[str, str]:
    """Determine sport and sport_code from event name and venue."""
    event_lower = event_name.lower()
    venue_lower = venue.lower() if venue else ""

    # Ceremonies
    if "ceremony" in event_lower:
        return "Ceremony", "CER"

    # Olympic venue-based detection for specific venues
    if "stelvio" in venue_lower or "tofane" in venue_lower:
        return "Alpine Skiing", "ALP"
    if "anterselva" in venue_lower:
        return "Biathlon", "BTH"
    if "tesero" in venue_lower:
        return "Cross-Country Skiing", "CCS"
    if "predazzo" in venue_lower and "combined" not in event_lower:
        if "10km" in event_lower or "5km" in event_lower:
            return "Nordic Combined", "NCB"
        return "Ski Jumping", "SJP"
    if "sliding" in venue_lower:
        if "luge" in event_lower:
            return "Luge", "LUG"
        if "skeleton" in event_lower:
            return "Skeleton", "SKN"
        if any(kw in event_lower for kw in ["bobsled", "bobsleigh", "monobob", "two-man", "two-woman", "four-man"]):
            return "Bobsled", "BOB"
    if "hockey" in venue_lower:
        return "Ice Hockey", "IHO"
    if "speed skating" in venue_lower:
        return "Speed Skating", "SSK"
    if "ice arena" in venue_lower:
        if any(kw in event_lower for kw in ["pairs", "ice dance", "free skating", "short program", "team event"]):
            return "Figure Skating", "FSK"
        return "Short Track", "STK"
    if "snow park" in venue_lower or "livigno" in venue_lower:
        if any(kw in event_lower for kw in ["moguls", "aerials", "ski cross"]):
            return "Freestyle Skiing", "FRS"
        if any(kw in event_lower for kw in ["snowboard", "parallel"]):
            return "Snowboard", "SBD"
        # Default for park events - check event name
        if any(kw in event_lower for kw in ["halfpipe", "slopestyle", "big air"]):
            # Freestyle has "Women's/Men's" prefix, Snowboard has similar patterns
            # Use "ski" presence as differentiator
            return "Freestyle Skiing", "FRS"
    if "olympic ice stadium" in venue_lower or "curling" in venue_lower:
        return "Curling", "CUR"

    # Alpine Skiing - check first as it has specific keywords
    if any(kw in event_lower for kw in ["downhill", "super-g", "giant slalom", "slalom", "combined"]):
        if "parallel" not in event_lower:
            return "Alpine Skiing", "ALP"

    # Biathlon - specific patterns
    if any(kw in event_lower for kw in ["individual", "pursuit", "mass start", "relay"]) and "km" in event_lower:
        if "skating" not in event_lower and "skiathlon" not in event_lower:
            return "Biathlon", "BTH"

    # Bobsled
    if any(kw in event_lower for kw in ["bobsled", "bobsleigh", "monobob", "two-man", "two-woman", "four-man"]):
        return "Bobsled", "BOB"

    # Cross-Country Skiing
    if any(kw in event_lower for kw in ["skiathlon", "interval start", "team sprint"]) or \
       ("sprint" in event_lower and ("classic" in event_lower or "freestyle" in event_lower)) or \
       ("km" in event_lower and "mass start" in event_lower and "skating" not in event_lower):
        if "skating" not in venue_lower and "ice" not in venue_lower:
            return "Cross-Country Skiing", "CCS"

    # Curling
    if any(kw in event_lower for kw in ["curling", "mixed doubles"]) or "round robin" in event_lower:
        return "Curling", "CUR"

    # Figure Skating
    if any(kw in event_lower for kw in ["figure", "pairs", "ice dance", "free skating", "short program", "team event"]):
        if "skating" in event_lower or "ice" in venue_lower:
            return "Figure Skating", "FSK"

    # Freestyle Skiing
    if any(kw in event_lower for kw in ["moguls", "aerials", "ski cross"]):
        return "Freestyle Skiing", "FRS"

    # Ice Hockey
    if "hockey" in event_lower or "preliminary round" in event_lower or ("semifinal" in event_lower and "hockey" in venue_lower):
        if "hockey" in venue_lower:
            return "Ice Hockey", "IHO"

    # Luge
    if "luge" in event_lower or ("singles" in event_lower and "sliding" in venue_lower):
        return "Luge", "LUG"

    # Skeleton
    if "skeleton" in event_lower:
        return "Skeleton", "SKN"

    # Nordic Combined
    if "nordic combined" in event_lower or any(kw in event_lower for kw in ["normal hill/10km", "large hill/10km", "large hill/4x5km"]):
        return "Nordic Combined", "NCB"

    # Short Track Speed Skating
    if "short track" in event_lower or "mixed team relay" in event_lower:
        return "Short Track", "STK"

    # Ski Jumping
    if any(kw in event_lower for kw in ["ski jumping", "ski flying", "normal hill", "large hill"]) or "hs" in event_lower:
        if "10km" not in event_lower and "5km" not in event_lower:  # Exclude Nordic Combined
            return "Ski Jumping", "SJP"

    # Snowboard - including halfpipe, slopestyle, big air, parallel
    if any(kw in event_lower for kw in ["snowboard", "halfpipe", "slopestyle", "big air", "parallel"]):
        return "Snowboard", "SBD"

    # Speed Skating - long track
    if any(kw in event_lower for kw in ["team pursuit", "10000m", "5000m", "3000m"]) or \
       (any(kw in event_lower for kw in ["1500m", "1000m", "500m"]) and "short track" not in event_lower):
        if "speed" in venue_lower or "skating" in venue_lower:
            return "Speed Skating", "SSK"

    # Default fallback
    return "Winter Sports", "WSP"


def build_events():
    """Build complete events list."""
    all_events = []
    counters = {}

    # Process each federation's events
    federation_data = [
        ("FIS", "World Cup", FIS_ALPINE_EVENTS, "Alpine Skiing", "ALP"),
        ("IBU", "World Cup", IBU_BIATHLON_EVENTS, "Biathlon", "BTH"),
        ("FIS", "World Cup", FIS_CROSS_COUNTRY_EVENTS, "Cross-Country Skiing", "CCS"),
        ("FIS", "World Cup", FIS_SKI_JUMPING_EVENTS, "Ski Jumping", "SJP"),
        ("FIL", "World Cup", FIL_LUGE_EVENTS, "Luge", "LUG"),
        ("ISU", "World Cup", ISU_SPEED_SKATING_EVENTS, "Speed Skating", "SSK"),
        ("FIS", "World Cup", FIS_FREESTYLE_EVENTS, "Freestyle Skiing", "FRS"),
        ("FIS", "World Cup", FIS_SNOWBOARD_EVENTS, "Snowboard", "SBD"),
        ("IOC", "Winter Olympics", OLYMPICS_EVENTS, None, None),  # Mixed sports
    ]

    for federation, series, events, default_sport, default_code in federation_data:
        for event in events:
            # Filter to only Jan 19+ events
            event_date = datetime.strptime(event["date"], "%Y-%m-%d")
            if event_date < datetime(2026, 1, 19):
                continue

            # Determine sport - use explicit if provided, else detect from event name
            if event.get("sport") and event.get("sport_code"):
                sport = event["sport"]
                sport_code = event["sport_code"]
            elif default_sport:
                sport = default_sport
                sport_code = default_code
            else:
                sport, sport_code = get_sport_from_event(event["event"], event.get("venue", ""))

            # Generate unique ID
            key = f"{federation}-{sport_code}"
            counters[key] = counters.get(key, 0) + 1
            event_id = f"{federation}-{sport_code}-{counters[key]:04d}"

            all_events.append({
                "event_id": event_id,
                "sport": sport,
                "sport_code": sport_code,
                "event_name": event["event"],
                "date": event["date"],
                "time": event.get("time", "10:00"),  # Default time if not specified
                "venue": event["venue"],
                "venue_city": event["city"],
                "country": event["country"],
                "status": "scheduled",
                "medal_event": event["medal"],
                "federation": federation,
                "series": series,
            })

    # Sort by date and time
    all_events.sort(key=lambda e: (e["date"], e["time"], e["sport"]))

    return all_events


def main():
    """Generate and save World Cup events."""
    print("=" * 60)
    print("Winter Sports World Cup Calendar Generator 2025-26")
    print("=" * 60)
    print()

    # Ensure output directory exists
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    events = build_events()

    print(f"Total events: {len(events)}")
    print()

    # Stats by federation
    print("Events by federation:")
    federations = {}
    for e in events:
        fed = e["federation"]
        federations[fed] = federations.get(fed, 0) + 1
    for fed, count in sorted(federations.items(), key=lambda x: -x[1]):
        print(f"  {fed}: {count}")

    print()

    # Stats by sport
    print("Events by sport:")
    sports = {}
    for e in events:
        sport = e["sport"]
        sports[sport] = sports.get(sport, 0) + 1
    for sport, count in sorted(sports.items(), key=lambda x: -x[1]):
        print(f"  {sport}: {count}")

    # Save to file
    output = {
        "meta": {
            "generated_at": datetime.utcnow().isoformat() + "Z",
            "season": "2025-2026",
            "start_date": "2026-01-19",
            "total_events": len(events),
        },
        "events": events,
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)

    print()
    print(f"Saved to: {OUTPUT_FILE}")
    print(f"File size: {OUTPUT_FILE.stat().st_size / 1024:.1f} KB")


if __name__ == "__main__":
    main()
