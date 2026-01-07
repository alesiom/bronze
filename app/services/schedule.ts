/**
 * Schedule data service
 * Loads and queries the bundled schedule data
 */

import type { Event, ScheduleData, SportCode, FilterState, Discipline, Session, MatchInfo } from '../types';

// Import bundled schedule data
import scheduleData from '../assets/data/schedule.json';

// Type assertion for imported JSON
const schedule = scheduleData as ScheduleData;

// Venue city mapping (derived from venue names)
const VENUE_CITIES: Record<string, string> = {
  'Stelvio Ski Centre': 'Bormio',
  'Tofane Alpine Skiing Centre': 'Cortina',
  'Cortina Curling Olympic Stadium': 'Cortina',
  'Cortina Sliding Centre': 'Cortina',
  'Anterselva Biathlon Arena': 'Anterselva',
  'Predazzo Ski Jumping Stadium': 'Predazzo',
  'Tesero Cross-Country Skiing Stadium': 'Tesero',
  'Milano Ice Skating Arena': 'Milan',
  'Milano Speed Skating Stadium': 'Milan',
  'Milano Santagiulia Ice Hockey Arena': 'Milan',
  'Milano Rho Ice Hockey Arena': 'Rho',
  'Livigno Snow Park': 'Livigno',
  'Livigno Aerials & Moguls Park': 'Livigno',
};

/**
 * Get venue city from venue name
 */
export function getVenueCity(venue: string | null): string {
  if (!venue) return '';
  return VENUE_CITIES[venue] || '';
}

/**
 * Get all events
 */
export function getAllEvents(): Event[] {
  return schedule.events;
}

/**
 * Get schedule metadata
 */
export function getScheduleMeta(): ScheduleData['meta'] {
  return schedule.meta;
}

/**
 * Get all disciplines
 */
export function getDisciplines(): Discipline[] {
  return schedule.disciplines;
}

/**
 * Get unique venues from schedule
 */
export function getVenues(): string[] {
  const venues = new Set<string>();
  for (const event of schedule.events) {
    if (event.venue) {
      venues.add(event.venue);
    }
  }
  return Array.from(venues).sort();
}

/**
 * Get unique dates from schedule
 */
export function getDates(): string[] {
  const dates = new Set<string>();
  for (const event of schedule.events) {
    dates.add(event.date);
  }
  return Array.from(dates).sort();
}

/**
 * Get event by ID
 */
export function getEventById(eventId: string): Event | undefined {
  return schedule.events.find((e) => e.event_id === eventId);
}

/**
 * Get events by IDs (for favorites)
 */
export function getEventsByIds(eventIds: string[]): Event[] {
  const idSet = new Set(eventIds);
  return schedule.events.filter((e) => idSet.has(e.event_id));
}

/**
 * Filter events based on filter state
 */
export function filterEvents(
  events: Event[],
  filters: FilterState,
  options?: {
    includeTraining?: boolean;
    includePast?: boolean;
  }
): Event[] {
  const now = new Date();
  const { includeTraining = false, includePast = false } = options || {};

  return events.filter((event) => {
    // Filter out training sessions unless explicitly included
    if (!includeTraining && event.is_training) {
      return false;
    }

    // Filter out past events unless explicitly included
    if (!includePast) {
      const eventEnd = new Date(event.end_time);
      if (eventEnd < now) {
        return false;
      }
    }

    // Sport filter
    if (filters.sport && event.sport_code !== filters.sport) {
      return false;
    }

    // Venue filter
    if (filters.venue && event.venue !== filters.venue) {
      return false;
    }

    // Date filter
    if (filters.date && event.date !== filters.date) {
      return false;
    }

    // Medal events only
    if (filters.medalsOnly && !event.is_medal_event) {
      return false;
    }

    // Country filter - event must have this country participating
    if (filters.country) {
      const hasCountry =
        event.match?.team1?.teamCode === filters.country ||
        event.match?.team2?.teamCode === filters.country;
      if (!hasCountry) {
        return false;
      }
    }

    return true;
  });
}

/**
 * Get upcoming events (from now onward)
 */
export function getUpcomingEvents(limit?: number): Event[] {
  const now = new Date();

  const upcoming = schedule.events
    .filter((event) => {
      const eventStart = new Date(event.start_time);
      return eventStart >= now && !event.is_training;
    })
    .sort((a, b) => new Date(a.start_time).getTime() - new Date(b.start_time).getTime());

  return limit ? upcoming.slice(0, limit) : upcoming;
}

/**
 * Get live events (currently happening)
 */
export function getLiveEvents(): Event[] {
  const now = new Date();

  return schedule.events.filter((event) => {
    const start = new Date(event.start_time);
    const end = new Date(event.end_time);
    return start <= now && end >= now && !event.is_training;
  });
}

/**
 * Get events for a specific date
 */
export function getEventsForDate(date: string): Event[] {
  return schedule.events
    .filter((event) => event.date === date && !event.is_training)
    .sort((a, b) => new Date(a.start_time).getTime() - new Date(b.start_time).getTime());
}

/**
 * Get events grouped by date
 */
export function getEventsGroupedByDate(
  events: Event[]
): { date: string; events: Event[] }[] {
  const grouped = new Map<string, Event[]>();

  for (const event of events) {
    const existing = grouped.get(event.date) || [];
    existing.push(event);
    grouped.set(event.date, existing);
  }

  return Array.from(grouped.entries())
    .map(([date, events]) => ({
      date,
      events: events.sort(
        (a, b) => new Date(a.start_time).getTime() - new Date(b.start_time).getTime()
      ),
    }))
    .sort((a, b) => a.date.localeCompare(b.date));
}

/**
 * Search events by name
 */
export function searchEvents(query: string): Event[] {
  const lowerQuery = query.toLowerCase();

  return schedule.events.filter((event) => {
    return (
      event.event_name.toLowerCase().includes(lowerQuery) ||
      event.sport.toLowerCase().includes(lowerQuery) ||
      (event.venue && event.venue.toLowerCase().includes(lowerQuery)) ||
      (event.match?.team1?.description.toLowerCase().includes(lowerQuery)) ||
      (event.match?.team2?.description.toLowerCase().includes(lowerQuery))
    );
  });
}

/**
 * Get medal events only
 */
export function getMedalEvents(): Event[] {
  return schedule.events
    .filter((event) => event.is_medal_event)
    .sort((a, b) => new Date(a.start_time).getTime() - new Date(b.start_time).getTime());
}

/**
 * Get events by sport
 */
export function getEventsBySport(sportCode: SportCode): Event[] {
  return schedule.events
    .filter((event) => event.sport_code === sportCode && !event.is_training)
    .sort((a, b) => new Date(a.start_time).getTime() - new Date(b.start_time).getTime());
}

/**
 * Parse time from event for display
 * Returns HH:MM format
 */
export function getEventTime(event: Event): string {
  const date = new Date(event.start_time);
  return date.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' });
}

/**
 * Get event duration in minutes
 */
export function getEventDuration(event: Event): number {
  const start = new Date(event.start_time);
  const end = new Date(event.end_time);
  return Math.round((end.getTime() - start.getTime()) / (1000 * 60));
}

// ============================================
// Session grouping (for team sports with multiple simultaneous matches)
// ============================================

/**
 * Group events by session_code into Sessions
 */
export function groupEventsIntoSessions(events: Event[]): Session[] {
  const sessionMap = new Map<string, Event[]>();

  // Group events by session_code
  for (const event of events) {
    const existing = sessionMap.get(event.session_code) || [];
    existing.push(event);
    sessionMap.set(event.session_code, existing);
  }

  // Convert to Session objects
  const sessions: Session[] = [];

  for (const [sessionCode, sessionEvents] of sessionMap) {
    // Sort events by start_time to ensure we use the earliest event for session properties
    sessionEvents.sort((a, b) =>
      new Date(a.start_time).getTime() - new Date(b.start_time).getTime()
    );

    // Use first (earliest) event for common properties
    const first = sessionEvents[0];

    // Extract matches and countries
    const matches: MatchInfo[] = [];
    const countryCodes = new Set<string>();

    for (const event of sessionEvents) {
      if (event.match) {
        matches.push(event.match);
        if (event.match.team1?.teamCode) {
          countryCodes.add(event.match.team1.teamCode);
        }
        if (event.match.team2?.teamCode) {
          countryCodes.add(event.match.team2.teamCode);
        }
      }
    }

    sessions.push({
      session_code: sessionCode,
      sport_code: first.sport_code,
      sport: first.sport,
      event_name: first.event_name,
      date: first.date,
      start_time: first.start_time,
      end_time: first.end_time,
      venue: first.venue,
      is_medal_event: first.is_medal_event,
      is_training: first.is_training,
      status: first.status,
      ticketing_url: first.ticketing_url,
      events: sessionEvents,
      matches,
      countries: Array.from(countryCodes),
    });
  }

  return sessions;
}

/**
 * Get all sessions (events grouped by session_code)
 */
export function getAllSessions(): Session[] {
  return groupEventsIntoSessions(schedule.events);
}

/**
 * Get session by session_code
 */
export function getSessionByCode(sessionCode: string): Session | undefined {
  const events = schedule.events.filter(e => e.session_code === sessionCode);
  if (events.length === 0) return undefined;

  const sessions = groupEventsIntoSessions(events);
  return sessions[0];
}

/**
 * Get all unique countries from schedule
 */
export function getCountries(): string[] {
  const countries = new Set<string>();

  for (const event of schedule.events) {
    if (event.match?.team1?.teamCode) {
      countries.add(event.match.team1.teamCode);
    }
    if (event.match?.team2?.teamCode) {
      countries.add(event.match.team2.teamCode);
    }
  }

  return Array.from(countries).sort();
}

/**
 * Filter sessions based on filter state
 */
export function filterSessions(
  sessions: Session[],
  filters: FilterState,
  options?: {
    includeTraining?: boolean;
    includePast?: boolean;
  }
): Session[] {
  const now = new Date();
  const { includeTraining = false, includePast = false } = options || {};

  return sessions.filter((session) => {
    // Filter out training sessions unless explicitly included
    if (!includeTraining && session.is_training) {
      return false;
    }

    // Filter out past sessions unless explicitly included
    if (!includePast) {
      const sessionEnd = new Date(session.end_time);
      if (sessionEnd < now) {
        return false;
      }
    }

    // Sport filter
    if (filters.sport && session.sport_code !== filters.sport) {
      return false;
    }

    // Venue filter
    if (filters.venue && session.venue !== filters.venue) {
      return false;
    }

    // Date filter
    if (filters.date && session.date !== filters.date) {
      return false;
    }

    // Medal events only
    if (filters.medalsOnly && !session.is_medal_event) {
      return false;
    }

    // Country filter - session must have this country participating
    if (filters.country && !session.countries.includes(filters.country)) {
      return false;
    }

    return true;
  });
}

/**
 * Get sessions grouped by date
 */
export function getSessionsGroupedByDate(
  sessions: Session[]
): { date: string; sessions: Session[] }[] {
  const grouped = new Map<string, Session[]>();

  for (const session of sessions) {
    const existing = grouped.get(session.date) || [];
    existing.push(session);
    grouped.set(session.date, existing);
  }

  return Array.from(grouped.entries())
    .map(([date, dateSessions]) => ({
      date,
      sessions: dateSessions.sort(
        (a, b) => new Date(a.start_time).getTime() - new Date(b.start_time).getTime()
      ),
    }))
    .sort((a, b) => a.date.localeCompare(b.date));
}
