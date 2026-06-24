import '../repositories/home_repository.dart';

class DeleteCategoryUseCase {
  final HomeRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteCategory(id);
  }
}
