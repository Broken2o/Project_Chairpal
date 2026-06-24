import 'package:flutter_test/flutter_test.dart';
import 'package:chair_pal/features/home/data/models/category_model.dart';
import 'package:chair_pal/features/home/domain/entities/category.dart';

void main() {
  const tCategoryModel = CategoryModel(
    id: 16,
    name: 'main cat 3',
    image: 'http://127.0.0.1:8000/storage/categories/image.png',
    createdAt: '22 Mar 2026 - 02:02 PM',
    updatedAt: '22 Mar 2026 - 02:02 PM',
  );

  group('CategoryModel', () {
    test('should be a subclass of Category entity', () {
      expect(tCategoryModel, isA<Category>());
    });

    test('fromJson should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 16,
        "name": "main cat 3",
        "image": "http://127.0.0.1:8000/storage/categories/image.png",
        "created_at": "22 Mar 2026 - 02:02 PM",
        "updated_at": "22 Mar 2026 - 02:02 PM"
      };

      // act
      final result = CategoryModel.fromJson(jsonMap);

      // assert
      expect(result, tCategoryModel);
    });

    test('toJson should return a JSON map containing the proper data', () {
      // act
      final result = tCategoryModel.toJson();

      // assert
      final expectedMap = {
        "id": 16,
        "name": "main cat 3",
        "image": "http://127.0.0.1:8000/storage/categories/image.png",
        "created_at": "22 Mar 2026 - 02:02 PM",
        "updated_at": "22 Mar 2026 - 02:02 PM"
      };
      expect(result, expectedMap);
    });
  });
}
