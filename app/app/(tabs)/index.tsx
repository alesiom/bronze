import { useState, useMemo, useRef, useEffect } from 'react';
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
import { useRouter } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Swipeable } from 'react-native-gesture-handler';

import { colors, darkColors, spacing, sizing, typography, getContrastText } from '../../theme';
import { useSessions, useFilterOptions } from '../../hooks/useEvents';
import { useFavorites } from '../../hooks';
import { SportIcon, Icons, MatchBadges } from '../../components';
import { formatHumanDateTime } from '../../utils';
import type { Session, Event, SportCode } from '../../types';

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
  { code: 'SBD', labelKey: 'sports.SBD' },
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

  // WCAG AAA: Get appropriate text color for sport color background
  const selectedTextColor = getContrastText(sportColor);

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
              color={isSelected ? selectedTextColor : sportColor}
            />
          )}
          <Text
            style={[
              styles.sportPillText,
              { color: isSelected ? selectedTextColor : theme.text },
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

// Country filter pill component
function CountryPill({
  countryCode,
  isSelected,
  onPress,
}: {
  countryCode: string | null;
  isSelected: boolean;
  onPress: () => void;
}) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const flag = countryCode ? countryCodeToFlag(countryCode) : null;

  const getPillStyle = (pressed: boolean) => ({
    backgroundColor: isSelected ? theme.accent : theme.surface,
    borderColor: theme.accent,
    ...(pressed || isSelected
      ? { transform: [{ translateX: 2 }, { translateY: 2 }] }
      : {
          shadowColor: theme.accent,
          shadowOffset: { width: 2, height: 2 },
          shadowOpacity: 0.6,
          shadowRadius: 0,
          elevation: 3,
        }),
  });

  return (
    <Pressable onPress={onPress}>
      {({ pressed }) => (
        <View style={[styles.countryPill, getPillStyle(pressed)]}>
          {flag ? (
            <Text style={styles.countryFlag}>{flag}</Text>
          ) : (
            <Text
              style={[
                styles.countryPillText,
                { color: isSelected ? getContrastText(theme.accent) : theme.accent },
              ]}
            >
              {t('filters.all')}
            </Text>
          )}
        </View>
      )}
    </Pressable>
  );
}

// Country filter bar
function CountryFilterBar({
  selectedCountry,
  onSelectCountry,
  availableCountries,
}: {
  selectedCountry: string | null;
  onSelectCountry: (country: string | null) => void;
  availableCountries: string[];
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Only show if there are countries with matches
  if (availableCountries.length === 0) {
    return null;
  }

  return (
    <View style={[styles.countryFilterBar, { backgroundColor: theme.background }]}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.filterScrollContent}
      >
        {/* "All" pill */}
        <CountryPill
          countryCode={null}
          isSelected={selectedCountry === null}
          onPress={() => onSelectCountry(null)}
        />
        {/* Country pills */}
        {availableCountries.map((country) => (
          <CountryPill
            key={country}
            countryCode={country}
            isSelected={selectedCountry === country}
            onPress={() => onSelectCountry(country)}
          />
        ))}
      </ScrollView>
    </View>
  );
}

// Animated icon wrapper with scale animation (for heart → checkmark)
function AnimatedIconScale({
  iconBefore,
  iconAfter,
  trigger,
}: {
  iconBefore: React.ReactNode;
  iconAfter: React.ReactNode;
  trigger: boolean;
}) {
  const scaleAnim = useRef(new Animated.Value(1)).current;
  const [showAfterIcon, setShowAfterIcon] = useState(false);
  const isFirstRender = useRef(true);

  useEffect(() => {
    // Skip animation on first render
    if (isFirstRender.current) {
      isFirstRender.current = false;
      return;
    }

    if (trigger) {
      // Animate: scale out (showing heart), swap icon, scale in (showing checkmark)
      Animated.timing(scaleAnim, {
        toValue: 0,
        duration: 120,
        useNativeDriver: true,
      }).start(() => {
        // Swap to checkmark at the bottom of scale-out
        setShowAfterIcon(true);
        // Then scale back in
        Animated.spring(scaleAnim, {
          toValue: 1,
          friction: 6,
          tension: 200,
          useNativeDriver: true,
        }).start();
      });
    } else {
      // Reset when trigger goes back to false
      setShowAfterIcon(false);
      scaleAnim.setValue(1);
    }
  }, [trigger]);

  return (
    <Animated.View style={{ transform: [{ scale: scaleAnim }] }}>
      {showAfterIcon ? iconAfter : iconBefore}
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

function SessionCard({
  session,
  onPress,
  sectionKey,
  onAddFavorite,
  onRemoveFavorite,
  isFavorite,
}: {
  session: Session;
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

  const sportColor = theme.sportColors[session.sport_code] ?? theme.primary;
  const isLive = session.status === 'live';
  const isNowSection = sectionKey === 'now';

  // Shadow color matches the sport color (live badge handles the "live" indicator)
  const accentColor = sportColor;

  // Has team matches to display?
  const hasMatches = session.matches.length > 0;

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
    // If already favorite (and not in the middle of add animation), show static checkmark
    // Otherwise show animated heart → checkmark transition
    if (isFavorite && !justAdded) {
      return (
        <SwipeActionBehind color={accentColor} side="left">
          <Icons.Check size={32} color={colors.snowWhite} />
        </SwipeActionBehind>
      );
    }
    return (
      <SwipeActionBehind color={accentColor} side="left">
        <AnimatedIconScale
          trigger={justAdded}
          iconBefore={<Icons.Heart size={32} color={colors.snowWhite} />}
          iconAfter={<Icons.Check size={32} color={colors.snowWhite} />}
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
      // Wait for heart→checkmark animation (120ms out + ~250ms spring in + buffer)
      setTimeout(() => {
        swipeableRef.current?.close();
        setJustAdded(false);
      }, 550);
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
            <SportIcon sportCode={session.sport_code} size={20} color={getContrastText(sportColor)} />
          </View>
          <View style={styles.headerLabels}>
            {/* WCAG AAA: Use theme.text for high contrast instead of sportColor */}
            <Text style={[styles.sportName, { color: theme.text }]}>
              {session.sport}
            </Text>
            {isLive && (
              <View style={[styles.liveBadge, { backgroundColor: colors.rossoCorsa }]}>
                <Icons.Zap size={12} color={colors.snowWhite} />
                <Text style={styles.liveText}>{t('schedule.liveNow')}</Text>
              </View>
            )}
            {session.is_medal_event && (
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
            <View style={styles.timeContainer}>
              <Icons.Clock size={14} color={theme.textSecondary} />
              <Text style={[styles.eventTime, { color: theme.textSecondary }]}>
                {formatHumanDateTime(session.date, session.start_time, { t })}
              </Text>
            </View>
            <View style={styles.venueContainer}>
              <Icons.MapPin size={14} color={theme.textMuted} />
              <Text style={[styles.eventVenue, { color: theme.textMuted }]} numberOfLines={1}>
                {session.venue || session.events[0]?.location || ''}
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

  const [refreshing, setRefreshing] = useState(false);
  const [selectedSport, setSelectedSport] = useState<SportCode | null>(null);
  const [selectedCountry, setSelectedCountry] = useState<string | null>(null);

  // Use centralized favorites management
  const { favorites, favoriteIds, addFavorite, removeFavorite, isFavorite, refresh: refreshFavorites } = useFavorites();

  // Compute favorite session codes from favoriteIds
  const favoriteSessionCodes = useMemo(() => {
    const sessionCodes = new Set<string>();
    for (const event of favorites) {
      sessionCodes.add(event.session_code);
    }
    return sessionCodes;
  }, [favorites]);

  // Get filter options
  const { countries: allCountries } = useFilterOptions();

  // Get sessions with filters applied
  const { sessions, allSessions, loading, refresh } = useSessions({
    sport: selectedSport,
    country: selectedCountry,
  });

  // Add all events in a session to favorites
  const handleAddFavorite = async (session: Session) => {
    // Add all events from this session that aren't already favorited
    for (const event of session.events) {
      if (!isFavorite(event.event_id)) {
        await addFavorite(event);
      }
    }
  };

  // Remove all events in a session from favorites
  const handleRemoveFavorite = async (session: Session) => {
    // Remove all events in this session by their event_id (more reliable than session_code matching)
    for (const event of session.events) {
      await removeFavorite(event.event_id);
    }
  };

  // Get unique sports that have sessions (from all sessions, not filtered)
  const availableSports = useMemo(() => {
    return new Set(allSessions.map((s) => s.sport_code));
  }, [allSessions]);

  // Group sessions by section (Now, Today, Tomorrow, Upcoming)
  const groupedSessions = useMemo(() => {
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

    // Sort by start_time (ISO datetime comparison, handle undefined)
    const sortByDateTime = (a: Session, b: Session) => {
      const aTime = a.start_time || '';
      const bTime = b.start_time || '';
      return aTime.localeCompare(bTime);
    };

    // Sessions are already filtered by sport/country via useSessions hook
    const live = sessions
      .filter((s) => s.status === 'live')
      .sort(sortByDateTime);
    const todaySessions = sessions
      .filter((s) => s.date === today && s.status !== 'live')
      .sort(sortByDateTime);
    const tomorrowSessions = sessions
      .filter((s) => s.date === tomorrowStr && s.status !== 'live')
      .sort(sortByDateTime);
    const upcoming = sessions
      .filter((s) => s.date > tomorrowStr && s.status !== 'live')
      .sort(sortByDateTime);

    const sections: { title: string; key: string; data: Session[] }[] = [];

    if (live.length > 0) {
      sections.push({ title: t('schedule.now'), key: 'now', data: live });
    }
    if (todaySessions.length > 0) {
      sections.push({ title: t('schedule.today'), key: 'today', data: todaySessions });
    }
    if (tomorrowSessions.length > 0) {
      sections.push({ title: t('schedule.tomorrow'), key: 'tomorrow', data: tomorrowSessions });
    }
    if (upcoming.length > 0) {
      sections.push({ title: t('schedule.upcoming'), key: 'upcoming', data: upcoming });
    }

    return sections;
  }, [sessions, t]);

  const handleRefresh = async () => {
    setRefreshing(true);
    await refresh();
    setRefreshing(false);
  };

  const handleSessionPress = (sessionCode: string) => {
    router.push(`/session/${sessionCode}`);
  };

  // Flatten sections for FlatList with headers
  const flatData = useMemo(() => {
    const items: ((Session & { sectionKey: string }) | { type: 'header' | 'footer'; title: string; key: string })[] = [];
    groupedSessions.forEach((section) => {
      items.push({ type: 'header', title: section.title, key: section.key });
      // Add section key to each session for styling
      section.data.forEach((session) => {
        items.push({ ...session, sectionKey: section.key });
      });
      // Add footer after "now" section for bottom padding
      if (section.key === 'now') {
        items.push({ type: 'footer', title: '', key: 'now-footer' });
      }
    });
    return items;
  }, [groupedSessions]);

  const renderItem = ({ item }: { item: (Session & { sectionKey: string }) | { type: 'header' | 'footer'; title: string; key: string } }) => {
    if ('type' in item && item.type === 'header') {
      return <SectionHeader title={item.title} sectionKey={item.key} />;
    }
    if ('type' in item && item.type === 'footer') {
      // Footer for "now" section - provides bottom padding with background
      return <View style={styles.nowSectionFooter} />;
    }
    const sessionItem = item as Session & { sectionKey: string };
    return (
      <SessionCard
        session={sessionItem}
        onPress={() => handleSessionPress(sessionItem.session_code)}
        sectionKey={sessionItem.sectionKey}
        onAddFavorite={() => handleAddFavorite(sessionItem)}
        onRemoveFavorite={() => handleRemoveFavorite(sessionItem)}
        isFavorite={favoriteSessionCodes.has(sessionItem.session_code)}
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
      <CountryFilterBar
        selectedCountry={selectedCountry}
        onSelectCountry={setSelectedCountry}
        availableCountries={allCountries}
      />
      <FlatList
        data={flatData}
        renderItem={renderItem}
        keyExtractor={(item, index) =>
          'type' in item ? `header-${index}` : `${item.session_code}-${index}`
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
  countryFilterBar: {
    paddingBottom: spacing.md,
    overflow: 'visible',
  },
  countryPill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: sizing.radius.medium,
    borderWidth: 2,
  },
  countryFlag: {
    fontSize: 16,
  },
  countryPillText: {
    fontSize: typography.fontSize.sm,
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
  matchBadgesContainer: {
    marginBottom: spacing.sm,
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
