import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_floors_usecase.dart';
import 'floor_list_state.dart';

class FloorListCubit extends Cubit<FloorListState> {
  final GetFloorsUseCase _getFloorsUseCase;

  FloorListCubit({required GetFloorsUseCase getFloorsUseCase})
      : _getFloorsUseCase = getFloorsUseCase,
        super(FloorListInitial());

  Future<void> fetchFloors(int buildingId) async {
    emit(FloorListLoading());

    final result = await _getFloorsUseCase(buildingId);

    result.fold(
      (failure) => emit(FloorListError(failure.message)),
      (floors) => emit(FloorListLoaded(floors)),
    );
  }
}
