import 'package:equatable/equatable.dart';

import '../../../domain/entities/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final Category category;

  const CategorySuccess({required this.category});

  @override
  List<Object?> get props => [category];
}

class CategoriesSuccess extends CategoryState {
  final List<Category> categories;

  const CategoriesSuccess({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
