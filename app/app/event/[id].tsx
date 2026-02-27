import { View, Text, StyleSheet, ScrollView, Pressable, Share, Linking, useColorScheme } from 'react-native';
import { useLocalSearchParams, useRouter, Stack } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';

import { colors, darkColors, spacing, sizing, typography, presets, getContrastText } from '../../theme';
import type { ViewStyle } from 'react-native';
import { useEvent } from '../../hooks/useEvents';
import { useFavorites } from '../../hooks';
import { SportIcon, Icons } from '../../components';
import { extractTime } from '../../utils';

// Venue coordinates by venue name (for maps)
const VENUE_COORDINATES: Record<string, { lat: number; lng: number }> = {
  'Stelvio Ski Centre': { lat: 46.4681, lng: 10.3705 },
  'Tofane Alpine Skiing Centre': { lat: 46.5369, lng: 12.1356 },
  'Cortina Curling Olympic Stadium': { lat: 46.5400, lng: 12.1400 },
  'Cortina Sliding Centre': { lat: 46.5200, lng: 12.1200 },
  'Anterselva Biathlon Arena': { lat: 46.8658, lng: 12.0650 },
  'Milano Ice Skating Arena': { lat: 45.4642, lng: 9.1900 },
  'Milano Speed Skating Stadium': { lat: 45.4642, lng: 9.1900 },
  'Milano Santagiulia Ice Hockey Arena': { lat: 45.4600, lng: 9.2400 },
  'Milano Rho Ice Hockey Arena': { lat: 45.5200, lng: 9.0900 },
  'Livigno Snow Park': { lat: 46.5385, lng: 10.1358 },
  'Livigno Aerials & Moguls Park': { lat: 46.5385, lng: 10.1358 },
  'Predazzo Ski Jumping Stadium': { lat: 46.3136, lng: 11.6036 },
  'Tesero Cross-Country Skiing Stadium': { lat: 46.2900, lng: 11.5100 },
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
    danger: colors.error,
  }[variant];

  // Shadow color matches button color (lighter for secondary)
  const shadowColor = {
    primary: colors.primary,
    secondary: isDark ? theme.textMuted : '#888',
    danger: colors.error,
  }[variant];

  const textColor = variant === 'secondary' ? theme.text : '#FFFFFF';

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

  // Use centralized favorites hook for consistent state across all views
  const { isFavorite, toggleFavorite } = useFavorites();
  const isEventFavorite = isFavorite(id ?? '');

  const handleToggleFavorite = async () => {
    if (!event) return;
    await toggleFavorite(event);
  };

  const handleShare = async () => {
    if (!event) return;

    try {
      const timeStr = extractTime(event.start_time) ?? '--:--';
      await Share.share({
        message: `${event.event_name} - ${event.sport}\n${event.date} at ${timeStr}\n${event.venue ?? event.location}`,
        title: event.event_name,
      });
    } catch (error) {
      console.error('Failed to share:', error);
    }
  };

  const handleOpenMap = () => {
    if (!event) return;

    const venueName = event.venue ?? event.location;
    const coords = VENUE_COORDINATES[venueName];
    const query = encodeURIComponent(`${venueName}, Italy`);

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

  // WCAG AAA: Get appropriate text color for sport color background
  const headerTextColor = getContrastText(sportColor);
  const headerTextMuted = headerTextColor === '#FFFFFF' ? 'rgba(255,255,255,0.8)' : 'rgba(13,27,42,0.7)';
  const badgeBgColor = headerTextColor === '#FFFFFF' ? 'rgba(255,255,255,0.2)' : 'rgba(13,27,42,0.15)';

  // For team sports, show "Team1 vs Team2" as title
  const displayName = event.match?.team1 && event.match?.team2
    ? `${event.match.team1.description} vs ${event.match.team2.description}`
    : event.event_name;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['bottom']}>
      <Stack.Screen
        options={{
          title: '',
          headerStyle: { backgroundColor: sportColor },
          headerTintColor: headerTextColor,
        }}
      />

      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header */}
        <View style={[styles.header, { backgroundColor: sportColor }]}>
          <Text style={[styles.sportName, { color: headerTextMuted }]}>{event.sport}</Text>
          <Text style={[styles.eventName, { color: headerTextColor }]}>{displayName}</Text>
          <View style={styles.badges}>
            {event.is_medal_event && (
              <View style={[styles.medalBadge, { backgroundColor: badgeBgColor }]}>
                <Icons.Medal size={16} color={headerTextColor} />
                <Text style={[styles.medalText, { color: headerTextColor }]}>{t('event.medal')}</Text>
              </View>
            )}
            <View style={[styles.statusBadge, { backgroundColor: badgeBgColor }, event.status === 'live' && styles.liveBadge]}>
              <Text style={[styles.statusText, { color: event.status === 'live' ? '#FFFFFF' : headerTextColor }]}>{statusLabel}</Text>
            </View>
          </View>
        </View>

        {/* Details */}
        <View style={[styles.detailsCard, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <DetailRow label={t('event.time')} value={`${event.date} • ${extractTime(event.start_time) ?? '--:--'}`} />
          <DetailRow label={t('event.venue')} value={event.venue ?? event.location} />
          <DetailRow label={t('event.sport')} value={event.sport} />
          {event.match && (
            <DetailRow label={t('event.round')} value={event.event_name} />
          )}
        </View>

        {/* Actions */}
        <View style={styles.actions}>
          <BigButton
            title={isEventFavorite ? t('event.removeFromFavorites') : t('event.addToFavorites')}
            icon={<Icons.Heart size={22} color={'#FFFFFF'} />}
            onPress={handleToggleFavorite}
            variant={isEventFavorite ? 'danger' : 'primary'}
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
    color: '#FFFFFF',
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
    color: '#FFFFFF',
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
    backgroundColor: colors.error,
  },
  statusText: {
    color: '#FFFFFF',
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
