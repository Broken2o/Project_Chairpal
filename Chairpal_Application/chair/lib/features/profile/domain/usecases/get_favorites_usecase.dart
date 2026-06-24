import 'package:dio/dio.dart';
import '../repositories/profile_repository.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';

class GetFavoritesUseCase {
  final ProfileRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<ApiResult> call() async {
    try {
      final favorites = await repository.getFavorites();
      return ApiSuccess(favorites);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }
}
