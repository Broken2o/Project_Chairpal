import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_organization_usecase.dart';
import 'add_organization_state.dart';

class AddOrganizationCubit extends Cubit<AddOrganizationState> {
  final AddOrganizationUseCase _addOrganizationUseCase;

  AddOrganizationCubit({required AddOrganizationUseCase addOrganizationUseCase})
      : _addOrganizationUseCase = addOrganizationUseCase,
        super(AddOrganizationInitial());

  Future<void> createOrganization({
    required String name,
    int? categoryId,
    String? categoryName,
    required String countryName,
    required String cityName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    emit(AddOrganizationLoading());

    final params = AddOrganizationParams(
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      countryName: countryName,
      cityName: cityName,
      description: description,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );

    final result = await _addOrganizationUseCase(params);

    result.fold(
      (failure) => emit(AddOrganizationError(failure.message)),
      (organization) => emit(AddOrganizationSuccess(organization)),
    );
  }
}
