import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/place_model.dart';
import '../models/user_dashboard_model.dart';
import '../models/doctor_dashboard_model.dart';
import '../models/admin_dashboard_model.dart';

abstract class HomeRemoteDataSource {
  Future<CategoryModel> getCategory(int id, {String? accessKey, String? include});
  Future<List<CategoryModel>> getCategories({
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
  });

  Future<List<PlaceModel>> getPopularPlaces(double lat, double lon, {String? categories});
  Future<List<PlaceModel>> searchPlaces(String text, double lat, double lon, {String? categories});
  Future<dynamic> getDashboard(int userId, String role, {String? filter});
  Future<List<PlaceModel>> getLastVisitedPlaces(int userId);

  Future<CategoryModel> createCategory({required String name, int? parentId, int? organizationId, File? image});
  Future<CategoryModel> updateCategory(int id, {String? name, int? parentId, List<int>? organizationIds, File? image});
  Future<void> deleteCategory(int id);

  Future<PlaceModel> createOrganization({
    required String name,
    int? categoryId,
    String? categoryName,
    required String countryName,
    required String cityName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  });

  Future<List<PlaceModel>> getBuildings(int organizationId);
  Future<PlaceModel> createBuilding({
    required int organizationId,
    required String name,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  });

  Future<List<PlaceModel>> getFloors(int buildingId);
  Future<PlaceModel> createFloor({
    required int buildingId,
    required String name,
    int? level,
    String? description,
    File? image,
  });

  Future<List<PlaceModel>> getPlacesByFloor(int floorId);
  Future<PlaceModel> createPlaceInFloor({
    required int floorId,
    required String name,
    int? categoryId,
    String? categoryName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  });

  Future<List<dynamic>> getWheelchairSensorReadings(int wheelchairId, {int? page});
  Future<dynamic> getWheelchairHealth(int wheelchairId);

  Future<void> updateOrganization({required int id, String? name, String? location, String? description, String? imagePath});
  Future<void> deleteOrganization(int id);
  Future<void> updateBuilding({required int id, String? name, String? description, String? imagePath});
  Future<void> deleteBuilding(int id);
  Future<void> updatePlaceInFloor({required int id, String? name, String? description, String? imagePath, int? categoryId});
  Future<void> deletePlaceInFloor(int id);
  Future<void> addReview(String type, int placeId, double rating, String comment);
  Future<void> deleteReview(int reviewId);
  Future<void> toggleFavorite(String type, String id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _dioClient;

  HomeRemoteDataSourceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  @override
  Future<CategoryModel> getCategory(int id, {String? accessKey, String? include}) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.getCategoryEndpoint}$id',
        queryParameters: {
          if (accessKey != null) 'access_key': accessKey,
          if (include != null) 'include': include,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return CategoryModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get category',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories({
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
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.getCategoriesEndpoint,
        queryParameters: {
          if (include != null) 'include': include,
          if (mainOnly != null) 'main_only': mainOnly ? 1 : 0,
          if (hasOrganizations != null) 'has_organizations': hasOrganizations ? 1 : 0,
          if (hasPlaces != null) 'has_places': hasPlaces ? 1 : 0,
          if (organizationId != null) 'organization_id': organizationId,
          if (parentId != null) 'parent_id': parentId,
          if (ownerId != null) 'owner_id': ownerId,
          if (countryId != null) 'country_id': countryId,
          if (cityId != null) 'city_id': cityId,
          if (createdFrom != null) 'created_from': createdFrom,
          if (createdTo != null) 'created_to': createdTo,
          if (minPlaces != null) 'min_places': minPlaces,
          if (minOrganizations != null) 'min_organizations': minOrganizations,
          if (sortBy != null) 'sort_by': sortBy,
          if (sortDirection != null) 'sort_direction': sortDirection,
          if (pagination != null) 'pagination': pagination,
          if (limit != null) 'limit': limit,
          if (search != null) 'search': search,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get categories',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryModel> createCategory({required String name, int? parentId, int? organizationId, File? image}) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (parentId != null) 'parent_id': parentId.toString(),
        if (organizationId != null) 'organization_id': organizationId.toString(),
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dioClient.dio.post(
        ApiConstants.getCategoriesEndpoint,
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return CategoryModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to create category',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryModel> updateCategory(int id, {String? name, int? parentId, List<int>? organizationIds, File? image}) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PUT',
        if (name != null) 'name': name,
        if (parentId != null) 'parent_id': parentId.toString(),
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      if (organizationIds != null) {
        for (int orgId in organizationIds) {
          formData.fields.add(MapEntry('organization_ids[]', orgId.toString()));
        }
      }

      final response = await _dioClient.dio.post(
        '${ApiConstants.getCategoryEndpoint}$id',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return CategoryModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to update category',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      final response = await _dioClient.dio.delete(
        '${ApiConstants.getCategoryEndpoint}$id',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data?['message'] ?? 'Failed to delete category',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlaceModel>> getPopularPlaces(double lat, double lon, {String? categories}) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.geoapifyBaseUrl}${ApiConstants.geoapifyPlacesEndpoint}',
        queryParameters: {
          'categories': categories ?? 'tourism,tourism.attraction,tourism.sights,entertainment,leisure.park,catering.restaurant',
          'filter': 'circle:$lon,$lat,5000',
          'limit': 10,
          'apiKey': ApiConstants.geoapifyApiKey,
        },
      );

      if (response.statusCode == 200) {
        final List features = response.data['features'];
        final List<PlaceModel> places = [];

        for (var feature in features) {
          final placeModel = PlaceModel.fromJson(feature);
          
          if (placeModel.id.isEmpty) {
            places.add(placeModel);
            continue;
          }

          // To get images, we need to call Place Details API for each place
          try {
            final detailsResponse = await _dioClient.dio.get(
              '${ApiConstants.geoapifyBaseUrl}${ApiConstants.geoapifyPlaceDetailsEndpoint}',
              queryParameters: {
                'id': placeModel.id,
                'features': 'details,contact,wiki_and_media',
                'apiKey': ApiConstants.geoapifyApiKey,
              },
            );

            if (detailsResponse.statusCode == 200) {
              final detailsFeature = detailsResponse.data['features'][0];
              places.add(PlaceModel.fromJson(detailsFeature));
            } else {
              places.add(placeModel);
            }
          } catch (e) {
            // Fallback to basic place model if details fetch fails
            places.add(placeModel);
          }
        }
        return places;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get popular places from Geoapify',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlaceModel>> searchPlaces(String text, double lat, double lon, {String? categories}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.geoapifyAutocompleteEndpoint,
        queryParameters: {
          'text': text,
          if (categories != null) 'categories': categories,
          'filter': 'circle:$lon,$lat,5000',
          'limit': 10,
          'apiKey': ApiConstants.geoapifyApiKey,
        },
      );

      if (response.statusCode == 200) {
        final List features = response.data['features'];
        final List<PlaceModel> places = [];

        for (var feature in features) {
          final placeModel = PlaceModel.fromJson(feature);
          
          if (placeModel.id.isEmpty) {
            places.add(placeModel);
            continue;
          }

          // Re-using same logic to get images for search results
          try {
            final detailsResponse = await _dioClient.dio.get(
              '${ApiConstants.geoapifyBaseUrl}${ApiConstants.geoapifyPlaceDetailsEndpoint}',
              queryParameters: {
                'id': placeModel.id,
                'features': 'details,contact,wiki_and_media',
                'apiKey': ApiConstants.geoapifyApiKey,
              },
            );

            if (detailsResponse.statusCode == 200) {
              final detailsFeature = detailsResponse.data['features'][0];
              places.add(PlaceModel.fromJson(detailsFeature));
            } else {
              places.add(placeModel);
            }
          } catch (e) {
            places.add(placeModel);
          }
        }
        return places;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to search places from Geoapify',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getDashboard(int userId, String role, {String? filter}) async {
    try {
      String endpoint = 'dashboard';
      if (role == 'companion') {
        endpoint = ApiConstants.dashboardCompanionEndpoint;
      } else if (role == 'doctor') {
        endpoint = ApiConstants.dashboardDoctorEndpoint;
      } else if (role == 'org-admin') {
        endpoint = ApiConstants.dashboardAdminEndpoint;
      }

      final Map<String, dynamic> queryParams = {};
      if (filter != null) {
        queryParams['filter'] = filter;
      }

      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (role == 'doctor') {
          return DoctorDashboardModel.fromJson(data);
        } else if (role == 'org-admin') {
          return AdminDashboardModel.fromJson(data);
        } else {
          return UserDashboardModel.fromJson(data);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get dashboard',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  @override
  Future<List<PlaceModel>> getLastVisitedPlaces(int userId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.lastVisitedPlacesEndpoint,
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get last visited places',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PlaceModel> createOrganization({
    required String name,
    int? categoryId,
    String? categoryName,
    required String countryName,
    required String cityName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (categoryName != null) 'category_name': categoryName,
        'country_name': countryName,
        'city_name': cityName,
        if (description != null) 'description': description,
        if (latitude != null) 'latitude': latitude.toString(),
        if (longitude != null) 'longitude': longitude.toString(),
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dioClient.dio.post(
        '/organizations',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return PlaceModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to create organization',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlaceModel>> getBuildings(int organizationId) async {
    try {
      final response = await _dioClient.dio.get('/organizations/$organizationId/buildings');

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get buildings',
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 403) {
        // Backend policy bug fallback: fetch organization with includes
        try {
          final fallbackResponse = await _dioClient.dio.get('/organizations/$organizationId?include=buildings');
          if (fallbackResponse.statusCode == 200) {
            final List buildingsData = fallbackResponse.data['data']['buildings'] ?? [];
            return buildingsData.map((json) => PlaceModel.fromJson(json)).toList();
          }
        } catch (_) {}
        return []; // Return empty instead of crashing the UI
      }
      rethrow;
    }
  }

  @override
  Future<PlaceModel> createBuilding({
    required int organizationId,
    required String name,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (description != null) 'description': description,
        if (latitude != null) 'latitude': latitude.toString(),
        if (longitude != null) 'longitude': longitude.toString(),
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dioClient.dio.post(
        '/organizations/$organizationId/buildings',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return PlaceModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to create building',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<PlaceModel>> getFloors(int buildingId) async {
    try {
      final response = await _dioClient.dio.get('/buildings/$buildingId/floors');

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get floors',
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 403) {
        // Backend policy bug fallback: fetch building with includes
        try {
          final fallbackResponse = await _dioClient.dio.get('/buildings/$buildingId?include=floors');
          if (fallbackResponse.statusCode == 200) {
            final List floorsData = fallbackResponse.data['data']['floors'] ?? [];
            return floorsData.map((json) => PlaceModel.fromJson(json)).toList();
          }
        } catch (_) {}
        return []; // Return empty instead of crashing the UI
      }
      rethrow;
    }
  }

  @override
  Future<PlaceModel> createFloor({
    required int buildingId,
    required String name,
    int? level,
    String? description,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (level != null) 'number': level.toString(),
        if (description != null) 'description': description,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dioClient.dio.post(
        '/buildings/$buildingId/floors',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return PlaceModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to create floor',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<PlaceModel>> getPlacesByFloor(int floorId) async {
    try {
      final response = await _dioClient.dio.get('/floors/$floorId/places');

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get places',
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 403) {
        // Backend policy bug fallback: fetch floor with includes
        try {
          final fallbackResponse = await _dioClient.dio.get('/floors/$floorId?include=places');
          if (fallbackResponse.statusCode == 200) {
            final List placesData = fallbackResponse.data['data']['places'] ?? [];
            return placesData.map((json) => PlaceModel.fromJson(json)).toList();
          }
        } catch (_) {}
        return []; // Return empty instead of crashing the UI
      }
      rethrow;
    }
  }

  @override
  Future<PlaceModel> createPlaceInFloor({
    required int floorId,
    required String name,
    int? categoryId,
    String? categoryName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (categoryName != null) 'category_name': categoryName,
        if (description != null) 'description': description,
        if (latitude != null) 'latitude': latitude.toString(),
        if (longitude != null) 'longitude': longitude.toString(),
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await _dioClient.dio.post(
        '/floors/$floorId/places',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return PlaceModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to create place',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getWheelchairSensorReadings(int wheelchairId, {int? page}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (page != null) queryParams['page'] = page;

      final response = await _dioClient.dio.get(
        ApiConstants.wheelchairSensorReadingsEndpoint(wheelchairId),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // The API returns paginated data inside ['data']['data']
        final List data = response.data['data']['data'];
        return data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get sensor readings',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getWheelchairHealth(int wheelchairId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.wheelchairHealthEndpoint(wheelchairId),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get health state',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateOrganization({required int id, String? name, String? location, String? description, String? imagePath}) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PUT',
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        // Assuming location includes country/city or is just a text field depending on the backend, skipping complex nested if not provided
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.dio.post(
        '/organizations/$id',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to update organization');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> deleteOrganization(int id) async {
    try {
      final response = await _dioClient.dio.delete('/organizations/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to delete organization');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> updateBuilding({required int id, String? name, String? description, String? imagePath}) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PUT',
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.dio.post(
        '/buildings/$id',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to update building');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> deleteBuilding(int id) async {
    try {
      final response = await _dioClient.dio.delete('/buildings/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to delete building');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> updatePlaceInFloor({required int id, String? name, String? description, String? imagePath, int? categoryId}) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PUT',
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.dio.post(
        '/places/$id',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to update place');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> deletePlaceInFloor(int id) async {
    try {
      final response = await _dioClient.dio.delete('/places/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to delete place');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> addReview(String type, int placeId, double rating, String comment) async {
    try {
      final endpointType = '${type.toLowerCase()}s';
      final response = await _dioClient.dio.post(
        '/$endpointType/$placeId/reviews',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to add review');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    try {
      final response = await _dioClient.dio.delete('/reviews/$reviewId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to delete review');
      }
    } catch (e) { rethrow; }
  }

  @override
  Future<void> toggleFavorite(String type, String id) async {
    try {
      // type might be "Place", "Organization", etc. Let's make it plural and lowercase
      final endpointType = '${type.toLowerCase()}s';
      print('--- toggleFavorite Request ---');
      print('POST /api/$endpointType/$id/favorite');
      final response = await _dioClient.dio.post('/$endpointType/$id/favorite');
      print('--- toggleFavorite Response ---');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Failed to toggle favorite');
      }
    } catch (e) { 
      print('--- toggleFavorite Error ---');
      print(e);
      rethrow; 
    }
  }
}
