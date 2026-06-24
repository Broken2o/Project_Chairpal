import '../repositories/home_repository.dart';

class DeleteOrganizationUseCase {
  final HomeRepository repository;
  DeleteOrganizationUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteOrganization(id);
  }
}
