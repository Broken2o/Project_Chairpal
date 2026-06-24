import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/connections_repository.dart';

class HandleConnectionUseCase {
  final ConnectionsRepository repository;

  HandleConnectionUseCase(this.repository);

  Future<Either<Failure, void>> call(int connectionId, String action) async {
    return await repository.handleConnection(connectionId, action);
  }
}
