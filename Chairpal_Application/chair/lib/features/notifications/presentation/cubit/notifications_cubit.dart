import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';

import '../../../../features/connections/domain/usecases/get_pending_connections_usecase.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final Set<int> pendingConnectionIds;
  final Set<int> pendingSenderIds;

  NotificationsLoaded({
    required this.notifications, 
    required this.pendingConnectionIds,
    required this.pendingSenderIds,
  });
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;
  final GetPendingConnectionsUseCase getPendingConnectionsUseCase;

  NotificationsCubit({
    required this.repository,
    required this.getPendingConnectionsUseCase,
  }) : super(NotificationsInitial());

  Future<void> fetchNotifications({int page = 1}) async {
    emit(NotificationsLoading());
    
    // Fetch notifications and pending connections in parallel
    final results = await Future.wait([
      repository.getNotifications(page: page),
      getPendingConnectionsUseCase(),
    ]);
    
    final notifResult = results[0] as dartz.Either<dynamic, List<NotificationModel>>;
    final pendingResult = results[1] as dartz.Either<dynamic, List<dynamic>>;

    notifResult.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) {
        Set<int> pendingIds = {};
        Set<int> pendingSenders = {};
        pendingResult.fold(
          (_) {}, // ignore failure for pending connections
          (connections) {
            for (var c in connections) {
              if (c.status == 'pending') {
                pendingIds.add(c.id);
                if (c.senderId != null) {
                  pendingSenders.add(c.senderId);
                }
              }
            }
          },
        );
        emit(NotificationsLoaded(
          notifications: notifications, 
          pendingConnectionIds: pendingIds,
          pendingSenderIds: pendingSenders,
        ));
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await repository.markAsRead(notificationId);
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updated = currentState.notifications.map((n) {
        if (n.id == notificationId) {
          return NotificationModel(
            id: n.id,
            name: n.name,
            message: n.message,
            timeAgo: n.timeAgo,
            avatarUrl: n.avatarUrl,
            notificationType: n.notificationType,
            senderId: n.senderId,
            connectionId: n.connectionId,
            createdAt: n.createdAt,
            unreadCount: n.unreadCount,
            isRead: true,
          );
        }
        return n;
      }).toList();
      emit(NotificationsLoaded(
        notifications: updated, 
        pendingConnectionIds: currentState.pendingConnectionIds,
        pendingSenderIds: currentState.pendingSenderIds,
      ));
    }
  }
}
