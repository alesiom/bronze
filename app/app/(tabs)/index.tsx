import { useState, useMemo, useRef, useCallback, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  Pressable,
  ScrollView,
  useColorScheme,
  RefreshControl,
  Animated,
  Dimensions,
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Swipeable } from 'react-native-gesture-handler';
import AsyncStorage from '@react-native-async-storage/async-storage';

import { colors, darkColors, spacing, sizing, typography } from '../../theme';
import { useEvents } from '../../hooks/useEvents';
import { SportIcon, Icons } from '../../components';
import { formatHumanDateTime } from '../../utils';
import type { Event, SportCode } from '../../types';

const FAVORITES_KEY = '@neve26_favorites';
const SCREEN_WIDTH = Dimensions.get('window').width;
const SWIPE_ACTION_WIDTH = SCREEN_WIDTH * 0.35; // Swipe distance ~35% of screen
const SWIPE_THRESHOLD = SWIPE_ACTION_WIDTH * 0.75; // Trigger at 75% of action width

// All sports for filter
const ALL_SPORTS: { code: SportCode; labelKey: string }[] = [
  { code: 'ALP', labelKey: 'sports.ALP' },
  { code: 'BTH', labelKey: 'sports.BTH' },
  { code: 'BOB', labelKey: 'sports.BOB' },
  { code: 'CCS', labelKey: 'sports.CCS' },
  { code: 'CUR', labelKey: 'sports.CUR' },
  { code: 'FSK', labelKey: 'sports.FSK' },
  { code: 'FRS', labelKey: 'sports.FRS' },
  { code: 'IHO', labelKey: 'sports.IHO' },
  { code: 'LUG', labelKey: 'sports.LUG' },
  { code: 'NCB', labelKey: 'sports.NCB' },
  { code: 'STK', labelKey: 'sports.STK' },
  { code: 'SKN', labelKey: 'sports.SKN' },
  { code: 'SJP', labelKey: 'sports.SJP' },
  { code: 'SMT', labelKey: 'sports.SMT' },
  { code: 'SSK', labelKey: 'sports.SSK' },
];

// Sport filter pill component with hard shadow button effect
function SportPill({
  sport,
  isSelected,
  onPress,
}: {
  sport: { code: SportCode; labelKey: string } | null;
  isSelected: boolean;
  onPress: () => void;
}) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const sportColor = sport ? theme.sportColors[sport.code] : theme.primary;
  const label = sport ? t(sport.labelKey) : t('filters.all');

  const getPillStyle = (pressed: boolean) => ({
    backgroundColor: isSelected ? sportColor : theme.surface,
    borderColor: sportColor,
    // Button effect: pressed = down into shadow, not pressed = raised
    ...(pressed || isSelected
      ? { transform: [{ translateX: 2 }, { translateY: 2 }] }
      : {
          shadowColor: sportColor,
          shadowOffset: { width: 2, height: 2 },
          shadowOpacity: 0.6,
          shadowRadius: 0,
          elevation: 3,
        }),
  });

  return (
    <Pressable onPress={onPress}>
      {({ pressed }) => (
        <View style={[styles.sportPill, getPillStyle(pressed)]}>
          {sport && (
            <SportIcon
              sportCode={sport.code}
              size={18}
              color={isSelected ? colors.snowWhite : sportColor}
            />
          )}
          <Text
            style={[
              styles.sportPillText,
              { color: isSelected ? colors.snowWhite : theme.text },
            ]}
          >
            {label}
          </Text>
        </View>
      )}
    </Pressable>
  );
}

// Sport filter bar
function SportFilterBar({
  selectedSport,
  onSelectSport,
  availableSports,
}: {
  selectedSport: SportCode | null;
  onSelectSport: (sport: SportCode | null) => void;
  availableSports: Set<SportCode>;
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Filter to only show sports that have events
  const sportsWithEvents = ALL_SPORTS.filter((s) => availableSports.has(s.code));

  return (
    <View style={[styles.filterBar, { backgroundColor: theme.background }]}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.filterScrollContent}
      >
        {/* "All" pill */}
        <SportPill
          sport={null}
          isSelected={selectedSport === null}
          onPress={() => onSelectSport(null)}
        />
        {/* Sport pills */}
        {sportsWithEvents.map((sport) => (
          <SportPill
            key={sport.code}
            sport={sport}
            isSelected={selectedSport === sport.code}
            onPress={() => onSelectSport(sport.code)}
          />
        ))}
      </ScrollView>
    </View>
  );
}

// Animated icon wrapper with scale animation (for heart → checkmark)
function AnimatedIconScale({ icon, trigger }: { icon: React.ReactNode; trigger: boolean }) {
  const scaleAnim = useRef(new Animated.Value(1)).current;
  const isFirstRender = useRef(true);

  useEffect(() => {
    // Skip animation on first render
    if (isFirstRender.current) {
      isFirstRender.current = false;
      return;
    }
    // Animate out, then animate in with new icon
    Animated.sequence([
      Animated.timing(scaleAnim, {
        toValue: 0,
        duration: 100,
        useNativeDriver: true,
      }),
      Animated.spring(scaleAnim, {
        toValue: 1,
        friction: 8,
        tension: 150,
        useNativeDriver: true,
      }),
    ]).start();
  }, [trigger]);

  return (
    <Animated.View style={{ transform: [{ scale: scaleAnim }] }}>
      {icon}
    </Animated.View>
  );
}

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

// Animated favorite badge that pops in/out
function AnimatedFavoriteBadge({ visible, children, backgroundColor }: { visible: boolean; children: React.ReactNode; backgroundColor: string }) {
  const scaleAnim = useRef(new Animated.Value(visible ? 1 : 0)).current;

  useEffect(() => {
    Animated.spring(scaleAnim, {
      toValue: visible ? 1 : 0,
      friction: 8,
      tension: 200,
      useNativeDriver: true,
    }).start();
  }, [visible]);

  return (
    <Animated.View style={[styles.favoriteBadge, { transform: [{ scale: scaleAnim }], backgroundColor }]}>
      {children}
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

function EventCard({
  event,
  onPress,
  sectionKey,
  onAddFavorite,
  onRemoveFavorite,
  isFavorite,
}: {
  event: Event;
  onPress: () => void;
  sectionKey?: string;
  onAddFavorite?: () => void;
  onRemoveFavorite?: () => void;
  isFavorite?: boolean;
}) {
  const swipeableRef = useRef<Swipeable>(null);
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const sportColor = theme.sportColors[event.sport_code] ?? theme.primary;
  const isLive = event.status === 'live';
  const isNowSection = sectionKey === 'now';

  // Shadow color matches the sport color (live badge handles the "live" indicator)
  const accentColor = sportColor;

  // For team sports, show "Team1 vs Team2" instead of generic session name
  const displayName = event.match?.team1 && event.match?.team2
    ? `${event.match.team1.description} vs ${event.match.team2.description}`
    : event.event_name;

  // Card wrapper with button effect (shadow + press transform)
  const getWrapperStyle = (pressed: boolean) => ({
    marginHorizontal: spacing.md,
    backgroundColor: theme.surface,
    borderRadius: sizing.radius.large,
    // Button effect: pressed = down, not pressed = raised with shadow
    ...(pressed
      ? { transform: [{ translateX: 4 }, { translateY: 4 }] }
      : {
          shadowColor: accentColor,
          shadowOffset: { width: 4, height: 4 },
          shadowOpacity: 0.8,
          shadowRadius: 0,
          elevation: 6,
        }),
  });

  // Card is "down" (pressed state) while being swiped
  const [isSwiping, setIsSwiping] = useState(false);
  // Track if we just added to favorites (to show checkmark before closing)
  const [justAdded, setJustAdded] = useState(false);
  // Track if we just removed from favorites (to show outline before closing)
  const [justRemoved, setJustRemoved] = useState(false);

  const renderLeftActions = () => {
    if (!onAddFavorite) return null;
    // Show checkmark if already favorited or just added, heart if not
    const showCheck = isFavorite || justAdded;
    return (
      <SwipeActionBehind color={accentColor} side="left">
        <AnimatedIconScale
          trigger={justAdded}
          icon={showCheck
            ? <Icons.Check size={32} color={colors.snowWhite} />
            : <Icons.Heart size={32} color={colors.snowWhite} />
          }
        />
      </SwipeActionBehind>
    );
  };

  const renderRightActions = () => {
    if (!onRemoveFavorite) return null;
    // Crossfade between filled and outline heart
    const showOutline = justRemoved || !isFavorite;
    return (
      <SwipeActionBehind color={accentColor} side="right">
        <AnimatedIconCrossfade
          iconA={<Icons.Heart size={32} color={colors.snowWhite} />}
          iconB={<Icons.HeartOutline size={32} color={colors.snowWhite} />}
          showB={showOutline}
        />
      </SwipeActionBehind>
    );
  };

  const handleSwipeOpen = (direction: 'left' | 'right') => {
    if (direction === 'left' && onAddFavorite && !isFavorite) {
      onAddFavorite();
      setJustAdded(true);
      // Wait a moment to show the checkmark, then close
      setTimeout(() => {
        swipeableRef.current?.close();
        setJustAdded(false);
      }, 400);
    } else if (direction === 'right' && onRemoveFavorite) {
      if (isFavorite) {
        onRemoveFavorite();
        setJustRemoved(true);
        // Wait a moment to show the outline, then close
        setTimeout(() => {
          swipeableRef.current?.close();
          setJustRemoved(false);
        }, 400);
      } else {
        swipeableRef.current?.close();
      }
    } else {
      // Already favorited or not favorited, just close
      swipeableRef.current?.close();
    }
  };

  const cardContent = (
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
            <SportIcon sportCode={event.sport_code} size={20} color={colors.snowWhite} />
          </View>
          <View style={styles.headerLabels}>
            <Text style={[styles.sportName, { color: sportColor }]}>
              {event.sport}
            </Text>
            {isLive && (
              <View style={[styles.liveBadge, { backgroundColor: colors.rossoCorsa }]}>
                <Icons.Zap size={12} color={colors.snowWhite} />
                <Text style={styles.liveText}>{t('schedule.liveNow')}</Text>
              </View>
            )}
            {event.is_medal_event && (
              <View style={[styles.medalBadge, { backgroundColor: theme.warning + '25' }]}>
                <Icons.Medal size={14} color={theme.warning} />
              </View>
            )}
            <AnimatedFavoriteBadge visible={isFavorite ?? false} backgroundColor={theme.accent + '25'}>
              <Icons.Heart size={14} color={theme.accent} />
            </AnimatedFavoriteBadge>
          </View>
        </View>

        {/* Card content */}
        <View style={styles.cardContent}>
          <Text style={[styles.eventName, { color: theme.text }]} numberOfLines={2}>
            {displayName}
          </Text>

          <View style={styles.eventDetails}>
            <View style={styles.timeContainer}>
              <Icons.Clock size={14} color={theme.textSecondary} />
              <Text style={[styles.eventTime, { color: theme.textSecondary }]}>
                {formatHumanDateTime(event.date, event.start_time, { t })}
              </Text>
            </View>
            <View style={styles.venueContainer}>
              <Icons.MapPin size={14} color={theme.textMuted} />
              <Text style={[styles.eventVenue, { color: theme.textMuted }]} numberOfLines={1}>
                {event.venue || event.location}
              </Text>
            </View>
          </View>
        </View>
        </View>
      </View>
      )}
    </Pressable>
  );

  // Wrap with Swipeable for swipe gestures
  if (onAddFavorite || onRemoveFavorite) {
    return (
      <Swipeable
        ref={swipeableRef}
        renderLeftActions={renderLeftActions}
        renderRightActions={renderRightActions}
        onSwipeableOpen={handleSwipeOpen}
        onSwipeableOpenStartDrag={() => setIsSwiping(true)}
        onSwipeableClose={() => setIsSwiping(false)}
        leftThreshold={SWIPE_THRESHOLD}
        rightThreshold={SWIPE_THRESHOLD}
        overshootLeft={false}
        overshootRight={false}
      >
        {cardContent}
      </Swipeable>
    );
  }

  return cardContent;
}

function SectionHeader({ title, sectionKey }: { title: string; sectionKey?: string }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const isNowSection = sectionKey === 'now';

  return (
    <View style={[
      styles.sectionHeader,
      isNowSection && styles.nowSectionHeader,
      isNowSection && { backgroundColor: isDark ? colors.rossoCorsa + '15' : colors.rossoCorsa + '10' },
    ]}>
      <Text style={[styles.sectionTitle, { color: theme.text }]}>
        {title}
      </Text>
    </View>
  );
}

export default function ScheduleScreen() {
  const { t } = useTranslation();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const { events, loading, refresh } = useEvents();
  const [refreshing, setRefreshing] = useState(false);
  const [selectedSport, setSelectedSport] = useState<SportCode | null>(null);
  const [favoriteIds, setFavoriteIds] = useState<Set<string>>(new Set());

  // Load favorites on focus
  const loadFavorites = useCallback(async () => {
    try {
      const stored = await AsyncStorage.getItem(FAVORITES_KEY);
      if (stored) {
        const favorites: Event[] = JSON.parse(stored);
        setFavoriteIds(new Set(favorites.map((e) => e.event_id)));
      }
    } catch (error) {
      console.error('Failed to load favorites:', error);
    }
  }, []);

  useFocusEffect(
    useCallback(() => {
      loadFavorites();
    }, [loadFavorites])
  );

  const handleAddFavorite = async (event: Event) => {
    try {
      const stored = await AsyncStorage.getItem(FAVORITES_KEY);
      const favorites: Event[] = stored ? JSON.parse(stored) : [];
      if (!favorites.some((e) => e.event_id === event.event_id)) {
        favorites.push(event);
        await AsyncStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites));
        setFavoriteIds(new Set(favorites.map((e) => e.event_id)));
      }
    } catch (error) {
      console.error('Failed to add favorite:', error);
    }
  };

  const handleRemoveFavorite = async (eventId: string) => {
    try {
      const stored = await AsyncStorage.getItem(FAVORITES_KEY);
      const favorites: Event[] = stored ? JSON.parse(stored) : [];
      const updated = favorites.filter((e) => e.event_id !== eventId);
      await AsyncStorage.setItem(FAVORITES_KEY, JSON.stringify(updated));
      setFavoriteIds(new Set(updated.map((e) => e.event_id)));
    } catch (error) {
      console.error('Failed to remove favorite:', error);
    }
  };

  // Get unique sports that have events
  const availableSports = useMemo(() => {
    return new Set(events.map((e) => e.sport_code));
  }, [events]);

  // Group events by section (Now, Today, Tomorrow, Upcoming)
  const groupedEvents = useMemo(() => {
    const now = new Date();
    // Format as YYYY-MM-DD in local timezone
    const formatLocalDate = (d: Date) => {
      const year = d.getFullYear();
      const month = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    };
    const today = formatLocalDate(now);

    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = formatLocalDate(tomorrow);

    // Sort by start_time (ISO datetime comparison)
    const sortByDateTime = (a: Event, b: Event) => {
      return a.start_time.localeCompare(b.start_time);
    };

    // Filter by sport if selected
    let filtered = events;
    if (selectedSport) {
      filtered = filtered.filter((e) => e.sport_code === selectedSport);
    }

    const live = filtered
      .filter((e) => e.status === 'live')
      .sort(sortByDateTime);
    const todayEvents = filtered
      .filter((e) => e.date === today && e.status !== 'live')
      .sort(sortByDateTime);
    const tomorrowEvents = filtered
      .filter((e) => e.date === tomorrowStr && e.status !== 'live')
      .sort(sortByDateTime);
    const upcoming = filtered
      .filter((e) => e.date > tomorrowStr && e.status !== 'live')
      .sort(sortByDateTime);

    const sections: { title: string; key: string; data: Event[] }[] = [];

    if (live.length > 0) {
      sections.push({ title: t('schedule.now'), key: 'now', data: live });
    }
    if (todayEvents.length > 0) {
      sections.push({ title: t('schedule.today'), key: 'today', data: todayEvents });
    }
    if (tomorrowEvents.length > 0) {
      sections.push({ title: t('schedule.tomorrow'), key: 'tomorrow', data: tomorrowEvents });
    }
    if (upcoming.length > 0) {
      sections.push({ title: t('schedule.upcoming'), key: 'upcoming', data: upcoming });
    }

    return sections;
  }, [events, selectedSport, t]);

  const handleRefresh = async () => {
    setRefreshing(true);
    await refresh();
    setRefreshing(false);
  };

  const handleEventPress = (eventId: string) => {
    router.push(`/event/${eventId}`);
  };

  // Flatten sections for FlatList with headers
  const flatData = useMemo(() => {
    const items: ((Event & { sectionKey: string }) | { type: 'header' | 'footer'; title: string; key: string })[] = [];
    groupedEvents.forEach((section) => {
      items.push({ type: 'header', title: section.title, key: section.key });
      // Add section key to each event for styling
      section.data.forEach((event) => {
        items.push({ ...event, sectionKey: section.key });
      });
      // Add footer after "now" section for bottom padding
      if (section.key === 'now') {
        items.push({ type: 'footer', title: '', key: 'now-footer' });
      }
    });
    return items;
  }, [groupedEvents]);

  const renderItem = ({ item }: { item: (Event & { sectionKey: string }) | { type: 'header' | 'footer'; title: string; key: string } }) => {
    if ('type' in item && item.type === 'header') {
      return <SectionHeader title={item.title} sectionKey={item.key} />;
    }
    if ('type' in item && item.type === 'footer') {
      // Footer for "now" section - provides bottom padding with background
      return <View style={styles.nowSectionFooter} />;
    }
    const eventItem = item as Event & { sectionKey: string };
    return (
      <EventCard
        event={eventItem}
        onPress={() => handleEventPress(eventItem.event_id)}
        sectionKey={eventItem.sectionKey}
        onAddFavorite={() => handleAddFavorite(eventItem)}
        onRemoveFavorite={() => handleRemoveFavorite(eventItem.event_id)}
        isFavorite={favoriteIds.has(eventItem.event_id)}
      />
    );
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top', 'left', 'right']}>
      <SportFilterBar
        selectedSport={selectedSport}
        onSelectSport={setSelectedSport}
        availableSports={availableSports}
      />
      <FlatList
        data={flatData}
        renderItem={renderItem}
        keyExtractor={(item, index) =>
          'type' in item ? `header-${index}` : `${item.event_id}-${index}`
        }
        contentContainerStyle={styles.listContent}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={handleRefresh}
            tintColor={theme.primary}
          />
        }
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Icons.Mountain size={64} color={theme.textMuted} />
            <Text style={[styles.emptyText, { color: theme.text }]}>
              {t('schedule.noEvents')}
            </Text>
            <View style={styles.emptySnowflakes}>
              <Icons.Snowflake size={20} color={theme.textMuted} />
              <Icons.Snowflake size={20} color={theme.textMuted} />
              <Icons.Snowflake size={20} color={theme.textMuted} />
            </View>
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
  filterBar: {
    paddingTop: spacing.sm,
    paddingBottom: spacing.lg,
    overflow: 'visible',
  },
  filterScrollContent: {
    paddingHorizontal: spacing.md,
    paddingBottom: 4, // Space for shadow (2px offset + buffer)
    gap: spacing.sm,
  },
  sportPill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderRadius: sizing.radius.large,
    borderWidth: 2,
  },
  sportPillText: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.semibold,
  },
  listContent: {
    paddingBottom: spacing.xxxl,
  },
  sectionHeader: {
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.md,
  },
  nowSectionHeader: {
    paddingTop: spacing.md,
  },
  nowSectionFooter: {
    height: spacing.xl,  // Total height: gap coverage + padding
    marginTop: -spacing.md,  // Pull up to cover the last card's bottom margin
    backgroundColor: colors.rossoCorsa + '10',
  },
  sectionTitle: {
    fontSize: typography.fontSize.xxl,
    fontWeight: typography.fontWeight.bold,
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
    borderTopLeftRadius: sizing.radius.large - 2,  // Match card border radius minus border
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
    flexDirection: 'row',
    alignItems: 'center',
  },
  liveText: {
    color: colors.snowWhite,
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.bold,
  },
  medalBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 2,
    // backgroundColor set inline for theme support
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
  },
  favoriteBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    // backgroundColor set inline for theme support
    paddingHorizontal: spacing.xs,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
    marginLeft: 'auto',  // Push to right
  },
  medalIcon: {
    fontSize: 14,
  },
  medalText: {
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
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.lg,
  },
  timeContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  eventTime: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.semibold,
  },
  venueContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
    flex: 1,
  },
  eventVenue: {
    fontSize: typography.fontSize.sm,
    flex: 1,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: spacing.xxxl,
    gap: spacing.md,
  },
  emptyText: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.semibold,
  },
  emptySnowflakes: {
    flexDirection: 'row',
    gap: spacing.md,
    marginTop: spacing.sm,
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
