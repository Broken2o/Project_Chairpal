import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class AddCategoryState extends Equatable {
  const AddCategoryState();

  @override
  List<Object?> get props => [];
}

class AddCategoryInitial extends AddCategoryState {}

class AddCategoryLoading extends AddCategoryState {}

class AddCategorySuccess extends AddCategoryState {
  final Category category;

  const AddCategorySuccess(this.category);

  @override
  List<Object?> get props => [category];
}

class AddCategoryError extends AddCategoryState {
  final String message;

  const AddCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
