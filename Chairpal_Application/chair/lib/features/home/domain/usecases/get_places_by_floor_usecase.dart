import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/place.dart';
import '../repositories/home_repository.dart';

class GetPlacesByFloorUseCase {
  final HomeRepository repository;

  GetPlacesByFloorUseCase(this.repository);

  Future<Either<Failure, List<Place>>> call(int floorId) async {
    try {
      final places = await repository.getPlacesByFloor(floorId);
      return Right(places);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
