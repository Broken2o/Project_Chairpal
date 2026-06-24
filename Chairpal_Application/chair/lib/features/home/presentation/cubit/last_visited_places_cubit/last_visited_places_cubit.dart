import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/repositories/home_repository.dart';
import 'last_visited_places_state.dart';

class LastVisitedPlacesCubit extends Cubit<LastVisitedPlacesState> {
  final HomeRepository _homeRepository;

  LastVisitedPlacesCubit({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(LastVisitedPlacesInitial());

  Future<void> fetchLastVisitedPlaces(int userId) async {
    emit(LastVisitedPlacesLoading());
    try {
      final places = await _homeRepository.getLastVisitedPlaces(userId);
      if (isClosed) return;
      emit(LastVisitedPlacesLoaded(places));
    } catch (e) {
      if (isClosed) return;
      if (e is DioException) {
        String errorMessage = 'Network error';
        if (e.response != null && e.response?.data != null) {
          final data = e.response?.data;
          if (data is Map && data.containsKey('message')) {
            errorMessage = data['message'];
          } else {
            errorMessage = e.response?.statusMessage ?? 'Server error ${e.response?.statusCode}';
          }
        } else {
          errorMessage = e.message ?? 'Network error';
        }
        emit(LastVisitedPlacesError(errorMessage));
      } else {
        emit(LastVisitedPlacesError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }
}
