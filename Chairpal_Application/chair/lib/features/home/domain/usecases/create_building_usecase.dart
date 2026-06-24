import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class CreateBuildingUseCase {
  final HomeRepository repository;

  CreateBuildingUseCase(this.repository);

  Future<Either<Failure, Place>> call(CreateBuildingParams params) async {
    try {
      final building = await repository.createBuilding(
        organizationId: params.organizationId,
        name: params.name,
        description: params.description,
        image: params.image,
        latitude: params.latitude,
        longitude: params.longitude,
      );
      return Right(building);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class CreateBuildingParams {
  final int organizationId;
  final String name;
  final String? description;
  final File? image;
  final double? latitude;
  final double? longitude;

  CreateBuildingParams({
    required this.organizationId,
    required this.name,
    this.description,
    this.image,
    this.latitude,
    this.longitude,
  });
}
