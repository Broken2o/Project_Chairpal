import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_places_by_floor_usecase.dart';
import 'place_list_state.dart';

class PlaceListCubit extends Cubit<PlaceListState> {
  final GetPlacesByFloorUseCase _getPlacesByFloorUseCase;

  PlaceListCubit({required GetPlacesByFloorUseCase getPlacesByFloorUseCase})
      : _getPlacesByFloorUseCase = getPlacesByFloorUseCase,
        super(PlaceListInitial());

  Future<void> fetchPlaces(int floorId) async {
    emit(PlaceListLoading());

    final result = await _getPlacesByFloorUseCase(floorId);

    result.fold(
      (failure) => emit(PlaceListError(failure.message)),
      (places) => emit(PlaceListLoaded(places)),
    );
  }
}
