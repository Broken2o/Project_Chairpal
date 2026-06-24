import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class AddOrganizationUseCase {
  final HomeRepository repository;

  AddOrganizationUseCase(this.repository);

  Future<Either<Failure, Place>> call(AddOrganizationParams params) async {
    try {
      final organization = await repository.createOrganization(
        name: params.name,
        categoryId: params.categoryId,
        categoryName: params.categoryName,
        countryName: params.countryName,
        cityName: params.cityName,
        description: params.description,
        image: params.image,
        latitude: params.latitude,
        longitude: params.longitude,
      );
      return Right(organization);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class AddOrganizationParams {
  final String name;
  final int? categoryId;
  final String? categoryName;
  final String countryName;
  final String cityName;
  final String? description;
  final File? image;
  final double? latitude;
  final double? longitude;

  AddOrganizationParams({
    required this.name,
    this.categoryId,
    this.categoryName,
    required this.countryName,
    required this.cityName,
    this.description,
    this.image,
    this.latitude,
    this.longitude,
  });
}
