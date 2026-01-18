/**
 * Services barrel export
 */

export { api } from './api';
export * from './schedule';
export * from './articles';
export type {
  DeviceRegisterRequest,
  DeviceResponse,
  FavoritesSyncRequest,
  FavoritesSyncResponse,
  EventListResponse,
  ApiError,
} from './api';

export {
  initNotifications,
  requestPermissions,
  areNotificationsEnabled,
  getPushToken,
  scheduleEventReminder,
  cancelEventReminder,
  rescheduleEventReminder,
  scheduleAllReminders,
  cancelAllReminders,
  getScheduledEventIds,
  hasScheduledReminder,
  cleanupExpiredNotifications,
  addNotificationResponseListener,
} from './notifications';
