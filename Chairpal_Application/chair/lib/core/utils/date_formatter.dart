import 'package:intl/intl.dart';

class DateFormatter {
  static String timeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Recent';
    
    try {
      // API format: "28 Mar 2026 - 10:10 AM"
      final DateFormat inputFormat = DateFormat('dd MMM yyyy - hh:mm a');
      final DateTime dateTime = inputFormat.parse(dateString);
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.isNegative) {
        return 'Just now';
      }

      if (difference.inDays >= 365) {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      } else if (difference.inDays >= 30) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else if (difference.inDays >= 7) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      // Fallback to basic parse if format varies
      try {
        final DateTime dateTime = DateTime.parse(dateString);
        final Duration difference = DateTime.now().difference(dateTime);
        if (difference.inDays >= 1) return '${difference.inDays}d ago';
        return 'Recent';
      } catch (_) {
        return 'Recent';
      }
    }
  }
}
