/**
 * UI Icons using Feather Icons (from @expo/vector-icons)
 * Clean line style for retro/geek game aesthetic
 */

import { Feather, MaterialCommunityIcons } from '@expo/vector-icons';
import type { ComponentProps } from 'react';

type FeatherName = ComponentProps<typeof Feather>['name'];
type MCIName = ComponentProps<typeof MaterialCommunityIcons>['name'];

// Icon component wrapper for consistent API
interface IconProps {
  size?: number;
  color?: string;
}

// Create icon components with Feather
function createFeatherIcon(name: FeatherName) {
  return function Icon({ size = 24, color = '#000' }: IconProps) {
    return <Feather name={name} size={size} color={color} />;
  };
}

// Create icon components with MaterialCommunityIcons
function createMCIIcon(name: MCIName) {
  return function Icon({ size = 24, color = '#000' }: IconProps) {
    return <MaterialCommunityIcons name={name} size={size} color={color} />;
  };
}

// Re-export for easy use - all clean line icons
export const Icons = {
  // Time & Schedule
  Clock: createFeatherIcon('clock'),
  Calendar: createFeatherIcon('calendar'),
  Sunrise: createFeatherIcon('sunrise'),

  // Location
  MapPin: createFeatherIcon('map-pin'),
  Map: createFeatherIcon('map'),
  Navigation: createFeatherIcon('navigation'),

  // Actions
  Heart: createMCIIcon('heart'),  // Filled heart
  HeartOutline: createFeatherIcon('heart'),  // Outline heart
  Share: createFeatherIcon('share-2'),
  ExternalLink: createFeatherIcon('external-link'),

  // Achievements
  Award: createFeatherIcon('award'),
  Star: createFeatherIcon('star'),
  Trophy: createMCIIcon('trophy-outline'),
  Medal: createMCIIcon('medal-outline'),

  // Status
  Circle: createFeatherIcon('circle'),
  AlertCircle: createFeatherIcon('alert-circle'),
  Check: createFeatherIcon('check'),
  Zap: createFeatherIcon('zap'),  // For live/hot events

  // Weather/Theme
  Sun: createFeatherIcon('sun'),
  Moon: createFeatherIcon('moon'),
  Cloud: createFeatherIcon('cloud'),
  Snowflake: createMCIIcon('snowflake'),
  Mountain: createMCIIcon('image-filter-hdr'),  // Mountain landscape icon

  // Settings & Navigation
  Settings: createFeatherIcon('settings'),
  Bell: createFeatherIcon('bell'),
  Globe: createFeatherIcon('globe'),
  ChevronLeft: createFeatherIcon('chevron-left'),
  ChevronRight: createFeatherIcon('chevron-right'),
  ChevronUp: createFeatherIcon('chevron-up'),
  ChevronDown: createFeatherIcon('chevron-down'),
  Info: createFeatherIcon('info'),
  MessageCircle: createFeatherIcon('message-circle'),
  Shield: createFeatherIcon('shield'),
  User: createFeatherIcon('user'),

  // Sync & Connection
  Wifi: createFeatherIcon('wifi'),
  WifiOff: createFeatherIcon('wifi-off'),
  RefreshCw: createFeatherIcon('refresh-cw'),
  CloudOff: createFeatherIcon('cloud-off'),
  CheckCircle: createFeatherIcon('check-circle'),
};

// Section icons for schedule headers
export const SectionIcons = {
  now: Icons.Zap,
  today: Icons.Calendar,
  tomorrow: Icons.Sunrise,
  upcoming: Icons.Calendar,
};

export default Icons;
