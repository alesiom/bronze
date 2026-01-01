/**
 * Event types matching the scraped schedule data
 */

export type EventStatus =
  | 'scheduled'
  | 'live'
  | 'finished'
  | 'delayed'
  | 'cancelled'
  | 'postponed';

export type SportCode =
  | 'ALP' // Alpine Skiing
  | 'BTH' // Biathlon
  | 'BOB' // Bobsleigh
  | 'CCS' // Cross-Country Skiing
  | 'CER' // Ceremonies
  | 'CUR' // Curling
  | 'FSK' // Figure Skating
  | 'FRS' // Freestyle Skiing
  | 'IHO' // Ice Hockey
  | 'LUG' // Luge
  | 'NCB' // Nordic Combined
  | 'SKN' // Skeleton
  | 'STK' // Short Track Speed Skating
  | 'SJP' // Ski Jumping
  | 'SMT' // Ski Mountaineering
  | 'SBD' // Snowboard
  | 'SSK'; // Speed Skating

export interface TeamInfo {
  teamCode: string; // 3-letter country code (e.g., "SWE", "USA")
  description: string; // Country name (e.g., "Sweden")
}

export interface MatchInfo {
  team1: TeamInfo | null;
  team2: TeamInfo | null;
}

export interface Event {
  // Core identifiers
  event_id: string;
  session_code: string;

  // Sport/discipline
  sport_code: SportCode;
  sport: string;

  // Event details
  event_name: string;
  is_medal_event: boolean;
  is_training: boolean;

  // Timing (ISO format: "2026-02-07T11:30:00")
  date: string; // YYYY-MM-DD
  start_time: string; // Full ISO local datetime
  end_time: string; // Full ISO local datetime
  start_utc: string; // UTC datetime
  end_utc: string; // UTC datetime
  estimated: boolean;

  // Venue
  venue_code: string | null;
  venue: string | null;
  venue_slug: string | null;
  location: string;
  location_code: string | null;

  // Match info (for team sports like hockey, curling)
  match: MatchInfo | null;

  // Ticketing
  ticketing_url: string | null;

  // Status (updated during games)
  status: EventStatus;
}

export interface ScheduleData {
  meta: {
    fetched_at: string;
    source: string;
    edition: string;
    total_events: number;
    competition_days: number;
    days_fetched: number;
  };
  disciplines: Discipline[];
  events: Event[];
}

export interface Discipline {
  order: number;
  disciplineCode: SportCode;
  disciplineSlug: string;
  description: string;
  sortOrder: number;
  disciplineUrl: string;
}

export interface EventGroup {
  title: string;
  data: Event[];
}

export interface FilterState {
  sport: SportCode | null;
  venue: string | null;
  date: string | null;
  medalsOnly: boolean;
}
