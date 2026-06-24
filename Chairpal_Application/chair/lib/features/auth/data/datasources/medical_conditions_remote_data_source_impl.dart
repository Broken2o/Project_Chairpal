import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/medical_condition_model.dart';
import 'medical_conditions_remote_data_source.dart';

class MedicalConditionsRemoteDataSourceImpl implements MedicalConditionsRemoteDataSource {
  final DioClient _dioClient;

  MedicalConditionsRemoteDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<MedicalConditionModel>> getMedicalConditions() async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.medicalConditionsEndpoint,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => MedicalConditionModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to fetch medical conditions',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
