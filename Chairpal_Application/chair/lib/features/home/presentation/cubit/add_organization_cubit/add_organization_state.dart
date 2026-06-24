import 'package:equatable/equatable.dart';
import '../../../domain/entities/place.dart';

abstract class AddOrganizationState extends Equatable {
  const AddOrganizationState();

  @override
  List<Object> get props => [];
}

class AddOrganizationInitial extends AddOrganizationState {}

class AddOrganizationLoading extends AddOrganizationState {}

class AddOrganizationSuccess extends AddOrganizationState {
  final Place organization;

  const AddOrganizationSuccess(this.organization);

  @override
  List<Object> get props => [organization];
}

class AddOrganizationError extends AddOrganizationState {
  final String message;

  const AddOrganizationError(this.message);

  @override
  List<Object> get props => [message];
}
