import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/assets.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/notification_tile.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

import '../../../../l10n/l10n.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..fetchNotifications(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context)!.notifications,
          style: AppStyles.h3.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        leadingWidth: 100,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is NotificationsError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppStyles.bodyMedium.copyWith(color: Colors.red),
                ),
              );
          } else if (state is NotificationsLoaded) {
            final notifications = state.notifications;
            
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.imagesNoNotifications, height: 250.w),
                    Text(
                      S.of(context)!.noNotificationsTitle,
                      style: AppStyles.h3.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        S.of(context)!.noNotificationsSubtitle,
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyMedium.copyWith(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationsCubit>().fetchNotifications();
              },
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  bool isActionable = true;
                  if (notification.notificationType == 'connection_request_received' && notification.connectionId != null) {
                    isActionable = state.pendingConnectionIds.contains(notification.connectionId);
                  } else if (notification.notificationType == 'friend_request_received' && notification.senderId != null) {
                    isActionable = state.pendingSenderIds.contains(notification.senderId);
                  }

                  return NotificationTile(
                    notification: notification,
                    isActionable: isActionable,
                    onTap: () {
                      if (!notification.isRead) {
                        context.read<NotificationsCubit>().markAsRead(notification.id);
                      }
                    },
                  );
                },
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

