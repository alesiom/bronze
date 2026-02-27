import { useState, useMemo, useRef, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  Pressable,
  useColorScheme,
  Dimensions,
  Animated,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Swipeable } from 'react-native-gesture-handler';

import { colors, darkColors, spacing, sizing, typography, getContrastText } from '../../theme';
import { SportIcon, Icons, MatchBadges } from '../../components';
import { formatHumanDateTime } from '../../utils';
import { groupEventsIntoSessions } from '../../services/schedule';
import { useFavorites } from '../../hooks';
import type { Session } from '../../types';

const SCREEN_WIDTH = Dimensions.get('window').width;
const SWIPE_ACTION_WIDTH = SCREEN_WIDTH * 0.35; // Swipe distance ~35% of screen
const SWIPE_THRESHOLD = SWIPE_ACTION_WIDTH * 0.75; // Trigger at 75% of action width

// Crossfade animation for subtle icon transitions (filled → outline)
function AnimatedIconCrossfade({
  iconA,
  iconB,
  showB
}: {
  iconA: React.ReactNode;
  iconB: React.ReactNode;
  showB: boolean;
}) {
  const fadeAnim = useRef(new Animated.Value(showB ? 0 : 1)).current;
  const scaleAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    // Subtle pulse: scale down slightly then back up
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: showB ? 0 : 1,
        duration: 200,
        useNativeDriver: true,
      }),
      Animated.sequence([
        Animated.timing(scaleAnim, {
          toValue: 0.85,
          duration: 100,
          useNativeDriver: true,
        }),
        Animated.timing(scaleAnim, {
          toValue: 1,
          duration: 100,
          useNativeDriver: true,
        }),
      ]),
    ]).start();
  }, [showB]);

  return (
    <Animated.View style={{ transform: [{ scale: scaleAnim }] }}>
      <Animated.View style={{ opacity: fadeAnim }}>
        {iconA}
      </Animated.View>
      <Animated.View style={{
        position: 'absolute',
        opacity: fadeAnim.interpolate({
          inputRange: [0, 1],
          outputRange: [1, 0],
        })
      }}>
        {iconB}
      </Animated.View>
    </Animated.View>
  );
}

function SwipeActionBehind({ color, children, side }: { color: string; children: React.ReactNode; side: 'left' | 'right' }) {
  // Match shadow opacity (80% = CC in hex)
  const shadowColor = color + 'CC';
  return (
    <View style={[
      styles.swipeActionBehind,
      side === 'left' ? styles.swipeActionLeft : styles.swipeActionRight,
    ]}>
      <View style={[
        styles.swipeActionCard,
        { backgroundColor: shadowColor },
        // Extend toward card to prevent gaps, add padding to keep icon centered
        side === 'left'
          ? { marginRight: -50, paddingRight: 25 }
          : { marginLeft: -50, paddingLeft: 25 },
      ]}>
        {children}
      </View>
    </View>
  );
}

function SessionCard({ session, onPress, onRemove }: {
  session: Session;
  onPress: () => void;
  onRemove: () => void;
}) {
  const swipeableRef = useRef<Swipeable>(null);
  const [isSwiping, setIsSwiping] = useState(false);
  const [justRemoved, setJustRemoved] = useState(false);
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const sportColor = theme.sportColors[session.sport_code] ?? theme.primary;
  const isLive = session.status === 'live';
  const hasMatches = session.matches.length > 0;

  // Shadow color matches the sport color
  const accentColor = sportColor;

  const getWrapperStyle = (pressed: boolean) => ({
    marginHorizontal: spacing.md,
    backgroundColor: theme.surface,
    borderRadius: sizing.radius.large,
    ...(pressed ? {
      transform: [{ translateX: 4 }, { translateY: 4 }],
    } : {
      shadowColor: accentColor,
      shadowOffset: { width: 4, height: 4 },
      shadowOpacity: 0.8,
      shadowRadius: 0,
      elevation: 6,
    }),
  });

  const renderRightActions = () => (
    <SwipeActionBehind color={accentColor} side="right">
      <AnimatedIconCrossfade
        iconA={<Icons.Heart size={32} color={'#FFFFFF'} />}
        iconB={<Icons.HeartOutline size={32} color={'#FFFFFF'} />}
        showB={justRemoved}
      />
    </SwipeActionBehind>
  );

  const handleSwipeOpen = (direction: 'left' | 'right') => {
    if (direction === 'right') {
      onRemove();
      setJustRemoved(true);
      setTimeout(() => {
        swipeableRef.current?.close();
        setJustRemoved(false);
      }, 400);
    }
  };

  return (
    <Swipeable
      ref={swipeableRef}
      renderRightActions={renderRightActions}
      onSwipeableOpen={handleSwipeOpen}
      onSwipeableOpenStartDrag={() => setIsSwiping(true)}
      onSwipeableClose={() => setIsSwiping(false)}
      rightThreshold={SWIPE_THRESHOLD}
      overshootRight={false}
    >
      <Pressable onPress={onPress}>
        {({ pressed }) => (
          <View style={[styles.cardShadowWrapper, getWrapperStyle(pressed || isSwiping)]}>
            <View
              style={[
                styles.eventCard,
                {
                  backgroundColor: theme.surface,
                  borderColor: accentColor,
                },
              ]}
            >
              {/* Header band with icon and labels */}
              <View style={[styles.headerBand, { backgroundColor: sportColor + '15' }]}>
                <View style={[styles.cornerPin, { backgroundColor: sportColor }]}>
                  <SportIcon sportCode={session.sport_code} size={20} color={getContrastText(sportColor)} />
                </View>
                <View style={styles.headerLabels}>
                  {/* WCAG AAA: Use theme.text for high contrast instead of sportColor */}
                  <Text style={[styles.sportName, { color: theme.text }]}>
                    {session.sport}
                  </Text>
                  {isLive && (
                    <View style={[styles.liveBadge, { backgroundColor: theme.error }]}>
                      <Icons.Zap size={12} color={'#FFFFFF'} />
                      <Text style={styles.liveText}>{t('schedule.liveNow')}</Text>
                    </View>
                  )}
                  {session.is_medal_event && (
                    <View style={[styles.medalBadge, { backgroundColor: theme.warning + '25' }]}>
                      <Icons.Medal size={14} color={theme.warning} />
                    </View>
                  )}
                </View>
              </View>

              {/* Card content */}
              <View style={styles.cardContent}>
                <Text style={[styles.eventName, { color: theme.text }]} numberOfLines={2}>
                  {session.event_name}
                </Text>

                {/* Match badges for team sports */}
                {hasMatches && (
                  <View style={styles.matchBadgesContainer}>
                    <MatchBadges
                      matches={session.matches}
                      maxVisible={4}
                      backgroundColor={sportColor + '20'}
                    />
                  </View>
                )}

                <View style={styles.eventDetails}>
                  <View style={styles.detailRow}>
                    <Icons.Clock size={14} color={theme.textSecondary} />
                    <Text style={[styles.eventDate, { color: theme.textSecondary }]}>
                      {formatHumanDateTime(session.date, session.start_time, { t })}
                    </Text>
                  </View>
                  <View style={styles.detailRow}>
                    <Icons.MapPin size={14} color={theme.textMuted} />
                    <Text style={[styles.eventVenue, { color: theme.textMuted }]}>
                      {session.venue || session.events[0]?.location || ''}
                    </Text>
                  </View>
                </View>
              </View>
            </View>
          </View>
        )}
      </Pressable>
    </Swipeable>
  );
}

export default function FavoritesScreen() {
  const { t } = useTranslation();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Use centralized favorites management
  const { favorites, loading, removeFavorite } = useFavorites();

  // Group favorites into sessions, sorted by start_time
  const favoriteSessions = useMemo(() => {
    if (favorites.length === 0) return [];

    const sessions = groupEventsIntoSessions(favorites);

    // Sort by start_time (handle undefined values)
    sessions.sort((a, b) => {
      const aTime = a.start_time || '';
      const bTime = b.start_time || '';
      return aTime.localeCompare(bTime);
    });
    return sessions;
  }, [favorites]);

  const handleRemoveFavorite = async (session: Session) => {
    // Remove all events in this session by their event_id
    for (const event of session.events) {
      await removeFavorite(event.event_id);
    }
  };

  const handleSessionPress = (sessionCode: string) => {
    router.push(`/session/${sessionCode}`);
  };

  if (loading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top', 'left', 'right']}>
        <View style={styles.loadingContainer}>
          <Text style={[styles.loadingText, { color: theme.textMuted }]}>
            {t('common.loading')}
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top', 'left', 'right']}>
      <FlatList
        data={favoriteSessions}
        renderItem={({ item }) => (
          <SessionCard
            session={item}
            onPress={() => handleSessionPress(item.session_code)}
            onRemove={() => handleRemoveFavorite(item)}
          />
        )}
        keyExtractor={(item, index) => `${item.session_code}-${index}`}
        contentContainerStyle={[
          styles.listContent,
          favoriteSessions.length === 0 && styles.emptyList,
        ]}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Icons.Heart size={64} color={theme.textMuted} />
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
    paddingTop: spacing.md,
    paddingBottom: spacing.xxxl,
  },
  emptyList: {
    flex: 1,
  },
  cardShadowWrapper: {
    marginBottom: spacing.md,
  },
  eventCard: {
    borderRadius: sizing.radius.large,
    borderWidth: 2,
    overflow: 'hidden',
  },
  headerBand: {
    flexDirection: 'row',
    alignItems: 'center',
    borderTopLeftRadius: sizing.radius.large - 2,
    borderTopRightRadius: sizing.radius.large - 2,
    overflow: 'hidden',
  },
  cornerPin: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerLabels: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.sm,
    gap: spacing.sm,
    flexWrap: 'wrap',
  },
  sportName: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.bold,
  },
  cardContent: {
    padding: spacing.md,
  },
  liveBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  liveText: {
    color: '#FFFFFF',
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.bold,
  },
  medalBadge: {
    // backgroundColor set inline for theme support
    paddingHorizontal: spacing.xs,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  eventName: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.sm,
    lineHeight: typography.fontSize.lg * typography.lineHeight.normal,
  },
  matchBadgesContainer: {
    marginBottom: spacing.sm,
  },
  eventDetails: {
    gap: spacing.xs,
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
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
    gap: spacing.md,
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
  swipeActionBehind: {
    width: SWIPE_ACTION_WIDTH,
    marginTop: 4,  // Match shadow vertical offset
    marginBottom: spacing.md - 4,  // Extend into shadow area at bottom
    overflow: 'visible',  // Allow inner card to extend beyond
  },
  swipeActionLeft: {
    marginLeft: spacing.md + 4,  // Match shadow horizontal offset
  },
  swipeActionRight: {
    marginRight: spacing.md - 4,  // Align with shadow (shadow is 4px to the right of card)
  },
  swipeActionCard: {
    flex: 1,
    borderRadius: sizing.radius.large,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
