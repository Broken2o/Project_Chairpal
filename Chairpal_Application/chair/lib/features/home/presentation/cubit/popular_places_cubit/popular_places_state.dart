import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/entities/place.dart';

abstract class PopularPlacesState extends Equatable {
  const PopularPlacesState();

  @override
  List<Object?> get props => [];
}

class PopularPlacesInitial extends PopularPlacesState {}

class PopularPlacesLoading extends PopularPlacesState {
  final String? selectedCategory;
  const PopularPlacesLoading({this.selectedCategory});

  @override
  List<Object?> get props => [selectedCategory];
}

class PopularPlacesLoaded extends PopularPlacesState {
  final List<Place> places;
  final Position? userPosition;
  final String? selectedCategory;
  
  const PopularPlacesLoaded(
    this.places, {
    this.userPosition,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [places, userPosition, selectedCategory];
}

class PopularPlacesError extends PopularPlacesState {
  final String message;
  const PopularPlacesError(this.message);

  @override
  List<Object?> get props => [message];
}
