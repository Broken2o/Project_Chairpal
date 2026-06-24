import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class CreateFloorUseCase {
  final HomeRepository repository;

  CreateFloorUseCase(this.repository);

  Future<Either<Failure, Place>> call(CreateFloorParams params) async {
    try {
      final floor = await repository.createFloor(
        buildingId: params.buildingId,
        name: params.name,
        level: params.level,
        description: params.description,
        image: params.image,
      );
      return Right(floor);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class CreateFloorParams {
  final int buildingId;
  final String name;
  final int? level;
  final String? description;
  final File? image;

  CreateFloorParams({
    required this.buildingId,
    required this.name,
    this.level,
    this.description,
    this.image,
  });
}
