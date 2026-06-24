import '../repositories/home_repository.dart';

class DeleteBuildingUseCase {
  final HomeRepository repository;
  DeleteBuildingUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteBuilding(id);
  }
}
