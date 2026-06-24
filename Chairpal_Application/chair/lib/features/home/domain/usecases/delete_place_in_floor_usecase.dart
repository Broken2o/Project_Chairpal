import '../repositories/home_repository.dart';

class DeletePlaceInFloorUseCase {
  final HomeRepository repository;
  DeletePlaceInFloorUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deletePlaceInFloor(id);
  }
}
