import { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';

import { colors, darkColors, spacing, sizing, typography, presets } from '../../theme';
import type { Event } from '../../types';

const FAVORITES_KEY = '@neve26_favorites';

function EventCard({ event, onPress, onRemove }: {
  event: Event;
  onPress: () => void;
  onRemove: () => void;
}) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const sportColor = colors.sportColors[event.sport_code] ?? theme.primary;
  const isLive = event.status === 'live';

  return (
    <TouchableOpacity
      style={[
        styles.eventCard,
        {
          backgroundColor: theme.surface,
          borderLeftColor: sportColor,
        },
        presets.cardShadow,
      ]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      <View style={styles.cardContent}>
        <View style={styles.eventInfo}>
          <View style={styles.eventHeader}>
            <Text style={[styles.sportName, { color: sportColor }]}>
              {event.sport}
            </Text>
            {isLive && (
              <View style={[styles.liveBadge, { backgroundColor: colors.rossoCorsa }]}>
                <Text style={styles.liveText}>{t('schedule.liveNow')}</Text>
              </View>
            )}
          </View>

          <Text style={[styles.eventName, { color: theme.text }]} numberOfLines={2}>
            {event.event_name}
          </Text>

          <View style={styles.eventDetails}>
            <Text style={[styles.eventDate, { color: theme.textSecondary }]}>
              {event.date} • {event.time ?? '--:--'}
            </Text>
            <Text style={[styles.eventVenue, { color: theme.textMuted }]}>
              {event.venue_city}
            </Text>
          </View>
        </View>

        <TouchableOpacity
          style={styles.removeButton}
          onPress={onRemove}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <Text style={styles.heartIcon}>❤️</Text>
        </TouchableOpacity>
      </View>
    </TouchableOpacity>
  );
}

export default function FavoritesScreen() {
  const { t } = useTranslation();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const [favorites, setFavorites] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);

  const loadFavorites = useCallback(async () => {
    try {
      const stored = await AsyncStorage.getItem(FAVORITES_KEY);
      if (stored) {
        setFavorites(JSON.parse(stored));
      }
    } catch (error) {
      console.error('Failed to load favorites:', error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadFavorites();
  }, [loadFavorites]);

  const handleRemoveFavorite = async (eventId: string) => {
    try {
      const updated = favorites.filter((e) => e.event_id !== eventId);
      setFavorites(updated);
      await AsyncStorage.setItem(FAVORITES_KEY, JSON.stringify(updated));
    } catch (error) {
      console.error('Failed to remove favorite:', error);
    }
  };

  const handleEventPress = (eventId: string) => {
    router.push(`/event/${eventId}`);
  };

  if (loading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right']}>
        <View style={styles.loadingContainer}>
          <Text style={[styles.loadingText, { color: theme.textMuted }]}>
            {t('common.loading')}
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right']}>
      <FlatList
        data={favorites}
        renderItem={({ item }) => (
          <EventCard
            event={item}
            onPress={() => handleEventPress(item.event_id)}
            onRemove={() => handleRemoveFavorite(item.event_id)}
          />
        )}
        keyExtractor={(item) => item.event_id}
        contentContainerStyle={[
          styles.listContent,
          favorites.length === 0 && styles.emptyList,
        ]}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyIcon}>🤍</Text>
            <Text style={[styles.emptyTitle, { color: theme.text }]}>
              {t('favorites.empty')}
            </Text>
            <Text style={[styles.emptyHint, { color: theme.textMuted }]}>
              {t('favorites.emptyHint')}
            </Text>
          </View>
        }
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  listContent: {
    padding: spacing.md,
    paddingBottom: spacing.xxxl,
  },
  emptyList: {
    flex: 1,
  },
  eventCard: {
    padding: spacing.md,
    marginBottom: spacing.md,
    borderRadius: sizing.radius.large,
    borderLeftWidth: 4,
  },
  cardContent: {
    flexDirection: 'row',
    alignItems: 'flex-start',
  },
  eventInfo: {
    flex: 1,
  },
  eventHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
    gap: spacing.sm,
  },
  sportName: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.bold,
  },
  liveBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  liveText: {
    color: colors.snowWhite,
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.bold,
  },
  eventName: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.sm,
    lineHeight: typography.fontSize.lg * typography.lineHeight.normal,
  },
  eventDetails: {
    gap: spacing.xs,
  },
  eventDate: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
  },
  eventVenue: {
    fontSize: typography.fontSize.sm,
  },
  removeButton: {
    padding: spacing.sm,
    marginLeft: spacing.sm,
  },
  heartIcon: {
    fontSize: 24,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    fontSize: typography.fontSize.lg,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: spacing.xxl,
  },
  emptyIcon: {
    fontSize: 64,
    marginBottom: spacing.lg,
  },
  emptyTitle: {
    fontSize: typography.fontSize.xxl,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.sm,
    textAlign: 'center',
  },
  emptyHint: {
    fontSize: typography.fontSize.md,
    textAlign: 'center',
    lineHeight: typography.fontSize.md * typography.lineHeight.relaxed,
  },
});
