import 'dart:io';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class UpdatePlaceInFloorUseCase {
  final HomeRepository repository;
  UpdatePlaceInFloorUseCase(this.repository);

  Future<void> call(int id, {String? name, String? description, String? imagePath, int? categoryId}) {
    return repository.updatePlaceInFloor(id: id, name: name, description: description, imagePath: imagePath, categoryId: categoryId);
  }
}
