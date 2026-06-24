import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class CreatePlaceInFloorUseCase {
  final HomeRepository repository;

  CreatePlaceInFloorUseCase(this.repository);

  Future<Either<Failure, Place>> call(CreatePlaceInFloorParams params) async {
    try {
      final place = await repository.createPlaceInFloor(
        floorId: params.floorId,
        name: params.name,
        categoryId: params.categoryId,
        categoryName: params.categoryName,
        description: params.description,
        image: params.image,
        latitude: params.latitude,
        longitude: params.longitude,
      );
      return Right(place);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class CreatePlaceInFloorParams {
  final int floorId;
  final String name;
  final int? categoryId;
  final String? categoryName;
  final String? description;
  final File? image;
  final double? latitude;
  final double? longitude;

  CreatePlaceInFloorParams({
    required this.floorId,
    required this.name,
    this.categoryId,
    this.categoryName,
    this.description,
    this.image,
    this.latitude,
    this.longitude,
  });
}
