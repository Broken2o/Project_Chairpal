import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/connections_repository.dart';

class SendConnectionRequestUseCase {
  final ConnectionsRepository repository;

  SendConnectionRequestUseCase(this.repository);

  Future<Either<Failure, String>> call(String targetUsername) async {
    return await repository.sendConnectionRequest(targetUsername);
  }
}
