import { useState, useEffect, useCallback, useMemo } from 'react';
import type { Event, FilterState, SportCode, Session } from '../types';
import {
  getAllEvents,
  getEventById as getEventByIdFromSchedule,
  filterEvents,
  getUpcomingEvents,
  getLiveEvents,
  getEventsForDate,
  getEventsBySport,
  getMedalEvents,
  searchEvents,
  getDisciplines,
  getVenues,
  getDates,
  getAllSessions,
  getSessionByCode,
  filterSessions,
  getCountries,
} from '../services/schedule';

/**
 * Get a single event by ID
 */
export function getEventById(id: string): Event | undefined {
  return getEventByIdFromSchedule(id);
}

/**
 * Main hook for accessing and filtering events
 */
export function useEvents(filters?: Partial<FilterState>) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Get all events from bundled data
  const allEvents = useMemo(() => getAllEvents(), []);

  // Apply filters
  const events = useMemo(() => {
    const filterState: FilterState = {
      sport: filters?.sport ?? null,
      venue: filters?.venue ?? null,
      date: filters?.date ?? null,
      country: filters?.country ?? null,
      medalsOnly: filters?.medalsOnly ?? false,
    };

    return filterEvents(allEvents, filterState, {
      includeTraining: false,
      includePast: false,
    });
  }, [allEvents, filters?.sport, filters?.venue, filters?.date, filters?.country, filters?.medalsOnly]);

  // Simulate initial load (for consistent UX)
  useEffect(() => {
    const timer = setTimeout(() => {
      setLoading(false);
    }, 100);
    return () => clearTimeout(timer);
  }, []);

  // Refresh is a no-op for bundled data (but keeps API compatibility)
  const refresh = useCallback(async () => {
    setLoading(true);
    setError(null);
    // Bundled data doesn't need refresh, but simulate for UX
    await new Promise((resolve) => setTimeout(resolve, 200));
    setLoading(false);
  }, []);

  return {
    events,
    allEvents,
    loading,
    error,
    refresh,
  };
}

/**
 * Hook for a single event by ID
 */
export function useEvent(id: string) {
  const [event, setEvent] = useState<Event | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const found = getEventByIdFromSchedule(id);
    setEvent(found ?? null);
    setLoading(false);
  }, [id]);

  return { event, loading };
}

/**
 * Hook for upcoming events
 */
export function useUpcomingEvents(limit?: number) {
  const events = useMemo(() => getUpcomingEvents(limit), [limit]);
  return { events, loading: false };
}

/**
 * Hook for live events (currently happening)
 */
export function useLiveEvents() {
  const [events, setEvents] = useState<Event[]>([]);

  useEffect(() => {
    // Initial check
    setEvents(getLiveEvents());

    // Refresh every 30 seconds to check for live events
    const interval = setInterval(() => {
      setEvents(getLiveEvents());
    }, 30000);

    return () => clearInterval(interval);
  }, []);

  return { events, loading: false };
}

/**
 * Hook for events on a specific date
 */
export function useEventsForDate(date: string) {
  const events = useMemo(() => getEventsForDate(date), [date]);
  return { events, loading: false };
}

/**
 * Hook for events by sport
 */
export function useEventsBySport(sportCode: SportCode) {
  const events = useMemo(() => getEventsBySport(sportCode), [sportCode]);
  return { events, loading: false };
}

/**
 * Hook for medal events only
 */
export function useMedalEvents() {
  const events = useMemo(() => getMedalEvents(), []);
  return { events, loading: false };
}

/**
 * Hook for searching events
 */
export function useEventSearch(query: string) {
  const events = useMemo(() => {
    if (!query || query.length < 2) return [];
    return searchEvents(query);
  }, [query]);

  return { events, loading: false };
}

/**
 * Hook for filter options (disciplines, venues, dates, countries)
 */
export function useFilterOptions() {
  const disciplines = useMemo(() => getDisciplines(), []);
  const venues = useMemo(() => getVenues(), []);
  const dates = useMemo(() => getDates(), []);
  const countries = useMemo(() => getCountries(), []);

  return { disciplines, venues, dates, countries };
}

// ============================================
// Session hooks (events grouped by session_code)
// ============================================

/**
 * Main hook for accessing and filtering sessions
 */
export function useSessions(filters?: Partial<FilterState>) {
  const [loading, setLoading] = useState(true);

  // Get all sessions from bundled data
  const allSessions = useMemo(() => getAllSessions(), []);

  // Apply filters
  const sessions = useMemo(() => {
    const filterState: FilterState = {
      sport: filters?.sport ?? null,
      venue: filters?.venue ?? null,
      date: filters?.date ?? null,
      country: filters?.country ?? null,
      medalsOnly: filters?.medalsOnly ?? false,
    };

    return filterSessions(allSessions, filterState, {
      includeTraining: false,
      includePast: false,
    });
  }, [allSessions, filters?.sport, filters?.venue, filters?.date, filters?.country, filters?.medalsOnly]);

  // Simulate initial load
  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 100);
    return () => clearTimeout(timer);
  }, []);

  // Refresh is a no-op for bundled data
  const refresh = useCallback(async () => {
    setLoading(true);
    await new Promise((resolve) => setTimeout(resolve, 200));
    setLoading(false);
  }, []);

  return {
    sessions,
    allSessions,
    loading,
    refresh,
  };
}

/**
 * Hook for a single session by session_code
 */
export function useSession(sessionCode: string) {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const found = getSessionByCode(sessionCode);
    setSession(found ?? null);
    setLoading(false);
  }, [sessionCode]);

  return { session, loading };
}
