import 'package:flutter/material.dart';

/// State class for locale management
abstract class LocaleState {
  final Locale locale;

  const LocaleState(this.locale);
}

/// Initial state with default locale
class LocaleInitial extends LocaleState {
  const LocaleInitial(super.locale);
}

/// State emitted when locale changes
class LocaleChanged extends LocaleState {
  const LocaleChanged(super.locale);
}
