import '../../domain/entities/category.dart';
import '../../domain/entities/place.dart';
import 'place_model.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.image,
    super.createdAt,
    super.updatedAt,
    super.organizations,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      organizations: json['organizations'] != null
          ? (json['organizations'] as List)
              .map<Place>((e) => PlaceModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'organizations': organizations?.map((e) => (e as PlaceModel).toJson()).toList(),
    };
  }
}
