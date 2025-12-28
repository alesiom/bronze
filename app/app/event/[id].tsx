import { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Share,
  Linking,
  Platform,
  useColorScheme,
} from 'react-native';
import { useLocalSearchParams, useRouter, Stack } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';

import { colors, darkColors, spacing, sizing, typography, presets } from '../../theme';
import type { Event } from '../../types';

const FAVORITES_KEY = '@neve26_favorites';

// Mock event data - will be replaced with API call
const MOCK_EVENT: Event = {
  event_id: 'ALP-001',
  sport: 'Alpine Skiing',
  sport_code: 'ALP',
  event_name: "Men's Downhill",
  date: '2026-02-07',
  time: '11:00',
  venue: 'Stelvio Ski Centre',
  venue_city: 'Bormio',
  status: 'scheduled',
  session_code: 'ALP01',
  is_medal_event: true,
};

// Venue coordinates for maps
const VENUE_COORDINATES: Record<string, { lat: number; lng: number }> = {
  Bormio: { lat: 46.4681, lng: 10.3705 },
  'Cortina d\'Ampezzo': { lat: 46.5369, lng: 12.1356 },
  Milano: { lat: 45.4642, lng: 9.1900 },
  Anterselva: { lat: 46.8658, lng: 12.0650 },
  Livigno: { lat: 46.5385, lng: 10.1358 },
  Predazzo: { lat: 46.3136, lng: 11.6036 },
};

function BigButton({
  title,
  icon,
  onPress,
  variant = 'primary',
}: {
  title: string;
  icon: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'danger';
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const bgColor = {
    primary: colors.alpineGreen,
    secondary: isDark ? '#2A3A4A' : '#F0F0F0',
    danger: colors.rossoCorsa,
  }[variant];

  const textColor = variant === 'secondary' ? theme.text : colors.snowWhite;

  return (
    <TouchableOpacity
      style={[styles.bigButton, { backgroundColor: bgColor }]}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <Text style={styles.buttonIcon}>{icon}</Text>
      <Text style={[styles.buttonText, { color: textColor }]}>{title}</Text>
    </TouchableOpacity>
  );
}

function DetailRow({ label, value }: { label: string; value: string }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={[styles.detailRow, { borderBottomColor: isDark ? '#2A3A4A' : '#E5E5E5' }]}>
      <Text style={[styles.detailLabel, { color: theme.textMuted }]}>{label}</Text>
      <Text style={[styles.detailValue, { color: theme.text }]}>{value}</Text>
    </View>
  );
}

export default function EventDetailScreen() {
  const { t } = useTranslation();
  const router = useRouter();
  const { id } = useLocalSearchParams<{ id: string }>();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const [event, setEvent] = useState<Event | null>(null);
  const [isFavorite, setIsFavorite] = useState(false);
  const [loading, setLoading] = useState(true);

  const loadEvent = useCallback(async () => {
    // TODO: Fetch from API
    setEvent(MOCK_EVENT);
    setLoading(false);
  }, [id]);

  const checkFavorite = useCallback(async () => {
    try {
      const stored = await AsyncStorage.getItem(FAVORITES_KEY);
      if (stored) {
        const favorites: Event[] = JSON.parse(stored);
        setIsFavorite(favorites.some((e) => e.event_id === id));
      }
    } catch (error) {
      console.error('Failed to check favorite:', error);
    }
  }, [id]);

  useEffect(() => {
    loadEvent();
    checkFavorite();
  }, [loadEvent, checkFavorite]);

  const handleToggleFavorite = async () => {
    if (!event) return;

    try {
      const stored = await AsyncStorage.getItem(FAVORITES_KEY);
      let favorites: Event[] = stored ? JSON.parse(stored) : [];

      if (isFavorite) {
        favorites = favorites.filter((e) => e.event_id !== event.event_id);
      } else {
        favorites.push(event);
      }

      await AsyncStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites));
      setIsFavorite(!isFavorite);
    } catch (error) {
      console.error('Failed to toggle favorite:', error);
    }
  };

  const handleShare = async () => {
    if (!event) return;

    try {
      await Share.share({
        message: `${event.event_name} - ${event.sport}\n${event.date} at ${event.time}\n${event.venue}, ${event.venue_city}`,
        title: event.event_name,
      });
    } catch (error) {
      console.error('Failed to share:', error);
    }
  };

  const handleOpenMap = () => {
    if (!event) return;

    const coords = VENUE_COORDINATES[event.venue_city];
    if (!coords) {
      // Fallback to search
      const query = encodeURIComponent(`${event.venue}, ${event.venue_city}, Italy`);
      const url = Platform.select({
        ios: `maps:?q=${query}`,
        android: `geo:0,0?q=${query}`,
        default: `https://maps.google.com/?q=${query}`,
      });
      Linking.openURL(url);
      return;
    }

    const url = Platform.select({
      ios: `maps:${coords.lat},${coords.lng}?q=${encodeURIComponent(event.venue)}`,
      android: `geo:${coords.lat},${coords.lng}?q=${encodeURIComponent(event.venue)}`,
      default: `https://maps.google.com/?q=${coords.lat},${coords.lng}`,
    });

    Linking.openURL(url);
  };

  if (loading || !event) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]}>
        <Stack.Screen options={{ title: '' }} />
        <View style={styles.loadingContainer}>
          <Text style={[styles.loadingText, { color: theme.textMuted }]}>
            {t('common.loading')}
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  const sportColor = colors.sportColors[event.sport_code] ?? theme.primary;
  const statusLabel = t(`event.status.${event.status}`);

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['bottom']}>
      <Stack.Screen
        options={{
          title: '',
          headerStyle: { backgroundColor: sportColor },
        }}
      />

      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header */}
        <View style={[styles.header, { backgroundColor: sportColor }]}>
          <Text style={styles.sportName}>{event.sport}</Text>
          <Text style={styles.eventName}>{event.event_name}</Text>
          <View style={styles.badges}>
            {event.is_medal_event && (
              <View style={styles.medalBadge}>
                <Text style={styles.medalText}>🏅 {t('event.medal')}</Text>
              </View>
            )}
            <View style={[styles.statusBadge, event.status === 'live' && styles.liveBadge]}>
              <Text style={styles.statusText}>{statusLabel}</Text>
            </View>
          </View>
        </View>

        {/* Details */}
        <View style={[styles.detailsCard, { backgroundColor: theme.surface }, presets.cardShadow]}>
          <DetailRow label={t('event.time')} value={`${event.date} • ${event.time ?? '--:--'}`} />
          <DetailRow label={t('event.venue')} value={event.venue} />
          <DetailRow label={t('event.sport')} value={event.sport} />
        </View>

        {/* Actions */}
        <View style={styles.actions}>
          <BigButton
            title={isFavorite ? t('event.removeFromFavorites') : t('event.addToFavorites')}
            icon={isFavorite ? '❤️' : '🤍'}
            onPress={handleToggleFavorite}
            variant={isFavorite ? 'danger' : 'primary'}
          />
          <BigButton
            title={t('event.share')}
            icon="📤"
            onPress={handleShare}
            variant="secondary"
          />
          <BigButton
            title={t('event.openMap')}
            icon="🗺️"
            onPress={handleOpenMap}
            variant="secondary"
          />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    paddingBottom: spacing.xxxl,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    fontSize: typography.fontSize.lg,
  },
  header: {
    padding: spacing.xl,
    paddingTop: spacing.md,
  },
  sportName: {
    color: 'rgba(255,255,255,0.8)',
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
    marginBottom: spacing.xs,
  },
  eventName: {
    color: colors.snowWhite,
    fontSize: typography.fontSize.xxxl,
    fontWeight: typography.fontWeight.bold,
    lineHeight: typography.fontSize.xxxl * typography.lineHeight.tight,
    marginBottom: spacing.md,
  },
  badges: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  medalBadge: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  medalText: {
    color: colors.snowWhite,
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
  },
  statusBadge: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  liveBadge: {
    backgroundColor: colors.rossoCorsa,
  },
  statusText: {
    color: colors.snowWhite,
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
  },
  detailsCard: {
    margin: spacing.md,
    borderRadius: sizing.radius.large,
    overflow: 'hidden',
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.lg,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  detailLabel: {
    fontSize: typography.fontSize.md,
  },
  detailValue: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
    textAlign: 'right',
    flex: 1,
    marginLeft: spacing.md,
  },
  actions: {
    padding: spacing.md,
    gap: spacing.md,
  },
  bigButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: sizing.button.large,
    borderRadius: sizing.radius.medium,
    paddingHorizontal: spacing.xl,
    gap: spacing.sm,
  },
  buttonIcon: {
    fontSize: 24,
  },
  buttonText: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
  },
});
