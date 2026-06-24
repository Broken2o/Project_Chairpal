import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class GetFloorsUseCase {
  final HomeRepository repository;

  GetFloorsUseCase(this.repository);

  Future<Either<Failure, List<Place>>> call(int buildingId) async {
    try {
      final floors = await repository.getFloors(buildingId);
      return Right(floors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
