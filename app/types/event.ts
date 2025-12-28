/**
 * Event types matching the backend API
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
  | 'BOB' // Bobsled
  | 'CCS' // Cross-Country Skiing
  | 'CUR' // Curling
  | 'FSK' // Figure Skating
  | 'FRS' // Freestyle Skiing
  | 'IHO' // Ice Hockey
  | 'LUG' // Luge
  | 'NCB' // Nordic Combined
  | 'STK' // Skeleton
  | 'SKN' // Short Track
  | 'SJP' // Ski Jumping
  | 'SMT' // Snowboard
  | 'SBD' // Snowboard (alt)
  | 'SSK'; // Speed Skating

export interface Event {
  event_id: string;
  sport: string;
  sport_code: SportCode;
  event_name: string;
  date: string; // ISO date string YYYY-MM-DD
  time: string | null; // HH:MM format
  venue: string;
  venue_city: string;
  status: EventStatus;
  session_code: string;
  is_medal_event: boolean;
  created_at?: string;
  updated_at?: string;
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
