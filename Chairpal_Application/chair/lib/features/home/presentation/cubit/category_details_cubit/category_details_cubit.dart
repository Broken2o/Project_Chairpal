import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/repositories/home_repository.dart';
import 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  final HomeRepository repository;

  CategoryDetailsCubit({required this.repository}) : super(CategoryDetailsInitial());

  Future<void> fetchCategoryDetails(int id) async {
    emit(CategoryDetailsLoading());
    try {
      final category = await repository.getCategory(
        id,
        include: 'owner,parent,children,organizations,organizations.owner,organizations.categories,organizations.country,organizations.city,places,places.owner,places.categories,places.reviews,places.favoritedBy',
      );
      emit(CategoryDetailsLoaded(category));
    } catch (e) {
      if (e is DioException && e.response != null) {
        final message = e.response?.data['message'] ?? 'Failed to load category';
        emit(CategoryDetailsError(message));
      } else {
        emit(CategoryDetailsError(e.toString()));
      }
    }
  }
}
