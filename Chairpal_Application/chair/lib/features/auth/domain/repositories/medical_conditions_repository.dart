import '../../../../core/network/api_result.dart';
import '../entities/medical_condition.dart';

abstract class MedicalConditionsRepository {
  Future<ApiResult<List<MedicalCondition>>> getMedicalConditions();
}
