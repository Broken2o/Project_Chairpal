import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/get_medical_conditions_usecase.dart';
import 'medical_conditions_state.dart';

class MedicalConditionsCubit extends Cubit<MedicalConditionsState> {
  final GetMedicalConditionsUseCase _getMedicalConditionsUseCase;

  MedicalConditionsCubit({
    required GetMedicalConditionsUseCase getMedicalConditionsUseCase,
  })  : _getMedicalConditionsUseCase = getMedicalConditionsUseCase,
        super(MedicalConditionsInitial());

  Future<void> fetchMedicalConditions() async {
    emit(MedicalConditionsLoading());
    final result = await _getMedicalConditionsUseCase();
    switch (result) {
      case ApiSuccess(:final data):
        emit(MedicalConditionsLoaded(conditions: data));
      case ApiError(:final failure):
        emit(MedicalConditionsError(message: failure.message));
    }
  }
}
