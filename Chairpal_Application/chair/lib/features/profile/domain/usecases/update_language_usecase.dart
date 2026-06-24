import '../repositories/profile_repository.dart';

class UpdateLanguageUseCase {
  final ProfileRepository repository;

  UpdateLanguageUseCase(this.repository);

  Future<void> call(String languageCode) async {
    return await repository.updateLanguage(languageCode);
  }
}
