import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class BuildingListState extends Equatable {
  const BuildingListState();

  @override
  List<Object> get props => [];
}

class BuildingListInitial extends BuildingListState {}

class BuildingListLoading extends BuildingListState {}

class BuildingListLoaded extends BuildingListState {
  final List<Place> buildings;

  const BuildingListLoaded(this.buildings);

  @override
  List<Object> get props => [buildings];
}

class BuildingListError extends BuildingListState {
  final String message;

  const BuildingListError(this.message);

  @override
  List<Object> get props => [message];
}
