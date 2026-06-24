import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/connection_entity.dart';
import '../../domain/repositories/connections_repository.dart';
import '../datasources/connections_remote_data_source.dart';
import '../../../auth/domain/entities/user.dart';

class ConnectionsRepositoryImpl implements ConnectionsRepository {
  final ConnectionsRemoteDataSource remoteDataSource;

  ConnectionsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ConnectionEntity>>> getPendingConnections() async {
    try {
      final connections = await remoteDataSource.getPendingConnections();
      return Right(connections);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getConnectedCompanions() async {
    try {
      final companions = await remoteDataSource.getConnectedCompanions();
      return Right(companions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getConnectedDoctor() async {
    try {
      final doctor = await remoteDataSource.getConnectedDoctor();
      return Right(doctor);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> handleConnection(int connectionId, String action) async {
    try {
      await remoteDataSource.handleConnection(connectionId, action);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeConnection(int userId) async {
    try {
      await remoteDataSource.removeConnection(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendConnectionRequest(String targetUsername) async {
    try {
      final message = await remoteDataSource.sendConnectionRequest(targetUsername);
      return Right(message);
    } on DioException catch (e) {
      String errorMessage = 'Failed to send connection request';
      if (e.response != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      } else if (e.error != null) {
        errorMessage = e.error.toString();
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
