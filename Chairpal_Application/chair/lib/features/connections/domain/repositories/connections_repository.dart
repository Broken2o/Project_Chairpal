import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/connection_entity.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ConnectionsRepository {
  Future<Either<Failure, List<ConnectionEntity>>> getPendingConnections();
  Future<Either<Failure, List<User>>> getConnectedCompanions();
  Future<Either<Failure, User?>> getConnectedDoctor();
  Future<Either<Failure, void>> handleConnection(int connectionId, String action);
  Future<Either<Failure, void>> removeConnection(int userId);
  Future<Either<Failure, String>> sendConnectionRequest(String targetUsername);
}
