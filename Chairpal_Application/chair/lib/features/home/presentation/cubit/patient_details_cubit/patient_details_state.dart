import '../../../data/models/vital_state_model.dart';
import '../../../data/models/sensor_reading_model.dart';

abstract class PatientDetailsState {}

class PatientDetailsInitial extends PatientDetailsState {}

class PatientDetailsLoading extends PatientDetailsState {}

class PatientDetailsLoaded extends PatientDetailsState {
  final VitalStateModel healthState;
  final List<SensorReadingModel> sensorReadings;

  PatientDetailsLoaded({
    required this.healthState,
    required this.sensorReadings,
  });
}

class PatientDetailsError extends PatientDetailsState {
  final String message;

  PatientDetailsError(this.message);
}
