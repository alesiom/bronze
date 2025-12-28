import { useState, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  useColorScheme,
  RefreshControl,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';

import { colors, darkColors, spacing, sizing, typography, presets } from '../../theme';
import type { Event, SportCode } from '../../types';

// Mock data for now - will be replaced with API calls
const MOCK_EVENTS: Event[] = [
  {
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
  },
  {
    event_id: 'FSK-001',
    sport: 'Figure Skating',
    sport_code: 'FSK',
    event_name: 'Team Event - Short Program',
    date: '2026-02-06',
    time: '10:00',
    venue: 'Milano Santa Giulia Arena',
    venue_city: 'Milano',
    status: 'scheduled',
    session_code: 'FSK01',
    is_medal_event: false,
  },
  {
    event_id: 'IHO-001',
    sport: 'Ice Hockey',
    sport_code: 'IHO',
    event_name: "Men's Preliminary Round",
    date: '2026-02-06',
    time: '14:00',
    venue: 'Milano Hockey Arena',
    venue_city: 'Milano',
    status: 'live',
    session_code: 'IHO01',
    is_medal_event: false,
  },
];

function EventCard({ event, onPress }: { event: Event; onPress: () => void }) {
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
      <View style={styles.eventHeader}>
        <View style={styles.sportBadge}>
          <Text style={[styles.sportCode, { color: sportColor }]}>
            {event.sport_code}
          </Text>
        </View>
        {isLive && (
          <View style={[styles.liveBadge, { backgroundColor: colors.rossoCorsa }]}>
            <Text style={styles.liveText}>{t('schedule.liveNow')}</Text>
          </View>
        )}
        {event.is_medal_event && (
          <Text style={styles.medalIcon}>🏅</Text>
        )}
      </View>

      <Text style={[styles.eventName, { color: theme.text }]} numberOfLines={2}>
        {event.event_name}
      </Text>

      <View style={styles.eventDetails}>
        <Text style={[styles.eventTime, { color: theme.textSecondary }]}>
          {event.time ?? '--:--'}
        </Text>
        <Text style={[styles.eventVenue, { color: theme.textMuted }]} numberOfLines={1}>
          {event.venue_city}
        </Text>
      </View>
    </TouchableOpacity>
  );
}

function SectionHeader({ title }: { title: string }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={styles.sectionHeader}>
      <Text style={[styles.sectionTitle, { color: theme.text }]}>{title}</Text>
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

  // Group events by section (Now, Today, Tomorrow, Upcoming)
  const groupedEvents = useMemo(() => {
    const now = new Date();
    const today = now.toISOString().split('T')[0];

    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = tomorrow.toISOString().split('T')[0];

    // Filter by sport if selected
    let filtered = MOCK_EVENTS;
    if (selectedSport) {
      filtered = filtered.filter((e) => e.sport_code === selectedSport);
    }

    const live = filtered.filter((e) => e.status === 'live');
    const todayEvents = filtered.filter(
      (e) => e.date === today && e.status !== 'live'
    );
    const tomorrowEvents = filtered.filter((e) => e.date === tomorrowStr);
    const upcoming = filtered.filter(
      (e) => e.date > tomorrowStr
    );

    const sections: { title: string; data: Event[] }[] = [];

    if (live.length > 0) {
      sections.push({ title: t('schedule.now'), data: live });
    }
    if (todayEvents.length > 0) {
      sections.push({ title: t('schedule.today'), data: todayEvents });
    }
    if (tomorrowEvents.length > 0) {
      sections.push({ title: t('schedule.tomorrow'), data: tomorrowEvents });
    }
    if (upcoming.length > 0) {
      sections.push({ title: t('schedule.upcoming'), data: upcoming });
    }

    return sections;
  }, [selectedSport, t]);

  const handleRefresh = async () => {
    setRefreshing(true);
    // TODO: Fetch fresh data from API
    await new Promise((resolve) => setTimeout(resolve, 1000));
    setRefreshing(false);
  };

  const handleEventPress = (eventId: string) => {
    router.push(`/event/${eventId}`);
  };

  // Flatten sections for FlatList with headers
  const flatData = useMemo(() => {
    const items: (Event | { type: 'header'; title: string })[] = [];
    groupedEvents.forEach((section) => {
      items.push({ type: 'header', title: section.title });
      items.push(...section.data);
    });
    return items;
  }, [groupedEvents]);

  const renderItem = ({ item }: { item: Event | { type: 'header'; title: string } }) => {
    if ('type' in item && item.type === 'header') {
      return <SectionHeader title={item.title} />;
    }
    return (
      <EventCard
        event={item as Event}
        onPress={() => handleEventPress((item as Event).event_id)}
      />
    );
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right']}>
      <FlatList
        data={flatData}
        renderItem={renderItem}
        keyExtractor={(item, index) =>
          'type' in item ? `header-${index}` : item.event_id
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
            <Text style={[styles.emptyText, { color: theme.textMuted }]}>
              {t('schedule.noEvents')}
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
  sectionHeader: {
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.xs,
  },
  sectionTitle: {
    fontSize: typography.fontSize.xxl,
    fontWeight: typography.fontWeight.bold,
  },
  eventCard: {
    padding: spacing.md,
    marginBottom: spacing.md,
    borderRadius: sizing.radius.large,
    borderLeftWidth: 4,
    minHeight: sizing.card.minHeight,
  },
  eventHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
    gap: spacing.sm,
  },
  sportBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
    backgroundColor: 'rgba(0,0,0,0.05)',
  },
  sportCode: {
    fontSize: typography.fontSize.xs,
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
  medalIcon: {
    fontSize: 16,
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
    gap: spacing.md,
  },
  eventTime: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
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
  },
  emptyText: {
    fontSize: typography.fontSize.lg,
  },
});
