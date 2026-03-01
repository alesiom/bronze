import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import * as Localization from 'expo-localization';

// Import language files
import en from '../locales/en.json';
import de from '../locales/de.json';
import fr from '../locales/fr.json';

export const resources = {
  en: { translation: en },
  de: { translation: de },
  fr: { translation: fr },
};

export const supportedLanguages = [
  { code: 'en', name: 'English', nativeName: 'English' },
  { code: 'de', name: 'German', nativeName: 'Deutsch' },
  { code: 'fr', name: 'French', nativeName: 'Français' },
] as const;

export type LanguageCode = typeof supportedLanguages[number]['code'];

// Get device language, falling back to English
function getDeviceLanguage(): LanguageCode {
  const deviceLocale = Localization.getLocales()[0]?.languageCode ?? 'en';
  const supportedCodes = supportedLanguages.map((l) => l.code);

  if (supportedCodes.includes(deviceLocale as LanguageCode)) {
    return deviceLocale as LanguageCode;
  }

  return 'en';
}

i18n.use(initReactI18next).init({
  resources,
  lng: getDeviceLanguage(),
  fallbackLng: 'en',
  interpolation: {
    escapeValue: false,
  },
  react: {
    useSuspense: false,
  },
});

export default i18n;
