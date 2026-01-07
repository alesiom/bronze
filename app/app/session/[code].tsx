import { View, Text, StyleSheet, ScrollView, Pressable, Share, Linking, useColorScheme } from 'react-native';
import { useLocalSearchParams, useRouter, Stack } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';

import { colors, darkColors, spacing, sizing, typography, presets, getContrastText } from '../../theme';
import type { ViewStyle } from 'react-native';
import { useSession } from '../../hooks/useEvents';
import { useFavorites } from '../../hooks';
import { SportIcon, Icons, MatchBadges } from '../../components';
import { extractTime } from '../../utils';
import type { MatchInfo } from '../../types';

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

// NOC (3-letter Olympic) to ISO 3166-1 alpha-2 (2-letter) mapping for flags
const NOC_TO_ISO: Record<string, string> = {
  AUS: 'AU', AUT: 'AT', BEL: 'BE', BLR: 'BY', BRA: 'BR',
  CAN: 'CA', CHN: 'CN', CRO: 'HR', CZE: 'CZ', DEN: 'DK',
  EST: 'EE', FIN: 'FI', FRA: 'FR', GBR: 'GB', GER: 'DE',
  HUN: 'HU', ITA: 'IT', JPN: 'JP', KAZ: 'KZ', KOR: 'KR',
  LAT: 'LV', NED: 'NL', NOR: 'NO', NZL: 'NZ', POL: 'PL',
  ROU: 'RO', RSA: 'ZA', RUS: 'RU', SLO: 'SI', SRB: 'RS',
  SUI: 'CH', SVK: 'SK', SWE: 'SE', UKR: 'UA', USA: 'US',
};

// Convert NOC code to flag emoji
function countryCodeToFlag(code: string): string {
  const upperCode = code.toUpperCase();
  const isoCode = NOC_TO_ISO[upperCode] || (upperCode.length === 2 ? upperCode : null);
  if (!isoCode) return '🏳️';

  const base = 0x1F1E6;
  try {
    return isoCode.split('').map((char) => String.fromCodePoint(base + char.charCodeAt(0) - 65)).join('');
  } catch {
    return '🏳️';
  }
}

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
  opensUp?: boolean;
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const bgColor = {
    primary: colors.primary,
    secondary: isDark ? theme.surfaceAlt : colors.surfaceAlt,
    danger: colors.rossoCorsa,
  }[variant];

  const shadowColor = {
    primary: colors.primary,
    secondary: isDark ? theme.textMuted : '#888',
    danger: colors.rossoCorsa,
  }[variant];

  const textColor = variant === 'secondary' ? theme.text : colors.snowWhite;

  const getButtonStyle = (pressed: boolean) => ({
    backgroundColor: bgColor,
    borderColor: isDark ? theme.border : bgColor,
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
          {opensUp && <Icons.ChevronUp size={18} color={textColor} />}
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

function MatchCard({ match, location }: { match: MatchInfo; location?: string }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  if (!match.team1 || !match.team2) return null;

  const flag1 = countryCodeToFlag(match.team1.teamCode);
  const flag2 = countryCodeToFlag(match.team2.teamCode);

  return (
    <View style={[styles.matchCard, { backgroundColor: theme.surfaceAlt }]}>
      <View style={styles.matchTeams}>
        <View style={styles.team}>
          <Text style={styles.flag}>{flag1}</Text>
          <Text style={[styles.teamName, { color: theme.text }]}>{match.team1.description}</Text>
        </View>
        <Text style={[styles.vsText, { color: theme.textMuted }]}>vs</Text>
        <View style={styles.team}>
          <Text style={styles.flag}>{flag2}</Text>
          <Text style={[styles.teamName, { color: theme.text }]}>{match.team2.description}</Text>
        </View>
      </View>
      {location && (
        <Text style={[styles.matchLocation, { color: theme.textMuted }]}>{location}</Text>
      )}
    </View>
  );
}

export default function SessionDetailScreen() {
  const { t } = useTranslation();
  const router = useRouter();
  const { code } = useLocalSearchParams<{ code: string }>();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const { session, loading } = useSession(code ?? '');

  // Use centralized favorites hook for consistent state across all views
  const { favorites, isFavorite, addFavorite, removeFavorite } = useFavorites();

  // Session is favorite if any of its events are in favorites
  const isSessionFavorite = session
    ? session.events.some((e) => isFavorite(e.event_id))
    : false;

  const handleToggleFavorite = async () => {
    if (!session) return;

    if (isSessionFavorite) {
      // Remove all events from this session
      for (const event of session.events) {
        await removeFavorite(event.event_id);
      }
    } else {
      // Add all events from this session
      for (const event of session.events) {
        if (!isFavorite(event.event_id)) {
          await addFavorite(event);
        }
      }
    }
  };

  const handleShare = async () => {
    if (!session) return;

    try {
      const timeStr = extractTime(session.start_time) ?? '--:--';
      const matchSummary = session.matches.length > 0
        ? `\n${session.matches.length} matches`
        : '';
      await Share.share({
        message: `${session.event_name} - ${session.sport}\n${session.date} at ${timeStr}\n${session.venue || session.events[0]?.location || ''}${matchSummary}`,
        title: session.event_name,
      });
    } catch (error) {
      console.error('Failed to share:', error);
    }
  };

  const handleOpenMap = () => {
    if (!session) return;

    const venueName = session.venue || session.events[0]?.location || '';
    const coords = VENUE_COORDINATES[venueName];
    const query = encodeURIComponent(`${venueName}, Italy`);

    const webUrl = coords
      ? `https://www.google.com/maps/search/?api=1&query=${coords.lat},${coords.lng}`
      : `https://www.google.com/maps/search/?api=1&query=${query}`;

    Linking.openURL(webUrl);
  };

  if (loading || !session) {
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

  const sportColor = theme.sportColors[session.sport_code] ?? theme.primary;
  const statusLabel = t(`event.status.${session.status}`);
  const hasMatches = session.matches.length > 0;

  // WCAG AAA: Get appropriate text color for sport color background
  const headerTextColor = getContrastText(sportColor);
  const headerTextMuted = headerTextColor === '#FFFFFF' ? 'rgba(255,255,255,0.8)' : 'rgba(13,27,42,0.7)';
  const badgeBgColor = headerTextColor === '#FFFFFF' ? 'rgba(255,255,255,0.2)' : 'rgba(13,27,42,0.15)';

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
          <Text style={[styles.sportName, { color: headerTextMuted }]}>{session.sport}</Text>
          <Text style={[styles.eventName, { color: headerTextColor }]}>{session.event_name}</Text>
          <View style={styles.badges}>
            {session.is_medal_event && (
              <View style={[styles.medalBadge, { backgroundColor: badgeBgColor }]}>
                <Icons.Medal size={16} color={headerTextColor} />
                <Text style={[styles.medalText, { color: headerTextColor }]}>{t('event.medal')}</Text>
              </View>
            )}
            <View style={[styles.statusBadge, { backgroundColor: badgeBgColor }, session.status === 'live' && styles.liveBadge]}>
              <Text style={[styles.statusText, { color: session.status === 'live' ? colors.snowWhite : headerTextColor }]}>{statusLabel}</Text>
            </View>
            {hasMatches && (
              <View style={[styles.matchCountBadge, { backgroundColor: badgeBgColor }]}>
                <Text style={[styles.matchCountText, { color: headerTextColor }]}>{session.matches.length} matches</Text>
              </View>
            )}
          </View>
        </View>

        {/* Details */}
        <View style={[styles.detailsCard, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <DetailRow label={t('event.time')} value={`${session.date} • ${extractTime(session.start_time) ?? '--:--'}`} />
          <DetailRow label={t('event.venue')} value={session.venue || session.events[0]?.location || ''} />
          <DetailRow label={t('event.sport')} value={session.sport} />
        </View>

        {/* Matches list */}
        {hasMatches && (
          <View style={styles.matchesSection}>
            <Text style={[styles.matchesSectionTitle, { color: theme.text }]}>
              {t('session.matches', { count: session.matches.length })}
            </Text>
            {session.events.map((event, index) => (
              event.match && (
                <MatchCard
                  key={event.event_id}
                  match={event.match}
                  location={event.location !== session.events[0]?.location ? event.location : undefined}
                />
              )
            ))}
          </View>
        )}

        {/* Actions */}
        <View style={styles.actions}>
          <BigButton
            title={isSessionFavorite ? t('event.removeFromFavorites') : t('event.addToFavorites')}
            icon={<Icons.Heart size={22} color={colors.snowWhite} />}
            onPress={handleToggleFavorite}
            variant={isSessionFavorite ? 'danger' : 'primary'}
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
    flexWrap: 'wrap',
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
  matchCountBadge: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  matchCountText: {
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
  matchesSection: {
    padding: spacing.md,
  },
  matchesSectionTitle: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.md,
  },
  matchCard: {
    padding: spacing.md,
    borderRadius: sizing.radius.medium,
    marginBottom: spacing.sm,
  },
  matchTeams: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.md,
  },
  team: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  flag: {
    fontSize: 24,
  },
  teamName: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
  },
  vsText: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.medium,
  },
  matchLocation: {
    fontSize: typography.fontSize.sm,
    textAlign: 'center',
    marginTop: spacing.xs,
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
