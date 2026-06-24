import 'dart:io';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class UpdateOrganizationUseCase {
  final HomeRepository repository;
  UpdateOrganizationUseCase(this.repository);

  Future<void> call(int id, {String? name, String? location, String? description, String? imagePath}) {
    return repository.updateOrganization(id: id, name: name, location: location, description: description, imagePath: imagePath);
  }
}
