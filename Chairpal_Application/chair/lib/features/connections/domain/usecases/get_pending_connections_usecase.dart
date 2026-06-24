import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/connection_entity.dart';
import '../repositories/connections_repository.dart';

class GetPendingConnectionsUseCase {
  final ConnectionsRepository repository;

  GetPendingConnectionsUseCase(this.repository);

  Future<Either<Failure, List<ConnectionEntity>>> call() async {
    return await repository.getPendingConnections();
  }
}
