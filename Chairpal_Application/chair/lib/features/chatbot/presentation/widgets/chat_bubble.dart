import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../data/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(int, String)? onReact;

  const ChatBubble({super.key, required this.message, this.onReact});

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _bubbleColor(message),
        borderRadius: BorderRadius.circular(12.r),
        border: message.isUser
            ? null
            : Border.all(
                color: message.isError
                    ? Colors.red.withValues(alpha: 0.3)
                    : const Color(0xFFD6E0E6), // Soft grey-blue border
                width: 1,
              ),
      ),
      child: Text(
        message.text,
        style: AppStyles.bodyLarge.copyWith(
          color: _textColor(message),
          fontSize: 15,
          height: 1.45,
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                Container(
                  margin: EdgeInsets.only(right: 8.w, top: 4.h),
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F6F8), // Very light teal/cyan
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFF0775B), // Orange/Coral color
                    size: 16,
                  ),
                ),
              ],
              SizedBox(width: 8.w),
              bubble,
            ],
          ),
          if (!message.isUser && !message.isError && message.id != null) ...[
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 40.w), // Align with bubble
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionBtn(
                    icon: message.reaction == 'like'
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                    color: message.reaction == 'like'
                        ? AppColors.primary
                        : Colors.grey[500],
                    onTap: () => onReact?.call(message.id!, 'like'),
                  ),
                  SizedBox(width: 8.w),
                  _ActionBtn(
                    icon: message.reaction == 'dislike'
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined,
                    color: message.reaction == 'dislike'
                        ? Colors.red
                        : Colors.grey[500],
                    onTap: () => onReact?.call(message.id!, 'dislike'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _bubbleColor(ChatMessage msg) {
    if (msg.isUser) return AppColors.primary;
    if (msg.isError) return const Color(0xFFFFF3F3);
    return Colors.white;
  }

  Color _textColor(ChatMessage msg) {
    if (msg.isUser) return Colors.white;
    if (msg.isError) return Colors.red.shade700;
    return const Color(0xFF335763); // Dark slate/teal colour for AI message text
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _ActionBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(3.r),
        child: Icon(icon, size: 15, color: color ?? Colors.grey[400]),
      ),
    );
  }
}
