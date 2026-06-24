/// Model representing a language option
class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final String countryCode;
  final bool isRTL;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    required this.countryCode,
    required this.isRTL,
  });

  /// Factory constructor for English
  factory LanguageModel.english() {
    return const LanguageModel(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flagEmoji: '🇬🇧',
      countryCode: 'gb',
      isRTL: false,
    );
  }

  /// Factory constructor for Arabic
  factory LanguageModel.arabic() {
    return const LanguageModel(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flagEmoji: '🇪🇬',
      countryCode: 'eg',
      isRTL: true,
    );
  }

  /// Factory constructor for French
  factory LanguageModel.french() {
    return const LanguageModel(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flagEmoji: '🇫🇷',
      countryCode: 'fr',
      isRTL: false,
    );
  }

  /// Factory constructor for German
  factory LanguageModel.german() {
    return const LanguageModel(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flagEmoji: '🇩🇪',
      countryCode: 'de',
      isRTL: false,
    );
  }

  /// Factory constructor for Hindi
  factory LanguageModel.hindi() {
    return const LanguageModel(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flagEmoji: '🇮🇳',
      countryCode: 'in',
      isRTL: false,
    );
  }

  /// Factory constructor for Korean
  factory LanguageModel.korean() {
    return const LanguageModel(
      code: 'ko',
      name: 'Korean',
      nativeName: '한국어',
      flagEmoji: '🇰🇷',
      countryCode: 'kr',
      isRTL: false,
    );
  }

  /// Factory constructor for Vietnamese
  factory LanguageModel.vietnamese() {
    return const LanguageModel(
      code: 'vi',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flagEmoji: '🇻🇳',
      countryCode: 'vn',
      isRTL: false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
