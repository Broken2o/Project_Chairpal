import 'package:equatable/equatable.dart';
import 'place.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final List<Place>? organizations;

  const Category({
    required this.id,
    required this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.organizations,
  });

  @override
  List<Object?> get props => [id, name, image, createdAt, updatedAt, organizations];
}
