import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../../../../core/di/injection_container.dart';
import '../../../connections/domain/usecases/get_pending_connections_usecase.dart';
import '../../../connections/domain/usecases/handle_connection_usecase.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';
import '../../../connections/domain/entities/connection_entity.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final bool isActionable;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    this.isActionable = true,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _isLoading = false;
  bool _isHandled = false;

  Future<void> _handleFriendRequest(String action) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final getPendingConnectionsUseCase = sl<GetPendingConnectionsUseCase>();
      final handleConnectionUseCase = sl<HandleConnectionUseCase>();
      
      int? connectionId = widget.notification.connectionId;
      
      if (connectionId == null) {
        final pendingResult = await getPendingConnectionsUseCase();
        pendingResult.fold(
          (failure) => throw Exception(failure.message),
          (connections) {
            final target = connections.cast<ConnectionEntity?>().firstWhere(
              (c) => c?.senderId == widget.notification.senderId && c?.status == 'pending',
              orElse: () => null,
            );
            connectionId = target?.id;
          },
        );
      }
      
      if (connectionId != null) {
        final result = await handleConnectionUseCase(connectionId!, action);
        result.fold(
          (failure) {
            setState(() {
              _isHandled = true;
            });
            throw Exception(failure.message);
          },
          (_) {
            setState(() {
              _isHandled = true;
            });
            CustomSnackBar.showSuccess(context: context, message: action == 'accept' ? S.of(context)!.requestAcceptedSuccessfully : S.of(context)!.requestRejectedSuccessfully);
          },
        );
      } else {
        setState(() {
          _isHandled = true;
        });
        throw Exception(S.of(context)!.requestAlreadyHandled);
      }
    } catch (e) {
      CustomSnackBar.showError(context: context, message: e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: widget.notification.isRead
            ? Colors.white
            : const Color(0xFFE0F7FA).withValues(alpha: 0.3),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: widget.notification.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.notification.avatarUrl)
                      : null,
                  child: widget.notification.avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                if (widget.notification.unreadCount > 0)
                  Positioned(
                    right: 0.w,
                    top: 0.h,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${widget.notification.unreadCount}',
                        style: AppStyles.badge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.notification.name,
                        style: AppStyles.h3.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        widget.notification.timeAgo,
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.notification.message,
                    style: AppStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((widget.notification.notificationType == 'friend_request_received' || 
                       widget.notification.notificationType == 'connection_request_received') && !_isHandled && widget.isActionable) ...[
                    SizedBox(height: 16.h),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _handleFriendRequest('accept'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: AppColors.primary),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_box_outlined, size: 20),
                                  SizedBox(width: 8.w),
                                  Text(S.of(context)!.accept, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _handleFriendRequest('reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepOrangeAccent,
                                side: const BorderSide(color: Colors.deepOrangeAccent),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cancel_outlined, size: 20),
                                  SizedBox(width: 8.w),
                                  Text(S.of(context)!.decline, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
