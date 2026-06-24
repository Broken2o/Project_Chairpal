import 'package:dio/dio.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/medical_condition.dart';
import '../../domain/repositories/medical_conditions_repository.dart';
import '../datasources/medical_conditions_remote_data_source.dart';

class MedicalConditionsRepositoryImpl implements MedicalConditionsRepository {
  final MedicalConditionsRemoteDataSource _remoteDataSource;

  MedicalConditionsRepositoryImpl({
    required MedicalConditionsRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<List<MedicalCondition>>> getMedicalConditions() async {
    try {
      final remoteConditions = await _remoteDataSource.getMedicalConditions();
      return ApiSuccess(remoteConditions);
    } on DioException catch (e) {
      return ApiError(ServerFailure(
        e.response?.data['message'] ?? e.message ?? 'Unknown error occurred',
      ));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }
}
