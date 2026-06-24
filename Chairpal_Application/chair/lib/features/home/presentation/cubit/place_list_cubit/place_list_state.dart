import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class PlaceListState extends Equatable {
  const PlaceListState();

  @override
  List<Object> get props => [];
}

class PlaceListInitial extends PlaceListState {}

class PlaceListLoading extends PlaceListState {}

class PlaceListLoaded extends PlaceListState {
  final List<Place> places;

  const PlaceListLoaded(this.places);

  @override
  List<Object> get props => [places];
}

class PlaceListError extends PlaceListState {
  final String message;

  const PlaceListError(this.message);

  @override
  List<Object> get props => [message];
}
