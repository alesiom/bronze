/**
 * Sport Icons - Custom SVG icons for winter sports
 */

import React from 'react';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { colors } from '../theme';
import { SportIconComponents } from './SportIcons';

interface SportIconProps {
  sportCode: string;
  size?: number;
  color?: string;
}

// Icons that look better from MaterialCommunityIcons
const MATERIAL_ICONS: Record<string, keyof typeof MaterialCommunityIcons.glyphMap> = {
  ALP: 'ski', // Alpine Skiing - classic downhill skier
};

export function SportIcon({ sportCode, size = 24, color = colors.snowWhite }: SportIconProps) {
  // Check if we prefer MaterialCommunityIcons for this sport
  const materialIcon = MATERIAL_ICONS[sportCode];
  if (materialIcon) {
    return (
      <MaterialCommunityIcons
        name={materialIcon}
        size={size}
        color={color}
      />
    );
  }

  // Use custom SVG icon
  const CustomIcon = SportIconComponents[sportCode];
  if (CustomIcon) {
    return <CustomIcon size={size} color={color} />;
  }

  // Fallback
  return (
    <MaterialCommunityIcons
      name="medal-outline"
      size={size}
      color={color}
    />
  );
}

export default SportIcon;
