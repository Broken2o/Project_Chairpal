import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class AddPlaceState extends Equatable {
  const AddPlaceState();

  @override
  List<Object> get props => [];
}

class AddPlaceInitial extends AddPlaceState {}

class AddPlaceLoading extends AddPlaceState {}

class AddPlaceSuccess extends AddPlaceState {
  final Place place;

  const AddPlaceSuccess(this.place);

  @override
  List<Object> get props => [place];
}

class AddPlaceError extends AddPlaceState {
  final String message;

  const AddPlaceError(this.message);

  @override
  List<Object> get props => [message];
}
