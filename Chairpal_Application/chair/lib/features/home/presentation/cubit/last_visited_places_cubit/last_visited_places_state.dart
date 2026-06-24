import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class LastVisitedPlacesState extends Equatable {
  const LastVisitedPlacesState();

  @override
  List<Object?> get props => [];
}

class LastVisitedPlacesInitial extends LastVisitedPlacesState {}

class LastVisitedPlacesLoading extends LastVisitedPlacesState {}

class LastVisitedPlacesLoaded extends LastVisitedPlacesState {
  final List<Place> places;

  const LastVisitedPlacesLoaded(this.places);

  @override
  List<Object?> get props => [places];
}

class LastVisitedPlacesError extends LastVisitedPlacesState {
  final String message;

  const LastVisitedPlacesError(this.message);

  @override
  List<Object?> get props => [message];
}
