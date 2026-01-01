/**
 * Human-readable date/time formatting utilities
 * Makes event times more tangible: "tomorrow, 11:00" instead of "2026-02-07 11:00"
 */

import type { TFunction } from 'i18next';

interface FormatOptions {
  t: TFunction;
  now?: Date;
}

/**
 * Get the time of day category
 */
function getTimeOfDay(hour: number): 'morning' | 'afternoon' | 'evening' | 'night' {
  if (hour >= 5 && hour < 12) return 'morning';
  if (hour >= 12 && hour < 17) return 'afternoon';
  if (hour >= 17 && hour < 21) return 'evening';
  return 'night';
}

/**
 * Format time as HH:MM
 * Accepts either HH:MM or full ISO datetime
 */
function formatTime(time: string | null): string {
  if (!time) return '--:--';

  // If it's a full ISO datetime (contains 'T'), extract the time part
  if (time.includes('T')) {
    const timePart = time.split('T')[1];
    return timePart ? timePart.substring(0, 5) : '--:--';
  }

  return time;
}

/**
 * Extract time (HH:MM) from various formats
 */
export function extractTime(timeOrDatetime: string | null): string | null {
  if (!timeOrDatetime) return null;

  // If it's a full ISO datetime (contains 'T'), extract the time part
  if (timeOrDatetime.includes('T')) {
    const timePart = timeOrDatetime.split('T')[1];
    return timePart ? timePart.substring(0, 5) : null;
  }

  return timeOrDatetime;
}

/**
 * Parse a date string (YYYY-MM-DD) into a local Date object
 */
function parseLocalDate(dateStr: string): Date {
  const [year, month, day] = dateStr.split('-').map(Number);
  return new Date(year, month - 1, day);
}

/**
 * Calculate days difference between two dates (ignoring time)
 */
function getDaysDifference(date1: Date, date2: Date): number {
  const d1 = new Date(date1.getFullYear(), date1.getMonth(), date1.getDate());
  const d2 = new Date(date2.getFullYear(), date2.getMonth(), date2.getDate());
  return Math.round((d2.getTime() - d1.getTime()) / (1000 * 60 * 60 * 24));
}

/**
 * Format a date string (YYYY-MM-DD) and optional time into human-readable format
 *
 * Examples:
 * - "in 30 minutes" (if within the hour)
 * - "this afternoon, 14:00" (if today)
 * - "tomorrow, 11:00"
 * - "Saturday, 11:00" (if within 7 days)
 * - "Feb 6, 11:00" (if further away)
 */
export function formatHumanDateTime(
  dateStr: string,
  time: string | null,
  { t, now = new Date() }: FormatOptions
): string {
  const eventDate = parseLocalDate(dateStr);
  const daysDiff = getDaysDifference(now, eventDate);
  const timeStr = formatTime(time);

  // Parse event time (handle both HH:MM and ISO datetime formats)
  const extractedTime = extractTime(time) ?? '00:00';
  const [hours, minutes] = extractedTime.split(':').map(Number);
  const eventDateTime = new Date(eventDate);
  eventDateTime.setHours(hours, minutes, 0, 0);

  // Calculate minutes until event
  const minutesUntil = Math.round((eventDateTime.getTime() - now.getTime()) / (1000 * 60));

  // Today
  if (daysDiff === 0) {
    // Already passed today
    if (minutesUntil < 0) {
      return t('humanTime.today', { time: timeStr });
    }

    // Within the next hour - show relative + actual time
    if (minutesUntil <= 60 && minutesUntil > 0) {
      return t('humanTime.inMinutesAt', { count: minutesUntil, time: timeStr });
    }

    // Within the next few hours - show relative + actual time
    const hoursUntil = Math.round(minutesUntil / 60);
    if (hoursUntil <= 4) {
      return t('humanTime.inHoursAt', { count: hoursUntil, time: timeStr });
    }

    // Later today - use time of day description
    const timeOfDay = getTimeOfDay(hours);
    return t(`humanTime.this${timeOfDay.charAt(0).toUpperCase() + timeOfDay.slice(1)}`, { time: timeStr });
  }

  // Tomorrow
  if (daysDiff === 1) {
    return t('humanTime.tomorrow', { time: timeStr });
  }

  // Within the next 7 days - show day name
  if (daysDiff > 1 && daysDiff <= 7) {
    const dayName = eventDate.toLocaleDateString('en-US', { weekday: 'long' });
    // Use translation for day names
    return t('humanTime.onDay', { day: t(`days.${dayName.toLowerCase()}`), time: timeStr });
  }

  // Further away - show date
  const month = eventDate.toLocaleDateString('en-US', { month: 'short' });
  const day = eventDate.getDate();
  return t('humanTime.onDate', { month, day, time: timeStr });
}

/**
 * Get a short relative time description (for compact displays)
 * Examples: "now", "2h", "tomorrow", "Sat", "Feb 6"
 */
export function formatShortRelativeTime(
  dateStr: string,
  time: string | null,
  { t, now = new Date() }: FormatOptions
): string {
  const eventDate = parseLocalDate(dateStr);
  const daysDiff = getDaysDifference(now, eventDate);

  // Parse event time (handle both HH:MM and ISO datetime formats)
  const extractedTime = extractTime(time) ?? '00:00';
  const [hours, minutes] = extractedTime.split(':').map(Number);
  const eventDateTime = new Date(eventDate);
  eventDateTime.setHours(hours, minutes, 0, 0);

  const minutesUntil = Math.round((eventDateTime.getTime() - now.getTime()) / (1000 * 60));

  if (daysDiff === 0) {
    if (minutesUntil <= 0) return t('humanTime.now');
    if (minutesUntil <= 60) return t('humanTime.minShort', { count: minutesUntil });
    const hoursUntil = Math.round(minutesUntil / 60);
    if (hoursUntil <= 12) return t('humanTime.hourShort', { count: hoursUntil });
    return t('humanTime.todayShort');
  }

  if (daysDiff === 1) return t('humanTime.tomorrowShort');

  if (daysDiff <= 7) {
    const dayName = eventDate.toLocaleDateString('en-US', { weekday: 'short' });
    return dayName;
  }

  const month = eventDate.toLocaleDateString('en-US', { month: 'short' });
  const day = eventDate.getDate();
  return `${month} ${day}`;
}
