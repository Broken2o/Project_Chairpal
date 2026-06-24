import '../models/medical_condition_model.dart';

abstract class MedicalConditionsRemoteDataSource {
  Future<List<MedicalConditionModel>> getMedicalConditions();
}
