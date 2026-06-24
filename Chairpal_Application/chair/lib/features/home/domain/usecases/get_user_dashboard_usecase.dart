import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetUserDashboardUseCase {
  final HomeRepository repository;

  GetUserDashboardUseCase(this.repository);

  Future<ApiResult<dynamic>> call(int userId, String role, {String? filter}) async {
    try {
      final result = await repository.getDashboard(userId, role, filter: filter);
      return ApiSuccess(result);
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }
}
