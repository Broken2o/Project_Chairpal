import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_state.dart';

/// Cubit for managing app locale
class LocaleProvider extends Cubit<LocaleState> {
  static const String _localeKey = 'app_locale';

  LocaleProvider() : super(const LocaleInitial(Locale('en'))) {
    setInitialLocale();
  }

  /// Set the app locale
  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    emit(LocaleChanged(locale));
  }

  /// Set initial locale (default to English)
  Future<void> setInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = prefs.getString(_localeKey);
    if (savedLocaleCode != null) {
      emit(LocaleInitial(Locale(savedLocaleCode)));
    } else {
      emit(const LocaleInitial(Locale('en')));
    }
  }

  /// Get current locale
  Locale get currentLocale => state.locale;

  /// Check if locale is RTL
  bool get isRTL => state.locale.languageCode == 'ar';
}
