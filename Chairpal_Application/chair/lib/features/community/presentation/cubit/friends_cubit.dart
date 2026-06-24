import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/friends_repository.dart';
import 'package:dio/dio.dart';

abstract class FriendsState {}

class FriendsInitial extends FriendsState {}
class FriendsLoading extends FriendsState {}
class FriendsLoaded extends FriendsState {
  final List<UserModel> friends;
  final List<UserModel> requests;
  final List<int> sentRequests;

  FriendsLoaded({required this.friends, required this.requests, this.sentRequests = const []});
}
class FriendsError extends FriendsState {
  final String message;
  FriendsError(this.message);
}

class FriendsCubit extends Cubit<FriendsState> {
  final FriendsRepository repository;

  FriendsCubit({required this.repository}) : super(FriendsInitial());

  Future<void> fetchFriendsAndRequests() async {
    emit(FriendsLoading());
    try {
      final friends = await repository.getFriends();
      final requests = await repository.getFriendRequests();
      emit(FriendsLoaded(friends: friends, requests: requests, sentRequests: []));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  Future<String?> sendFriendRequest(int targetUserId) async {
    try {
      final message = await repository.sendFriendRequest(targetUserId);
      if (state is FriendsLoaded) {
        final current = state as FriendsLoaded;
        final updatedSent = List<int>.from(current.sentRequests)..add(targetUserId);
        emit(FriendsLoaded(friends: current.friends, requests: current.requests, sentRequests: updatedSent));
      }
      return message;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        // Already sent or already friends
        if (state is FriendsLoaded) {
          final current = state as FriendsLoaded;
          final updatedSent = List<int>.from(current.sentRequests)..add(targetUserId);
          emit(FriendsLoaded(friends: current.friends, requests: current.requests, sentRequests: updatedSent));
        }
        return e.response?.data?['message'] ?? 'Request already sent.';
      }
      return null;
    }
  }

  Future<bool> handleFriendRequest(int targetUserId, String action) async {
    try {
      await repository.handleFriendRequest(targetUserId, action);
      if (state is FriendsLoaded) {
        final currentState = state as FriendsLoaded;
        // Re-fetch to update lists
        fetchFriendsAndRequests();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFriend(int targetUserId) async {
    try {
      await repository.removeFriend(targetUserId);
      if (state is FriendsLoaded) {
        fetchFriendsAndRequests();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Helper method to determine relation status
  String getRelationStatus(int userId) {
    if (state is FriendsLoaded) {
      final loadedState = state as FriendsLoaded;
      
      // Check if they are friends
      final isFriend = loadedState.friends.any((user) => user.id == userId);
      if (isFriend) return 'friend';

      // Check if there is a pending request FROM them
      final hasPendingRequest = loadedState.requests.any((user) => user.id == userId);
      if (hasPendingRequest) return 'pending_received';

      // Check if we sent a pending request TO them
      final hasSentRequest = loadedState.sentRequests.contains(userId);
      if (hasSentRequest) return 'pending_sent';
    }
    return 'none';
  }
}
