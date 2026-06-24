import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;

  FavoritesCubit({required GetFavoritesUseCase getFavoritesUseCase})
      : _getFavoritesUseCase = getFavoritesUseCase,
        super(FavoritesInitial());

  Future<void> fetchFavorites() async {
    emit(FavoritesLoading());
    final result = await _getFavoritesUseCase();

    if (result is ApiSuccess) {
      emit(FavoritesLoaded(result.data));
    } else if (result is ApiError) {
      emit(FavoritesError(result.failure.message));
    }
  }
}
