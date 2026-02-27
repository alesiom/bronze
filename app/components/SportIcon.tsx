/**
 * Sport Icons - MaterialCommunityIcons for general sports
 */

import React from 'react';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import type { SportCode } from '../types';

interface SportIconProps {
  sportCode: string;
  size?: number;
  color?: string;
}

const SPORT_ICONS: Record<SportCode, keyof typeof MaterialCommunityIcons.glyphMap> = {
  football: 'soccer',
  tennis: 'tennis',
  athletics: 'run-fast',
  cycling: 'bicycle',
  motorsport: 'car-sports',
  'winter-sports': 'snowflake',
  swimming: 'swim',
  other: 'trophy-outline',
};

export function SportIcon({ sportCode, size = 24, color = '#FFFFFF' }: SportIconProps) {
  const iconName = SPORT_ICONS[sportCode as SportCode] ?? 'trophy-outline';

  return (
    <MaterialCommunityIcons
      name={iconName}
      size={size}
      color={color}
    />
  );
}

export default SportIcon;
