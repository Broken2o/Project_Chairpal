import 'package:equatable/equatable.dart';
import '../../../../features/auth/domain/entities/user.dart';
import 'review.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String category;
  final double rating;
  final List<String>? imagePaths;
  final String? description;
  final String? website;
  final String? phone;
  final String? address;
  final String? openingHours;
  final int reviewsCount;
  bool isFavorite;
  final String? distance;
  final String? type;
  final int? parentId;
  final User? owner;
  final List<Place>? children;
  final List<Place>? organizations;
  final List<Place>? places;
  final List<Review>? reviews;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.rating = 0.0,
    this.imagePaths,
    this.description,
    this.website,
    this.phone,
    this.address,
    this.openingHours,
    this.reviewsCount = 0,
    this.isFavorite = false,
    this.distance,
    this.type,
    this.parentId,
    this.owner,
    this.children,
    this.organizations,
    this.places,
    this.reviews,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        category,
        rating,
        imagePaths,
        description,
        website,
        phone,
        address,
        openingHours,
        reviewsCount,
        isFavorite,
        distance,
        type,
        parentId,
        owner,
        children,
        organizations,
        places,
        reviews,
      ];
}
