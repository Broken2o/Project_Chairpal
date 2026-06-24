import 'dart:io';
import '../entities/category.dart';
import '../entities/place.dart';
import '../entities/review.dart';

abstract class HomeRepository {
  // ── Category operations ──────────────────────────────
  Future<Category> getCategory(int id, {String? accessKey, String? include});

  Future<List<Category>> getCategories({
    String? include,
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

  Future<Category> createCategory({
    required String name,
    int? parentId,
    int? organizationId,
    File? image,
  });

  Future<Category> updateCategory(
    int id, {
    String? name,
    int? parentId,
    List<int>? organizationIds,
    File? image,
  });

  Future<void> deleteCategory(int id);

  // ── Organization operations ──────────────────────────
  Future<List<Place>> getOrganizations({
    String? search,
    String? include,
    int? categoryId,
  });

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
  });

  Future<void> updateOrganization({
    required int id,
    String? name,
    String? location,
    String? description,
    String? imagePath,
  });

  Future<void> deleteOrganization(int id);

  // ── Building operations ──────────────────────────────
  Future<List<Place>> getBuildings(int organizationId);

  Future<Place> createBuilding({
    required int organizationId,
    required String name,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  });

  Future<void> updateBuilding({
    required int id,
    String? name,
    String? description,
    String? imagePath,
  });

  Future<void> deleteBuilding(int id);

  // ── Floor operations ─────────────────────────────────
  Future<List<Place>> getFloors(int buildingId);

  Future<Place> createFloor({
    required int buildingId,
    required String name,
    int? level,
    String? description,
    File? image,
  });

  // ── Place in floor operations ────────────────────────
  Future<List<Place>> getPlacesByFloor(int floorId);

  Future<Place> createPlaceInFloor({
    required int floorId,
    required String name,
    int? categoryId,
    String? categoryName,
    String? description,
    File? image,
    double? latitude,
    double? longitude,
  });

  Future<void> updatePlaceInFloor({
    required int id,
    String? name,
    String? description,
    String? imagePath,
    int? categoryId,
  });

  Future<void> deletePlaceInFloor(int id);

  // ── Places (Geoapify) ───────────────────────────────
  Future<List<Place>> getPopularPlaces(
    double lat,
    double lon, {
    String? categories,
  });

  Future<List<Place>> searchPlaces(
    String text,
    double lat,
    double lon, {
    String? categories,
  });

  Future<List<Place>> getLastVisitedPlaces(int userId);

  // ── Reviews ──────────────────────────────────────────
  Future<List<Review>> getReviews(int placeId);
  Future<void> addReview(String type, int placeId, double rating, String comment);
  Future<void> deleteReview(int reviewId);

  // ── Favorites ────────────────────────────────────────
  Future<void> toggleFavorite(String type, String id);

  // ── Dashboard ────────────────────────────────────────
  Future<dynamic> getDashboard(int userId, String role, {String? filter});

  // ── Wheelchair ───────────────────────────────────────
  Future<List<dynamic>> getWheelchairSensorReadings(
    int wheelchairId, {
    int? page,
  });
  Future<dynamic> getWheelchairHealth(int wheelchairId);
}
