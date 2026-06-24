import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/language_model.dart';
import 'language_selection_state.dart';

/// Cubit for managing language selection
class LanguageSelectionCubit extends Cubit<LanguageSelectionState> {
  LanguageSelectionCubit()
    : super(LanguageSelectionInitial(_getAvailableLanguages()));

  static List<LanguageModel> _getAvailableLanguages() {
    return [
      LanguageModel.english(),
      LanguageModel.arabic(),
      LanguageModel.french(),
      LanguageModel.german(),
      LanguageModel.hindi(),
      LanguageModel.korean(),
      LanguageModel.vietnamese(),
    ];
  }

  /// Select a language
  void selectLanguage(LanguageModel language) {
    emit(
      LanguageSelected(
        selectedLanguage: language,
        availableLanguages: _getAvailableLanguages(),
      ),
    );
  }

  /// Confirm the selected language
  void confirmSelection() {
    if (state is LanguageSelected) {
      final selectedState = state as LanguageSelected;
      emit(LanguageConfirmed(selectedState.selectedLanguage));
    }
  }

  /// Get currently selected language if any
  LanguageModel? get selectedLanguage {
    if (state is LanguageSelected) {
      return (state as LanguageSelected).selectedLanguage;
    } else if (state is LanguageConfirmed) {
      return (state as LanguageConfirmed).confirmedLanguage;
    }
    return null;
  }
}
