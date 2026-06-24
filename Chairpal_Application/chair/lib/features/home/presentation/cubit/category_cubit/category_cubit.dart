import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/repositories/home_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final HomeRepository _homeRepository;

  CategoryCubit({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(CategoryInitial());

  Future<void> fetchCategory(int id, {String? accessKey, String? include}) async {
    emit(CategoryLoading());

    try {
      final category = await _homeRepository.getCategory(
        id,
        accessKey: accessKey,
        include: include,
      );
      emit(CategorySuccess(category: category));
    } catch (e) {
      if (e is DioException) {
        emit(CategoryError(message: e.error?.toString() ?? e.message ?? 'Network error'));
      } else {
        emit(CategoryError(message: e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> fetchCategories({
    String? include = 'owner,organizations,organizations.categories,parent,children,places',
    bool? mainOnly,
    bool? hasOrganizations,
    bool? hasPlaces,
    int? organizationId,
    int? parentId,
    int? ownerId,
    int? countryId,
    int? cityId,
    String? createdFrom,
    String? createdTo,
    int? minPlaces,
    int? minOrganizations,
    String? sortBy,
    String? sortDirection,
    int? pagination,
    int? limit,
    String? search,
  }) async {
    emit(CategoryLoading());

    try {
      final categories = await _homeRepository.getCategories(
        include: include,
        mainOnly: mainOnly,
        hasOrganizations: hasOrganizations,
        hasPlaces: hasPlaces,
        organizationId: organizationId,
        parentId: parentId,
        ownerId: ownerId,
        countryId: countryId,
        cityId: cityId,
        createdFrom: createdFrom,
        createdTo: createdTo,
        minPlaces: minPlaces,
        minOrganizations: minOrganizations,
        sortBy: sortBy,
        sortDirection: sortDirection,
        pagination: pagination,
        limit: limit,
        search: search,
      );
      emit(CategoriesSuccess(categories: categories));
    } catch (e) {
      if (e is DioException) {
        emit(CategoryError(message: e.error?.toString() ?? e.message ?? 'Network error'));
      } else {
        emit(CategoryError(message: e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }
}
