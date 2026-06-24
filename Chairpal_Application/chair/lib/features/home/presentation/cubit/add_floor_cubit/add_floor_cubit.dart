import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_floor_usecase.dart';
import 'add_floor_state.dart';

class AddFloorCubit extends Cubit<AddFloorState> {
  final CreateFloorUseCase _createFloorUseCase;

  AddFloorCubit({required CreateFloorUseCase createFloorUseCase})
      : _createFloorUseCase = createFloorUseCase,
        super(AddFloorInitial());

  Future<void> createFloor({
    required int buildingId,
    required String name,
    int? level,
    String? description,
    File? image,
  }) async {
    emit(AddFloorLoading());

    final params = CreateFloorParams(
      buildingId: buildingId,
      name: name,
      level: level,
      description: description,
      image: image,
    );

    final result = await _createFloorUseCase(params);

    result.fold(
      (failure) => emit(AddFloorError(failure.message)),
      (floor) => emit(AddFloorSuccess(floor)),
    );
  }
}
