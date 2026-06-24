import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../../../domain/repositories/home_repository.dart';
import 'popular_places_state.dart';

class PopularPlacesCubit extends Cubit<PopularPlacesState> {
  final HomeRepository _homeRepository;

  PopularPlacesCubit({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(PopularPlacesInitial());

  Future<void> fetchPopularPlaces({String? category}) async {
    final String? currentSelected = state is PopularPlacesLoaded 
        ? (state as PopularPlacesLoaded).selectedCategory 
        : (state is PopularPlacesLoading ? (state as PopularPlacesLoading).selectedCategory : null);

    // Toggle logic: if same category is selected, clear it
    final String? newCategory = currentSelected == category ? null : category;

    emit(PopularPlacesLoading(selectedCategory: newCategory));
    try {
      // 1. Get current position
      final position = await _getCurrentPosition();
      
      // 2. Fetch from repository
      String? geoapifyCategory;
      if (newCategory != null) {
        geoapifyCategory = _mapCategoryToGeoapify(newCategory);
      }

      final places = await _homeRepository.getPopularPlaces(
        position.latitude,
        position.longitude,
        categories: geoapifyCategory,
      );

      if (isClosed) return;
      emit(PopularPlacesLoaded(
        places, 
        userPosition: position, 
        selectedCategory: newCategory,
      ));
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
        emit(PopularPlacesError(errorMessage));
      } else {
        emit(PopularPlacesError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> searchPopularPlaces(String query) async {
    if (query.isEmpty) {
      final String? currentSelected = state is PopularPlacesLoaded 
          ? (state as PopularPlacesLoaded).selectedCategory 
          : (state is PopularPlacesLoading ? (state as PopularPlacesLoading).selectedCategory : null);
      
      return fetchPopularPlaces(category: currentSelected);
    }

    final String? currentSelected = state is PopularPlacesLoaded 
        ? (state as PopularPlacesLoaded).selectedCategory 
        : (state is PopularPlacesLoading ? (state as PopularPlacesLoading).selectedCategory : null);

    emit(PopularPlacesLoading(selectedCategory: currentSelected));
    try {
      final position = await _getCurrentPosition();
      
      String? geoapifyCategory;
      if (currentSelected != null) {
        geoapifyCategory = _mapCategoryToGeoapify(currentSelected);
      }

      final places = await _homeRepository.searchPlaces(
        query,
        position.latitude,
        position.longitude,
        categories: geoapifyCategory,
      );

      if (isClosed) return;
      emit(PopularPlacesLoaded(
        places, 
        userPosition: position, 
        selectedCategory: currentSelected,
      ));
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
        emit(PopularPlacesError(errorMessage));
      } else {
        emit(PopularPlacesError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  String _mapCategoryToGeoapify(String category) {
    // Map existing category names to Geoapify categories
    final map = {
      'Tourism': 'tourism',
      'Food': 'catering.restaurant,catering.cafe',
      'Parks': 'leisure.park,leisure.garden',
      'Shopping': 'commercial.shopping_mall,commercial.supermarket',
      'Historic': 'historic',
      'Entertainment': 'entertainment',
    };
    return map[category] ?? category.toLowerCase();
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }
}
