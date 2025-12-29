#!/usr/bin/env node
/**
 * Converts SVG files to React Native SVG components
 */
const fs = require('fs');
const path = require('path');

const ICONS_DIR = path.join(__dirname, '../assets/icons/sports');
const OUTPUT_FILE = path.join(__dirname, '../components/SportIcons.tsx');

function convertSvgToRN(svgContent, name) {
  // Extract paths from SVG
  const pathMatches = svgContent.match(/<path[^>]*\/>/g) || [];

  // Convert paths: change fill="black" to fill={color}, path to Path
  const paths = pathMatches.map(p =>
    p.replace(/^<path/, '<Path')
     .replace(/fill="black"/g, 'fill={color}')
     .replace(/fill="#[0-9a-fA-F]+"/g, 'fill={color}')
  ).join('\n      ');

  return `
// ${name}
export const ${name}Icon = ({ size = 24, color = 'black' }: IconProps) => (
  <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
    <G>
      ${paths}
    </G>
  </Svg>
);`;
}

// Read all SVG files
const files = fs.readdirSync(ICONS_DIR).filter(f => f.endsWith('.svg'));

let components = [];
let iconExports = [];

files.forEach(file => {
  const name = path.basename(file, '.svg');
  const content = fs.readFileSync(path.join(ICONS_DIR, file), 'utf8');
  components.push(convertSvgToRN(content, name));
  iconExports.push(`  ${name}: ${name}Icon,`);
});

const output = `/**
 * Sport Icons - Custom SVG icons for all 16 Winter Olympic sports
 * Milano Cortina 2026
 * Auto-generated from SVG files
 */

import React from 'react';
import Svg, { Path, G } from 'react-native-svg';

interface IconProps {
  size?: number;
  color?: string;
}
${components.join('\n')}

// Export all icons in a map for easy access
export const SportIconComponents: Record<string, React.FC<IconProps>> = {
${iconExports.join('\n')}
};

export default SportIconComponents;
`;

fs.writeFileSync(OUTPUT_FILE, output);
console.log(`Generated ${OUTPUT_FILE} with ${files.length} icons`);
