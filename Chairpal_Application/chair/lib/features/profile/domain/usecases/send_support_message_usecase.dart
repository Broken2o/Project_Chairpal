import 'package:dio/dio.dart';
import '../repositories/profile_repository.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';

class SendSupportMessageUseCase {
  final ProfileRepository repository;

  SendSupportMessageUseCase(this.repository);

  Future<ApiResult> call(String message) async {
    try {
      await repository.sendSupportMessage(message);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }
}
