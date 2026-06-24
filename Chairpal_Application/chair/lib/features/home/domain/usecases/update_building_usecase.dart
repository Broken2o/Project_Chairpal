import 'dart:io';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class UpdateBuildingUseCase {
  final HomeRepository repository;
  UpdateBuildingUseCase(this.repository);

  Future<void> call(int id, {String? name, String? description, String? imagePath}) {
    return repository.updateBuilding(id: id, name: name, description: description, imagePath: imagePath);
  }
}
