import { useState, useEffect, useCallback } from 'react';
import type { Event } from '../types';

// Mock events data - will be replaced with API calls
// Using current dates for testing (Dec 28, 2025)
const MOCK_EVENTS: Event[] = [
  // === LIVE NOW ===
  {
    event_id: 'IHO-001',
    sport: 'Ice Hockey',
    sport_code: 'IHO',
    event_name: "Men's Preliminary Round - USA vs Canada",
    date: '2025-12-28',
    time: '15:30',
    venue: 'Milano Hockey Arena',
    venue_city: 'Milano',
    status: 'live',
    session_code: 'IHO01',
    is_medal_event: false,
  },
  // === TODAY (Dec 28) - This afternoon/evening ===
  {
    event_id: 'FSK-001',
    sport: 'Figure Skating',
    sport_code: 'FSK',
    event_name: 'Ice Dance - Short Dance',
    date: '2025-12-28',
    time: '17:00',
    venue: 'Milano Santa Giulia Arena',
    venue_city: 'Milano',
    status: 'scheduled',
    session_code: 'FSK01',
    is_medal_event: false,
  },
  {
    event_id: 'CUR-001',
    sport: 'Curling',
    sport_code: 'CUR',
    event_name: "Mixed Doubles Round Robin",
    date: '2025-12-28',
    time: '18:30',
    venue: 'Cortina Curling Centre',
    venue_city: 'Cortina d\'Ampezzo',
    status: 'scheduled',
    session_code: 'CUR01',
    is_medal_event: false,
  },
  {
    event_id: 'IHO-002',
    sport: 'Ice Hockey',
    sport_code: 'IHO',
    event_name: "Women's Preliminary Round - Sweden vs Finland",
    date: '2025-12-28',
    time: '20:00',
    venue: 'Milano Hockey Arena',
    venue_city: 'Milano',
    status: 'scheduled',
    session_code: 'IHO02',
    is_medal_event: false,
  },
  // === TOMORROW (Dec 29) ===
  {
    event_id: 'ALP-001',
    sport: 'Alpine Skiing',
    sport_code: 'ALP',
    event_name: "Men's Downhill - Training Run",
    date: '2025-12-29',
    time: '10:00',
    venue: 'Stelvio Ski Centre',
    venue_city: 'Bormio',
    status: 'scheduled',
    session_code: 'ALP01',
    is_medal_event: false,
  },
  {
    event_id: 'BTH-001',
    sport: 'Biathlon',
    sport_code: 'BTH',
    event_name: "Mixed Relay",
    date: '2025-12-29',
    time: '14:30',
    venue: 'Anterselva Biathlon Arena',
    venue_city: 'Anterselva',
    status: 'scheduled',
    session_code: 'BTH01',
    is_medal_event: true,
  },
  {
    event_id: 'FSK-002',
    sport: 'Figure Skating',
    sport_code: 'FSK',
    event_name: 'Ice Dance - Free Dance',
    date: '2025-12-29',
    time: '19:00',
    venue: 'Milano Santa Giulia Arena',
    venue_city: 'Milano',
    status: 'scheduled',
    session_code: 'FSK02',
    is_medal_event: true,
  },
  // === UPCOMING (Dec 30+) ===
  {
    event_id: 'ALP-002',
    sport: 'Alpine Skiing',
    sport_code: 'ALP',
    event_name: "Men's Downhill",
    date: '2025-12-30',
    time: '11:00',
    venue: 'Stelvio Ski Centre',
    venue_city: 'Bormio',
    status: 'scheduled',
    session_code: 'ALP02',
    is_medal_event: true,
  },
  {
    event_id: 'SSK-001',
    sport: 'Speed Skating',
    sport_code: 'SSK',
    event_name: "Women's 3000m",
    date: '2025-12-30',
    time: '16:00',
    venue: 'Baselga Ice Oval',
    venue_city: 'Baselga di Piné',
    status: 'scheduled',
    session_code: 'SSK01',
    is_medal_event: true,
  },
  {
    event_id: 'SJP-001',
    sport: 'Ski Jumping',
    sport_code: 'SJP',
    event_name: "Men's Normal Hill Individual",
    date: '2025-12-31',
    time: '17:00',
    venue: 'Predazzo Ski Jump',
    venue_city: 'Predazzo',
    status: 'scheduled',
    session_code: 'SJP01',
    is_medal_event: true,
  },
  {
    event_id: 'BOB-001',
    sport: 'Bobsled',
    sport_code: 'BOB',
    event_name: "Two-Man Bobsled - Heat 1 & 2",
    date: '2026-01-02',
    time: '09:30',
    venue: 'Cortina Sliding Centre',
    venue_city: 'Cortina d\'Ampezzo',
    status: 'scheduled',
    session_code: 'BOB01',
    is_medal_event: false,
  },
];

// Simple in-memory store
let eventsCache: Event[] = MOCK_EVENTS;

export function getAllEvents(): Event[] {
  return eventsCache;
}

export function getEventById(id: string): Event | undefined {
  return eventsCache.find((e) => e.event_id === id);
}

export function useEvents() {
  const [events, setEvents] = useState<Event[]>(eventsCache);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const refresh = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      // TODO: Fetch from API
      // const response = await fetch('https://api.neve26.com/api/v1/events');
      // const data = await response.json();
      // eventsCache = data;
      // setEvents(data);

      // For now, just use mock data
      await new Promise((resolve) => setTimeout(resolve, 500));
      setEvents(eventsCache);
    } catch (err) {
      setError('Failed to load events');
      console.error('Failed to fetch events:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, []);

  return {
    events,
    loading,
    error,
    refresh,
  };
}

export function useEvent(id: string) {
  const [event, setEvent] = useState<Event | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simulated loading
    const found = getEventById(id);
    setEvent(found ?? null);
    setLoading(false);
  }, [id]);

  return { event, loading };
}
