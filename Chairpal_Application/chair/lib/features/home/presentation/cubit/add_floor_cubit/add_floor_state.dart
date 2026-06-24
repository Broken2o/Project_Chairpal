import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class AddFloorState extends Equatable {
  const AddFloorState();

  @override
  List<Object> get props => [];
}

class AddFloorInitial extends AddFloorState {}

class AddFloorLoading extends AddFloorState {}

class AddFloorSuccess extends AddFloorState {
  final Place floor;

  const AddFloorSuccess(this.floor);

  @override
  List<Object> get props => [floor];
}

class AddFloorError extends AddFloorState {
  final String message;

  const AddFloorError(this.message);

  @override
  List<Object> get props => [message];
}
