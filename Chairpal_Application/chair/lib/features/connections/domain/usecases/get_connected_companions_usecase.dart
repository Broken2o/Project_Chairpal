import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/connections_repository.dart';

class GetConnectedCompanionsUseCase {
  final ConnectionsRepository repository;

  GetConnectedCompanionsUseCase(this.repository);

  Future<Either<Failure, List<User>>> call() async {
    return await repository.getConnectedCompanions();
  }
}
