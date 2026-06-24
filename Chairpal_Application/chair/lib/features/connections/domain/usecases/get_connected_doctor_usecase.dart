import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/connections_repository.dart';

class GetConnectedDoctorUseCase {
  final ConnectionsRepository repository;

  GetConnectedDoctorUseCase(this.repository);

  Future<Either<Failure, User?>> call() async {
    return await repository.getConnectedDoctor();
  }
}
