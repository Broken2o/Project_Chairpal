import '../../domain/entities/place.dart';
import '../../../../features/auth/data/models/user_model.dart';
import 'review_model.dart';

class PlaceModel extends Place {
  PlaceModel({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required String category,
    double rating = 0.0,
    List<String>? imagePaths,
    String? description,
    String? website,
    String? phone,
    String? address,
    String? openingHours,
    int reviewsCount = 0,
    bool isFavorite = false,
    String? distance,
    String? type,
    int? parentId,
    UserModel? owner,
    List<PlaceModel>? children,
    List<PlaceModel>? organizations,
    List<PlaceModel>? places,
    List<ReviewModel>? reviews,
  }) : super(
          id: id,
          name: name,
          latitude: latitude,
          longitude: longitude,
          category: category,
          rating: rating,
          imagePaths: imagePaths,
          description: description,
          website: website,
          phone: phone,
          address: address,
          openingHours: openingHours,
          reviewsCount: reviewsCount,
          isFavorite: isFavorite,
          distance: distance,
          type: type,
          parentId: parentId,
          owner: owner,
          children: children,
          organizations: organizations,
          places: places,
          reviews: reviews,
        );

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    // Handle Geoapify GeoJSON Feature format
    if (json.containsKey('properties') || json.containsKey('geometry')) {
      final properties = json['properties'] as Map<String, dynamic>? ?? {};
      final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
      final coordinates = geometry['coordinates'] as List? ?? [0.0, 0.0];
      
      final String id = properties['place_id'] ?? json['id']?.toString() ?? '';
      final String name = properties['name'] ?? properties['formatted'] ?? 'Interesting Spot';
      
      // Categorization from Geoapify categories
      final List categories = properties['categories'] as List? ?? [];
      String category = 'Interesting Spot';
      if (categories.isNotEmpty) {
        // Take the most specific category or the first one
        category = categories.first.toString().split('.').last.toUpperCase();
      }

      final String? address = properties['formatted'];
      
      // Geoapify provides images in wiki_and_media for Place Details API
      final wikiAndMedia = properties['wiki_and_media'] as Map? ?? {};
      final List<String> images = [];
      
      if (wikiAndMedia['image'] != null) {
        images.add(wikiAndMedia['image'] as String);
      }
      
      if (wikiAndMedia['images'] != null) {
        final additionalImages = wikiAndMedia['images'] as List;
        for (var img in additionalImages) {
          if (img is Map && img['url'] != null) {
            final url = img['url'] as String;
            if (!images.contains(url)) {
              images.add(url);
            }
          }
        }
      }
      
      if (images.isEmpty && properties['image'] != null) {
        images.add(properties['image'] as String);
      }
      
      // Extract rating (stars) if available (official ratings for hotels/restaurants)
      double rating = 0.0;
      if (properties['catering'] != null && properties['catering']['stars'] != null) {
        rating = (properties['catering']['stars'] as num).toDouble();
      } else if (properties['accommodation'] != null && properties['accommodation']['stars'] != null) {
        rating = (properties['accommodation']['stars'] as num).toDouble();
      } else if (properties['stars'] != null) {
        rating = (properties['stars'] as num).toDouble();
      }
      
      // Extract description
      String description = properties['description'] ?? 
                          properties['wiki_and_media']?['description'] ?? 
                          properties['wiki_description'] ?? 
                          'A popular ${category.toLowerCase()} located nearby.';

      return PlaceModel(
        id: id,
        name: name,
        latitude: (properties['lat'] ?? coordinates[1])?.toDouble() ?? 0.0,
        longitude: (properties['lon'] ?? coordinates[0])?.toDouble() ?? 0.0,
        category: category,
        rating: rating, 
        imagePaths: images.isNotEmpty ? images : null,
        description: description,
        website: properties['website'] ?? properties['contact']?['website'] ?? properties['url'],
        phone: properties['phone'] ?? properties['contact']?['phone'],
        address: address,
        openingHours: properties['opening_hours'],
      );
    }

    // Default backend format
    List<String>? images;
    if (json['image'] != null) {
      images = [json['image'] as String];
    } else if (json['images'] != null) {
      images = (json['images'] as List).map((i) => i.toString()).toList();
    }

    return PlaceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 
                double.tryParse(json['x']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 
                 double.tryParse(json['y']?.toString() ?? '') ?? 0.0,
      category: json['category'] ?? '',
      // 'average_rating' is used for organizations; fall back to 'rating' for places
      rating: double.tryParse(
                 (json['average_rating'] ?? json['rating'])?.toString() ?? '') ?? 0.0,
      imagePaths: images,
      description: json['description'],
      website: json['website'],
      phone: json['phone'],
      address: json['address'],
      openingHours: json['opening_hours'],
      reviewsCount: int.tryParse(json['reviews_count']?.toString() ?? '') ?? 0,
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
      distance: json['distance']?.toString(),
      type: json['type'],
      parentId: json['parent_id'] != null ? int.tryParse(json['parent_id'].toString()) : null,
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : null,
      children: json['children'] != null ? (json['children'] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
      organizations: json['organizations'] != null ? (json['organizations'] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
      places: json['places'] != null ? (json['places'] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
      // Backend returns reviews as 'top_reviews' for organizations, 'reviews' for places
      reviews: (json['top_reviews'] ?? json['reviews']) != null
          ? ((json['top_reviews'] ?? json['reviews']) as List)
              .map((i) => ReviewModel.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'rating': rating,
      'description': description,
      'website': website,
      'phone': phone,
      'address': address,
      'opening_hours': openingHours,
    };
  }
}
