import '../../../../core/network/api_result.dart';
import '../entities/medical_condition.dart';
import '../repositories/medical_conditions_repository.dart';

class GetMedicalConditionsUseCase {
  final MedicalConditionsRepository repository;

  GetMedicalConditionsUseCase(this.repository);

  Future<ApiResult<List<MedicalCondition>>> call() {
    return repository.getMedicalConditions();
  }
}
