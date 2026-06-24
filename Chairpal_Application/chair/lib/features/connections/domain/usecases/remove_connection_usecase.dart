import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/connections_repository.dart';

class RemoveConnectionUseCase {
  final ConnectionsRepository repository;

  RemoveConnectionUseCase(this.repository);

  Future<Either<Failure, void>> call(int userId) async {
    return await repository.removeConnection(userId);
  }
}
