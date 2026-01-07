/**
 * MatchBadges - Display country flag pairs for team sport matches
 * Shows compact badges like "🇸🇪 vs 🇰🇷" for each match in a session
 */

import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { colors, darkColors, spacing, sizing, typography } from '../theme';
import type { MatchInfo } from '../types';

// NOC (3-letter Olympic) to ISO 3166-1 alpha-2 (2-letter) mapping for flags
const NOC_TO_ISO: Record<string, string> = {
  // Countries in Milano Cortina 2026 Winter Games
  AUS: 'AU', AUT: 'AT', BEL: 'BE', BLR: 'BY', BRA: 'BR',
  CAN: 'CA', CHN: 'CN', CRO: 'HR', CZE: 'CZ', DEN: 'DK',
  EST: 'EE', FIN: 'FI', FRA: 'FR', GBR: 'GB', GER: 'DE',
  HUN: 'HU', ITA: 'IT', JPN: 'JP', KAZ: 'KZ', KOR: 'KR',
  LAT: 'LV', NED: 'NL', NOR: 'NO', NZL: 'NZ', POL: 'PL',
  ROU: 'RO', RSA: 'ZA', RUS: 'RU', SLO: 'SI', SRB: 'RS',
  SUI: 'CH', SVK: 'SK', SWE: 'SE', UKR: 'UA', USA: 'US',
  // Additional common codes
  ESP: 'ES', GRE: 'GR', IRL: 'IE', ISR: 'IL', MEX: 'MX',
  POR: 'PT', TUR: 'TR', TPE: 'TW', HKG: 'HK', SGP: 'SG',
  MAS: 'MY', THA: 'TH', IND: 'IN', PAK: 'PK', PHI: 'PH',
};

// Convert NOC/ISO code to flag emoji
function countryCodeToFlag(code: string): string {
  const upperCode = code.toUpperCase();

  // Convert 3-letter NOC to 2-letter ISO if needed
  const isoCode = NOC_TO_ISO[upperCode] || (upperCode.length === 2 ? upperCode : null);

  if (!isoCode) {
    return '🏳️'; // White flag fallback for unknown codes
  }

  // Convert 2-letter ISO to regional indicator symbols
  const base = 0x1F1E6; // Regional Indicator Symbol Letter A
  try {
    return isoCode
      .split('')
      .map((char) => String.fromCodePoint(base + char.charCodeAt(0) - 65))
      .join('');
  } catch {
    return '🏳️';
  }
}

interface MatchBadgeProps {
  match: MatchInfo;
  compact?: boolean;
  textColor: string;
}

function MatchBadge({ match, compact = false, textColor }: MatchBadgeProps) {
  if (!match.team1 || !match.team2) return null;

  const flag1 = countryCodeToFlag(match.team1.teamCode);
  const flag2 = countryCodeToFlag(match.team2.teamCode);

  if (compact) {
    // Ultra-compact: just flags
    return (
      <Text style={styles.compactBadge}>
        {flag1}{flag2}
      </Text>
    );
  }

  return (
    <View style={styles.badge}>
      <Text style={styles.flag}>{flag1}</Text>
      <Text style={[styles.vs, { color: textColor }]}>vs</Text>
      <Text style={styles.flag}>{flag2}</Text>
    </View>
  );
}

interface MatchBadgesProps {
  matches: MatchInfo[];
  maxVisible?: number;
  compact?: boolean;
  backgroundColor?: string;
}

export function MatchBadges({
  matches,
  maxVisible = 4,
  compact = false,
  backgroundColor = 'rgba(0,0,0,0.1)',
}: MatchBadgesProps) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  if (matches.length === 0) return null;

  const visible = matches.slice(0, maxVisible);
  const remaining = matches.length - maxVisible;

  return (
    <View style={styles.container}>
      {visible.map((match, index) => (
        <View
          key={`${match.team1?.teamCode}-${match.team2?.teamCode}-${index}`}
          style={[styles.badgeWrapper, { backgroundColor }]}
        >
          <MatchBadge match={match} compact={compact} textColor={theme.textSecondary} />
        </View>
      ))}
      {remaining > 0 && (
        <View style={[styles.badgeWrapper, styles.moreBadge, { backgroundColor }]}>
          <Text style={[styles.moreText, { color: theme.textSecondary }]}>+{remaining}</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.xs,
  },
  badgeWrapper: {
    paddingHorizontal: spacing.xs,
    paddingVertical: 2,
    borderRadius: sizing.radius.small,
  },
  badge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 2,
  },
  flag: {
    fontSize: 12,
  },
  vs: {
    fontSize: typography.fontSize.xs,
    marginHorizontal: 1,
  },
  compactBadge: {
    fontSize: 11,
    letterSpacing: -2,
  },
  moreBadge: {
    justifyContent: 'center',
  },
  moreText: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.medium,
  },
});

export default MatchBadges;
