import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class CategoryDetailsState extends Equatable {
  const CategoryDetailsState();

  @override
  List<Object?> get props => [];
}

class CategoryDetailsInitial extends CategoryDetailsState {}

class CategoryDetailsLoading extends CategoryDetailsState {}

class CategoryDetailsLoaded extends CategoryDetailsState {
  final Category category;

  const CategoryDetailsLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryDetailsError extends CategoryDetailsState {
  final String message;

  const CategoryDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
