import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class FloorListState extends Equatable {
  const FloorListState();

  @override
  List<Object> get props => [];
}

class FloorListInitial extends FloorListState {}

class FloorListLoading extends FloorListState {}

class FloorListLoaded extends FloorListState {
  final List<Place> floors;

  const FloorListLoaded(this.floors);

  @override
  List<Object> get props => [floors];
}

class FloorListError extends FloorListState {
  final String message;

  const FloorListError(this.message);

  @override
  List<Object> get props => [message];
}
