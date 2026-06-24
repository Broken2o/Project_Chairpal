import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';
import '../../data/models/vital_state_model.dart';

class GetWheelchairHealthUseCase {
  final HomeRepository repository;

  GetWheelchairHealthUseCase(this.repository);

  Future<Either<Failure, VitalStateModel>> call(int wheelchairId) async {
    try {
      final result = await repository.getWheelchairHealth(wheelchairId);
      final healthState = VitalStateModel.fromJson(result);
      return Right(healthState);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
