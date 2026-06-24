import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_state.dart';
import '../../../../home/domain/usecases/toggle_favorite_usecase.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoriteCubit({required this.toggleFavoriteUseCase}) : super(FavoriteInitial());

  Future<void> toggleFavorite(String type, String id) async {
    print('FavoriteCubit: toggleFavorite called with type=$type, id=$id');
    emit(FavoriteLoading());
    try {
      await toggleFavoriteUseCase(type, id);
      print('FavoriteCubit: toggleFavorite SUCCESS');
      emit(FavoriteSuccess());
    } catch (e) {
      print('FavoriteCubit: toggleFavorite ERROR: $e');
      emit(FavoriteError(e.toString()));
    }
  }
}
