import 'package:equatable/equatable.dart';
import '../../domain/models/language_model.dart';

/// Base state for language selection
abstract class LanguageSelectionState extends Equatable {
  const LanguageSelectionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LanguageSelectionInitial extends LanguageSelectionState {
  final List<LanguageModel> availableLanguages;

  const LanguageSelectionInitial(this.availableLanguages);

  @override
  List<Object?> get props => [availableLanguages];
}

/// State when a language is selected but not confirmed
class LanguageSelected extends LanguageSelectionState {
  final LanguageModel selectedLanguage;
  final List<LanguageModel> availableLanguages;

  const LanguageSelected({
    required this.selectedLanguage,
    required this.availableLanguages,
  });

  @override
  List<Object?> get props => [selectedLanguage, availableLanguages];
}

/// State when language selection is confirmed
class LanguageConfirmed extends LanguageSelectionState {
  final LanguageModel confirmedLanguage;

  const LanguageConfirmed(this.confirmedLanguage);

  @override
  List<Object?> get props => [confirmedLanguage];
}
