/**
 * Bronze Spacing & Sizing System
 *
 * Designed for accessible interaction:
 * - Large touch targets (56-64px minimum)
 * - Generous spacing (16-20px between elements)
 * - Big readable text (18-20px base)
 */

export const spacing = {
  // Base spacing scale (multiples of 4)
  xs: 4,
  sm: 8,
  md: 16,
  lg: 20,
  xl: 24,
  xxl: 32,
  xxxl: 48,
} as const;

export const sizing = {
  // Touch targets - glove-friendly!
  touchTarget: {
    comfort: 64,  // Default "Comfort" mode - extra large
    compact: 48,  // "Compact" mode - still accessible
    minimum: 44,  // iOS HIG minimum
  },

  // Button heights
  button: {
    large: 64,   // Primary CTAs
    medium: 56,  // Secondary actions
    small: 44,   // Tertiary actions
  },

  // Card dimensions
  card: {
    minHeight: 80,
    padding: 16,
    borderRadius: 16,
  },

  // Icon sizes
  icon: {
    small: 20,
    medium: 24,
    large: 32,
    xlarge: 48,
  },

  // Border radius - vintage/retro style (smaller, sharper)
  radius: {
    none: 0,
    small: 4,
    medium: 6,
    large: 8,
    round: 9999,
  },
} as const;

export const typography = {
  // Font sizes - larger than typical for readability
  fontSize: {
    xs: 12,
    sm: 14,
    md: 16,
    lg: 18,     // Body text base
    xl: 20,     // Emphasized body
    xxl: 24,    // Section headers
    xxxl: 32,   // Screen titles
    display: 40,
  },

  // Line heights
  lineHeight: {
    tight: 1.2,
    normal: 1.4,
    relaxed: 1.6,
  },

  // Font weights
  fontWeight: {
    normal: '400' as const,
    medium: '500' as const,
    semibold: '600' as const,
    bold: '700' as const,
  },
} as const;

// Preset styles for common elements
export const presets = {
  // Card with shadow
  cardShadow: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 3,
  },

  // Retro hard shadow - raised button look (light from bottom-right)
  // Creates 3D effect with solid shadow on top-left
  hardShadow: {
    shadowColor: '#000',
    shadowOffset: { width: -3, height: -3 },
    shadowOpacity: 0.25,
    shadowRadius: 0,  // Hard edge, no blur
    elevation: 4,
  },

  // Retro inset look for pressed state
  hardShadowPressed: {
    shadowColor: '#000',
    shadowOffset: { width: 2, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 0,
    elevation: 1,
  },

  // Glove-friendly button
  comfortButton: {
    minHeight: sizing.button.large,
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.md,
    borderRadius: sizing.radius.medium,
  },
} as const;
