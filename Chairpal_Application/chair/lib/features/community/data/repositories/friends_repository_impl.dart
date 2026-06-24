import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_data_source.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource remoteDataSource;

  FriendsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserModel>> getFriends() {
    return remoteDataSource.getFriends();
  }

  @override
  Future<List<UserModel>> getFriendRequests() {
    return remoteDataSource.getFriendRequests();
  }

  @override
  Future<String> sendFriendRequest(int targetUserId) {
    return remoteDataSource.sendFriendRequest(targetUserId);
  }

  @override
  Future<String> handleFriendRequest(int targetUserId, String action) {
    return remoteDataSource.handleFriendRequest(targetUserId, action);
  }

  @override
  Future<String> removeFriend(int targetUserId) {
    return remoteDataSource.removeFriend(targetUserId);
  }
}
