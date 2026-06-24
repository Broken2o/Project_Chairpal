import 'package:equatable/equatable.dart';
import '../../../domain/entities/medical_condition.dart';

abstract class MedicalConditionsState extends Equatable {
  const MedicalConditionsState();

  @override
  List<Object?> get props => [];
}

class MedicalConditionsInitial extends MedicalConditionsState {}

class MedicalConditionsLoading extends MedicalConditionsState {}

class MedicalConditionsLoaded extends MedicalConditionsState {
  final List<MedicalCondition> conditions;

  const MedicalConditionsLoaded({required this.conditions});

  @override
  List<Object?> get props => [conditions];
}

class MedicalConditionsError extends MedicalConditionsState {
  final String message;

  const MedicalConditionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
