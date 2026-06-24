import 'dart:io';
import '../../domain/entities/category.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Category> getCategory(int id, {String? accessKey, String? include}) async {
    return await remoteDataSource.getCategory(id, accessKey: accessKey, include: include);
  }

  @override
  Future<List<Category>> getCategories({
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
    return await remoteDataSource.getCategories(
      include: include,
      mainOnly: mainOnly,
      hasOrganizations: hasOrganizations,
      hasPlaces: hasPlaces,
      organizationId: organizationId,
      parentId: parentId,
      ownerId: ownerId,
      countryId: countryId,
      cityId: cityId,
      createdFrom: createdFrom,
      createdTo: createdTo,
      minPlaces: minPlaces,
      minOrganizations: minOrganizations,
      sortBy: sortBy,
      sortDirection: sortDirection,
      pagination: pagination,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<Category> createCategory({required String name, int? parentId, int? organizationId, File? image}) async {
    return await remoteDataSource.createCategory(
      name: name,
      parentId: parentId,
      organizationId: organizationId,
      image: image,
    );
  }

  @override
  Future<Category> updateCategory(int id, {String? name, int? parentId, List<int>? organizationIds, File? image}) async {
    return await remoteDataSource.updateCategory(
      id,
      name: name,
      parentId: parentId,
      organizationIds: organizationIds,
      image: image,
    );
  }

  @override
  Future<void> deleteCategory(int id) async {
    return await remoteDataSource.deleteCategory(id);
  }

  @override
  Future<List<Place>> getOrganizations({String? search, String? include, int? categoryId}) async {
    // TODO: Implement getOrganizations with query params in data source
    throw UnimplementedError('getOrganizations not yet implemented in data source');
  }

  @override
  Future<Place> createOrganization({
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
    return await remoteDataSource.createOrganization(
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      countryName: countryName,
      cityName: cityName,
      description: description,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> updateOrganization({required int id, String? name, String? location, String? description, String? imagePath}) async {
    return await remoteDataSource.updateOrganization(id: id, name: name, location: location, description: description, imagePath: imagePath);
  }

  @override
  Future<void> deleteOrganization(int id) async {
    return await remoteDataSource.deleteOrganization(id);
  }

  @override
  Future<List<Place>> getBuildings(int organizationId) async {
    return await remoteDataSource.getBuildings(organizationId);
  }

  @override
  Future<Place> createBuilding({
    required int organizationId,
    required String name,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    return await remoteDataSource.createBuilding(
      organizationId: organizationId,
      name: name,
      description: description,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> updateBuilding({required int id, String? name, String? description, String? imagePath}) async {
    return await remoteDataSource.updateBuilding(id: id, name: name, description: description, imagePath: imagePath);
  }

  @override
  Future<void> deleteBuilding(int id) async {
    return await remoteDataSource.deleteBuilding(id);
  }

  @override
  Future<List<Place>> getFloors(int buildingId) async {
    return await remoteDataSource.getFloors(buildingId);
  }

  @override
  Future<Place> createFloor({
    required int buildingId,
    required String name,
    int? level,
    String? description,
    File? image,
  }) async {
    return await remoteDataSource.createFloor(
      buildingId: buildingId,
      name: name,
      level: level,
      description: description,
      image: image,
    );
  }

  @override
  Future<List<Place>> getPlacesByFloor(int floorId) async {
    return await remoteDataSource.getPlacesByFloor(floorId);
  }

  @override
  Future<Place> createPlaceInFloor({
    required int floorId,
    required String name,
    int? categoryId,
    String? categoryName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    return await remoteDataSource.createPlaceInFloor(
      floorId: floorId,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> updatePlaceInFloor({required int id, String? name, String? description, String? imagePath, int? categoryId}) async {
    return await remoteDataSource.updatePlaceInFloor(id: id, name: name, description: description, imagePath: imagePath, categoryId: categoryId);
  }

  @override
  Future<void> deletePlaceInFloor(int id) async {
    return await remoteDataSource.deletePlaceInFloor(id);
  }

  @override
  Future<List<Place>> getPopularPlaces(double lat, double lon, {String? categories}) async {
    return await remoteDataSource.getPopularPlaces(lat, lon, categories: categories);
  }

  @override
  Future<List<Place>> searchPlaces(String text, double lat, double lon, {String? categories}) async {
    return await remoteDataSource.searchPlaces(text, lat, lon, categories: categories);
  }

  @override
  Future<List<Place>> getLastVisitedPlaces(int userId) async {
    return await remoteDataSource.getLastVisitedPlaces(userId);
  }

  @override
  Future<List<Review>> getReviews(int placeId) async {
    // Usually reviews are loaded along with the place using ?include=reviews
    // but if we need a dedicated call, it would be another endpoint like GET /places/{placeId}/reviews
    // Assuming we don't have a direct list reviews endpoint, or if we do:
    // Let's implement it to return empty or we'd add it to data source.
    // For now, let's keep it throwing or returning empty since the app relies on place model
    return [];
  }

  @override
  Future<void> addReview(String type, int placeId, double rating, String comment) async {
    return await remoteDataSource.addReview(type, placeId, rating, comment);
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    return await remoteDataSource.deleteReview(reviewId);
  }

  @override
  Future<void> toggleFavorite(String type, String id) async {
    return await remoteDataSource.toggleFavorite(type, id);
  }

  @override
  Future<dynamic> getDashboard(int userId, String role, {String? filter}) async {
    return await remoteDataSource.getDashboard(userId, role, filter: filter);
  }

  @override
  Future<List<dynamic>> getWheelchairSensorReadings(int wheelchairId, {int? page}) async {
    return await remoteDataSource.getWheelchairSensorReadings(wheelchairId, page: page);
  }

  @override
  Future<dynamic> getWheelchairHealth(int wheelchairId) async {
    return await remoteDataSource.getWheelchairHealth(wheelchairId);
  }
}
