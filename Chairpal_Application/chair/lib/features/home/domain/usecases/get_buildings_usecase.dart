import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class GetBuildingsUseCase {
  final HomeRepository repository;

  GetBuildingsUseCase(this.repository);

  Future<Either<Failure, List<Place>>> call(int organizationId) async {
    try {
      final buildings = await repository.getBuildings(organizationId);
      return Right(buildings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
