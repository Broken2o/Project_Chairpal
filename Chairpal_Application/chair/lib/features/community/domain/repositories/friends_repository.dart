import '../../../auth/data/models/user_model.dart';

abstract class FriendsRepository {
  Future<List<UserModel>> getFriends();
  Future<List<UserModel>> getFriendRequests();
  Future<String> sendFriendRequest(int targetUserId);
  Future<String> handleFriendRequest(int targetUserId, String action);
  Future<String> removeFriend(int targetUserId);
}
