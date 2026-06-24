import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_place_in_floor_usecase.dart';
import 'add_place_state.dart';

class AddPlaceCubit extends Cubit<AddPlaceState> {
  final CreatePlaceInFloorUseCase _createPlaceInFloorUseCase;

  AddPlaceCubit({required CreatePlaceInFloorUseCase createPlaceInFloorUseCase})
      : _createPlaceInFloorUseCase = createPlaceInFloorUseCase,
        super(AddPlaceInitial());

  Future<void> createPlace({
    required int floorId,
    required String name,
    int? categoryId,
    String? categoryName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    emit(AddPlaceLoading());

    final params = CreatePlaceInFloorParams(
      floorId: floorId,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );

    final result = await _createPlaceInFloorUseCase(params);

    result.fold(
      (failure) => emit(AddPlaceError(failure.message)),
      (place) => emit(AddPlaceSuccess(place)),
    );
  }
}
