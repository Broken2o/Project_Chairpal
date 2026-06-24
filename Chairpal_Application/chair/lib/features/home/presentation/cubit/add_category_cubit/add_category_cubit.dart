import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/usecases/create_category_use_case.dart';
import 'add_category_state.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  final CreateCategoryUseCase createCategoryUseCase;

  AddCategoryCubit({required this.createCategoryUseCase}) : super(AddCategoryInitial());

  Future<void> createCategory({required String name, int? parentId, int? organizationId, File? image}) async {
    emit(AddCategoryLoading());
    try {
      final category = await createCategoryUseCase(
        name: name,
        parentId: parentId,
        organizationId: organizationId,
        image: image,
      );
      emit(AddCategorySuccess(category));
    } catch (e) {
      if (e is DioException && e.response != null) {
        final message = e.response?.data['message'] ?? 'Failed to create category';
        emit(AddCategoryError(message));
      } else {
        emit(AddCategoryError(e.toString()));
      }
    }
  }
}
