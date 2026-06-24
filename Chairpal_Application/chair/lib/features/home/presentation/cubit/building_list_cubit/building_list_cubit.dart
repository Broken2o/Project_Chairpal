import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_buildings_usecase.dart';
import 'building_list_state.dart';

class BuildingListCubit extends Cubit<BuildingListState> {
  final GetBuildingsUseCase _getBuildingsUseCase;

  BuildingListCubit({required GetBuildingsUseCase getBuildingsUseCase})
      : _getBuildingsUseCase = getBuildingsUseCase,
        super(BuildingListInitial());

  Future<void> fetchBuildings(int organizationId) async {
    emit(BuildingListLoading());

    final result = await _getBuildingsUseCase(organizationId);

    result.fold(
      (failure) => emit(BuildingListError(failure.message)),
      (buildings) => emit(BuildingListLoaded(buildings)),
    );
  }
}
