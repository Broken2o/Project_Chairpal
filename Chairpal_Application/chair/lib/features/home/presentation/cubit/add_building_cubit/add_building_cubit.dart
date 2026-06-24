import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_building_usecase.dart';
import 'add_building_state.dart';

class AddBuildingCubit extends Cubit<AddBuildingState> {
  final CreateBuildingUseCase _createBuildingUseCase;

  AddBuildingCubit({required CreateBuildingUseCase createBuildingUseCase})
      : _createBuildingUseCase = createBuildingUseCase,
        super(AddBuildingInitial());

  Future<void> createBuilding({
    required int organizationId,
    required String name,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    emit(AddBuildingLoading());

    final params = CreateBuildingParams(
      organizationId: organizationId,
      name: name,
      description: description,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );

    final result = await _createBuildingUseCase(params);

    result.fold(
      (failure) => emit(AddBuildingError(failure.message)),
      (building) => emit(AddBuildingSuccess(building)),
    );
  }
}
