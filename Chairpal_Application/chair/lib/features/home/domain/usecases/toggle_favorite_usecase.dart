import '../repositories/home_repository.dart';

class ToggleFavoriteUseCase {
  final HomeRepository repository;
  ToggleFavoriteUseCase(this.repository);

  Future<void> call(String type, String id) {
    return repository.toggleFavorite(type, id);
  }
}
