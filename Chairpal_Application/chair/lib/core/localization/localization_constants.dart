import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Constants for localization
class LocalizationConstants {
  LocalizationConstants._();

  // Supported locales
  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supportedLocales = [
    english,
    arabic,
  ];

  // Language codes
  static const String englishCode = 'en';
  static const String arabicCode = 'ar';

  // Language names
  static const String englishName = 'English';
  static const String arabicName = 'العربية';

  /// Get locale from language code
  static Locale getLocale(String languageCode) {
    switch (languageCode) {
      case arabicCode:
        return arabic;
      case englishCode:
      default:
        return english;
    }
  }

  /// Check if locale is RTL
  static bool isRTL(Locale locale) {
    return locale.languageCode == arabicCode;
  }
}

bool isArabic(){
  return Intl.getCurrentLocale() == 'ar';
}
