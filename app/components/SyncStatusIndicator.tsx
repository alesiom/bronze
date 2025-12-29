/**
 * Sync status indicator component
 * Shows connection status and last sync time
 */

import { View, Text, StyleSheet, Pressable, useColorScheme, ActivityIndicator } from 'react-native';
import { useTranslation } from 'react-i18next';

import { colors, darkColors, spacing, typography, sizing } from '../theme';
import { useNetworkStatus, useFavorites, formatRelativeTime } from '../hooks';
import { Icons } from './Icons';

interface SyncStatusIndicatorProps {
  compact?: boolean;
  onPress?: () => void;
}

export function SyncStatusIndicator({ compact = false, onPress }: SyncStatusIndicatorProps) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const { isConnected, isServerReachable, lastSyncTime } = useNetworkStatus();
  const { syncing, pendingSync, syncToServer } = useFavorites();

  const isOnline = isConnected && isServerReachable;

  // Determine status
  let statusColor: string = theme.textMuted;
  let statusText = t('sync.offline');
  let StatusIcon = Icons.WifiOff;

  if (syncing) {
    statusColor = theme.primary;
    statusText = t('sync.syncing');
    StatusIcon = Icons.RefreshCw;
  } else if (isOnline) {
    if (pendingSync) {
      statusColor = theme.warning;
      statusText = t('sync.pendingSync');
      StatusIcon = Icons.CloudOff;
    } else {
      statusColor = theme.success;
      statusText = t('sync.synced');
      StatusIcon = Icons.CheckCircle;
    }
  }

  const handlePress = () => {
    if (onPress) {
      onPress();
    } else if (isOnline && pendingSync && !syncing) {
      syncToServer();
    }
  };

  const lastSyncText = lastSyncTime
    ? t('sync.lastSync', { time: formatRelativeTime(lastSyncTime, t) })
    : t('sync.never');

  if (compact) {
    return (
      <Pressable onPress={handlePress} style={styles.compactContainer}>
        {syncing ? (
          <ActivityIndicator size="small" color={statusColor} />
        ) : (
          <StatusIcon size={16} color={statusColor} />
        )}
      </Pressable>
    );
  }

  return (
    <Pressable
      onPress={handlePress}
      style={({ pressed }) => [
        styles.container,
        { backgroundColor: theme.surface },
        pressed && styles.pressed,
      ]}
    >
      <View style={styles.iconContainer}>
        {syncing ? (
          <ActivityIndicator size="small" color={statusColor} />
        ) : (
          <StatusIcon size={20} color={statusColor} />
        )}
      </View>

      <View style={styles.textContainer}>
        <Text style={[styles.statusText, { color: statusColor }]}>
          {statusText}
        </Text>
        <Text style={[styles.lastSyncText, { color: theme.textMuted }]}>
          {lastSyncText}
        </Text>
      </View>

      {isOnline && pendingSync && !syncing && (
        <View style={styles.syncHint}>
          <Text style={[styles.syncHintText, { color: theme.textSecondary }]}>
            {t('sync.tapToSync')}
          </Text>
        </View>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.md,
    borderRadius: sizing.radius.medium,
    gap: spacing.sm,
  },
  pressed: {
    opacity: 0.7,
  },
  compactContainer: {
    padding: spacing.xs,
  },
  iconContainer: {
    width: 24,
    height: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  textContainer: {
    flex: 1,
  },
  statusText: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
  },
  lastSyncText: {
    fontSize: typography.fontSize.sm,
    marginTop: 2,
  },
  syncHint: {
    marginLeft: spacing.sm,
  },
  syncHintText: {
    fontSize: typography.fontSize.sm,
    fontStyle: 'italic',
  },
});
