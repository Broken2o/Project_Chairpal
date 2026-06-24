import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_wheelchair_health_usecase.dart';
import '../../../domain/usecases/get_wheelchair_sensor_readings_usecase.dart';
import 'patient_details_state.dart';

class PatientDetailsCubit extends Cubit<PatientDetailsState> {
  final GetWheelchairHealthUseCase getHealthUseCase;
  final GetWheelchairSensorReadingsUseCase getSensorReadingsUseCase;

  PatientDetailsCubit({
    required this.getHealthUseCase,
    required this.getSensorReadingsUseCase,
  }) : super(PatientDetailsInitial());

  Future<void> loadPatientData(int wheelchairId) async {
    emit(PatientDetailsLoading());

    final healthResult = await getHealthUseCase(wheelchairId);
    final sensorResult = await getSensorReadingsUseCase(wheelchairId);

    healthResult.fold(
      (healthError) => emit(PatientDetailsError(healthError.message)),
      (healthData) {
        sensorResult.fold(
          (sensorError) => emit(PatientDetailsError(sensorError.message)),
          (sensorData) {
            emit(PatientDetailsLoaded(
              healthState: healthData,
              sensorReadings: sensorData,
            ));
          },
        );
      },
    );
  }
}
