import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import * as Localization from 'expo-localization';

// Import all language files
import en from '../locales/en.json';
import it from '../locales/it.json';
import de from '../locales/de.json';
import fr from '../locales/fr.json';
import es from '../locales/es.json';
import ja from '../locales/ja.json';
import zh from '../locales/zh.json';
import ko from '../locales/ko.json';
import pt from '../locales/pt.json';
import ar from '../locales/ar.json';
import nl from '../locales/nl.json';

export const resources = {
  en: { translation: en },
  it: { translation: it },
  de: { translation: de },
  fr: { translation: fr },
  es: { translation: es },
  ja: { translation: ja },
  zh: { translation: zh },
  ko: { translation: ko },
  pt: { translation: pt },
  ar: { translation: ar },
  nl: { translation: nl },
};

export const supportedLanguages = [
  { code: 'en', name: 'English', nativeName: 'English' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano' },
  { code: 'de', name: 'German', nativeName: 'Deutsch' },
  { code: 'fr', name: 'French', nativeName: 'Français' },
  { code: 'es', name: 'Spanish', nativeName: 'Español' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語' },
  { code: 'zh', name: 'Chinese', nativeName: '中文' },
  { code: 'ko', name: 'Korean', nativeName: '한국어' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', rtl: true },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands' },
] as const;

export type LanguageCode = typeof supportedLanguages[number]['code'];

// RTL languages
export const rtlLanguages = ['ar'];

export function isRTL(languageCode: string): boolean {
  return rtlLanguages.includes(languageCode);
}

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
