import 'dart:io';
import '../entities/category.dart';
import '../repositories/home_repository.dart';

class UpdateCategoryUseCase {
  final HomeRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Category> call(int id, {String? name, int? parentId, List<int>? organizationIds, File? image}) async {
    return await repository.updateCategory(
      id,
      name: name,
      parentId: parentId,
      organizationIds: organizationIds,
      image: image,
    );
  }
}
