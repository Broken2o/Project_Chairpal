import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'edit_delete_state.dart';
import '../../../../home/domain/usecases/update_organization_usecase.dart';
import '../../../../home/domain/usecases/delete_organization_usecase.dart';
import '../../../../home/domain/usecases/update_building_usecase.dart';
import '../../../../home/domain/usecases/delete_building_usecase.dart';
import '../../../../home/domain/usecases/update_place_in_floor_usecase.dart';
import '../../../../home/domain/usecases/delete_place_in_floor_usecase.dart';

class EditDeleteCubit extends Cubit<EditDeleteState> {
  final UpdateOrganizationUseCase updateOrganizationUseCase;
  final DeleteOrganizationUseCase deleteOrganizationUseCase;
  final UpdateBuildingUseCase updateBuildingUseCase;
  final DeleteBuildingUseCase deleteBuildingUseCase;
  final UpdatePlaceInFloorUseCase updatePlaceInFloorUseCase;
  final DeletePlaceInFloorUseCase deletePlaceInFloorUseCase;

  EditDeleteCubit({
    required this.updateOrganizationUseCase,
    required this.deleteOrganizationUseCase,
    required this.updateBuildingUseCase,
    required this.deleteBuildingUseCase,
    required this.updatePlaceInFloorUseCase,
    required this.deletePlaceInFloorUseCase,
  }) : super(EditDeleteInitial());

  Future<void> updateOrganization(int id, {String? name, int? categoryId, String? categoryName, String? countryName, String? cityName, String? description, File? image, double? latitude, double? longitude}) async {
    emit(EditDeleteLoading());
    try {
      final String? location = (cityName != null && countryName != null) ? "$cityName, $countryName" : null;
      await updateOrganizationUseCase(id, name: name, location: location, description: description, imagePath: image?.path);
      emit(EditDeleteSuccess());
    } catch (e) {
      emit(EditDeleteError(e.toString()));
    }
  }

  Future<void> deleteOrganization(int id) async {
    emit(EditDeleteLoading());
    try {
      await deleteOrganizationUseCase(id);
      emit(EditDeleteSuccess());
    } catch (e) {
      emit(EditDeleteError(e.toString()));
    }
  }

  Future<void> updateBuilding(int id, {String? name, String? description, File? image, double? latitude, double? longitude}) async {
    emit(EditDeleteLoading());
    try {
      await updateBuildingUseCase(id, name: name, description: description, imagePath: image?.path);
      emit(EditDeleteSuccess());
    } catch (e) {
      emit(EditDeleteError(e.toString()));
    }
  }

  Future<void> deleteBuilding(int id) async {
    emit(EditDeleteLoading());
    try {
      await deleteBuildingUseCase(id);
      emit(EditDeleteSuccess());
    } catch (e) {
      emit(EditDeleteError(e.toString()));
    }
  }

  Future<void> updatePlace(int id, {String? name, int? categoryId, String? categoryName, String? description, File? image, double? latitude, double? longitude}) async {
    emit(EditDeleteLoading());
    try {
      await updatePlaceInFloorUseCase(id, name: name, description: description, imagePath: image?.path, categoryId: categoryId);
      emit(EditDeleteSuccess());
    } catch (e) {
      emit(EditDeleteError(e.toString()));
    }
  }

  Future<void> deletePlace(int id) async {
    emit(EditDeleteLoading());
    try {
      await deletePlaceInFloorUseCase(id);
      emit(EditDeleteSuccess());
    } catch (e) {
      emit(EditDeleteError(e.toString()));
    }
  }
}
