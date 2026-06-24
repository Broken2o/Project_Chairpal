import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class GetOrganizationsUseCase {
  final HomeRepository repository;

  GetOrganizationsUseCase(this.repository);

  Future<ApiResult<List<Place>>> call({String? search, String? include, int? categoryId}) async {
    try {
      final organizations = await repository.getOrganizations(
        search: search,
        include: include,
        categoryId: categoryId,
      );
      return ApiSuccess(organizations);
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }
}
