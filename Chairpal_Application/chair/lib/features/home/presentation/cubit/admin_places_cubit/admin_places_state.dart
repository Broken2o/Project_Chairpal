import '../../../domain/entities/place.dart';

abstract class AdminPlacesState {}

class AdminPlacesInitial extends AdminPlacesState {}

class AdminPlacesLoading extends AdminPlacesState {}

class AdminPlacesLoaded extends AdminPlacesState {
  final List<Place> places;

  AdminPlacesLoaded(this.places);
}

class AdminPlacesError extends AdminPlacesState {
  final String message;

  AdminPlacesError(this.message);
}
