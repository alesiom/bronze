import { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Pressable,
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
import type { ViewStyle } from 'react-native';
import { useEvent } from '../../hooks/useEvents';
import { SportIcon, Icons } from '../../components';
import type { Event } from '../../types';

const FAVORITES_KEY = '@neve26_favorites';

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
  opensUp = false,
}: {
  title: string;
  icon: React.ReactNode;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'danger';
  opensUp?: boolean;  // Shows chevron-up to indicate overlay opens from below
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const bgColor = {
    primary: colors.primary,
    secondary: isDark ? theme.surfaceAlt : colors.surfaceAlt,
    danger: colors.rossoCorsa,
  }[variant];

  // Shadow color matches button color (lighter for secondary)
  const shadowColor = {
    primary: colors.primary,
    secondary: isDark ? theme.textMuted : '#888',
    danger: colors.rossoCorsa,
  }[variant];

  const textColor = variant === 'secondary' ? theme.text : colors.snowWhite;

  const getButtonStyle = (pressed: boolean) => ({
    backgroundColor: bgColor,
    borderColor: isDark ? theme.border : bgColor,
    // When pressed: move into the shadow hole, remove shadow
    ...(pressed ? {
      transform: [{ translateX: 4 }, { translateY: 4 }],
    } : {
      shadowColor: shadowColor,
      shadowOffset: { width: 4, height: 4 },
      shadowOpacity: 0.8,
      shadowRadius: 0,
      elevation: 6,
    }),
  });

  return (
    <Pressable onPress={onPress}>
      {({ pressed }) => (
        <View style={[styles.bigButton, getButtonStyle(pressed)]}>
          {icon}
          <Text style={[styles.buttonText, { color: textColor }]}>{title}</Text>
          {opensUp && (
            <Icons.ChevronUp size={18} color={textColor} />
          )}
        </View>
      )}
    </Pressable>
  );
}

function DetailRow({ label, value }: { label: string; value: string }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={[styles.detailRow, { borderBottomColor: theme.border }]}>
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

  const { event, loading } = useEvent(id ?? '');
  const [isFavorite, setIsFavorite] = useState(false);

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
    checkFavorite();
  }, [checkFavorite]);

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
    const query = encodeURIComponent(`${event.venue}, ${event.venue_city}, Italy`);

    // Use Google Maps web URL - works universally and opens in Google Maps app if installed
    const webUrl = coords
      ? `https://www.google.com/maps/search/?api=1&query=${coords.lat},${coords.lng}`
      : `https://www.google.com/maps/search/?api=1&query=${query}`;

    Linking.openURL(webUrl);
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

  const sportColor = theme.sportColors[event.sport_code] ?? theme.primary;
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
                <Icons.Medal size={16} color={colors.snowWhite} />
                <Text style={styles.medalText}>{t('event.medal')}</Text>
              </View>
            )}
            <View style={[styles.statusBadge, event.status === 'live' && styles.liveBadge]}>
              <Text style={styles.statusText}>{statusLabel}</Text>
            </View>
          </View>
        </View>

        {/* Details */}
        <View style={[styles.detailsCard, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <DetailRow label={t('event.time')} value={`${event.date} • ${event.time ?? '--:--'}`} />
          <DetailRow label={t('event.venue')} value={event.venue} />
          <DetailRow label={t('event.sport')} value={event.sport} />
        </View>

        {/* Actions */}
        <View style={styles.actions}>
          <BigButton
            title={isFavorite ? t('event.removeFromFavorites') : t('event.addToFavorites')}
            icon={<Icons.Heart size={22} color={colors.snowWhite} />}
            onPress={handleToggleFavorite}
            variant={isFavorite ? 'danger' : 'primary'}
          />
          <BigButton
            title={t('event.share')}
            icon={<Icons.Share size={22} color={theme.text} />}
            onPress={handleShare}
            variant="secondary"
            opensUp
          />
          <BigButton
            title={t('event.openMap')}
            icon={<Icons.Map size={22} color={theme.text} />}
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
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
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
    borderWidth: 2,
    paddingHorizontal: spacing.xl,
    gap: spacing.sm,
  },
  buttonText: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
  },
});
