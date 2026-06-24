import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class AddBuildingState extends Equatable {
  const AddBuildingState();

  @override
  List<Object> get props => [];
}

class AddBuildingInitial extends AddBuildingState {}

class AddBuildingLoading extends AddBuildingState {}

class AddBuildingSuccess extends AddBuildingState {
  final Place building;

  const AddBuildingSuccess(this.building);

  @override
  List<Object> get props => [building];
}

class AddBuildingError extends AddBuildingState {
  final String message;

  const AddBuildingError(this.message);

  @override
  List<Object> get props => [message];
}
