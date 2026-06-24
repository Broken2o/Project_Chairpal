import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';
import '../../data/models/sensor_reading_model.dart';

class GetWheelchairSensorReadingsUseCase {
  final HomeRepository repository;

  GetWheelchairSensorReadingsUseCase(this.repository);

  Future<Either<Failure, List<SensorReadingModel>>> call(int wheelchairId, {int? page}) async {
    try {
      final result = await repository.getWheelchairSensorReadings(wheelchairId, page: page);
      final List<SensorReadingModel> readings = result.map((e) => SensorReadingModel.fromJson(e)).toList();
      return Right(readings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
