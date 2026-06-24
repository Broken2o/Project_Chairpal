import 'dart:io';
import '../entities/category.dart';
import '../repositories/home_repository.dart';

class CreateCategoryUseCase {
  final HomeRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<Category> call({required String name, int? parentId, int? organizationId, File? image}) async {
    return await repository.createCategory(
      name: name,
      parentId: parentId,
      organizationId: organizationId,
      image: image,
    );
  }
}
