import 'package:flutter/material.dart';

/// Shared helpers for place card widgets.
abstract final class PlaceUtils {
  PlaceUtils._();

  /// Returns a Material icon that best represents [category].
  static IconData iconForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('restaurant') ||
        lower.contains('food') ||
        lower.contains('cafe') ||
        lower.contains('catering')) {
      return Icons.restaurant_rounded;
    } else if (lower.contains('hotel') ||
        lower.contains('accommodation') ||
        lower.contains('hostel')) {
      return Icons.hotel_rounded;
    } else if (lower.contains('park') ||
        lower.contains('nature') ||
        lower.contains('garden')) {
      return Icons.park_rounded;
    } else if (lower.contains('museum') ||
        lower.contains('art') ||
        lower.contains('gallery') ||
        lower.contains('historic')) {
      return Icons.museum_rounded;
    } else if (lower.contains('shop') ||
        lower.contains('store') ||
        lower.contains('mall') ||
        lower.contains('commercial')) {
      return Icons.shopping_bag_rounded;
    } else if (lower.contains('hospital') ||
        lower.contains('health') ||
        lower.contains('clinic') ||
        lower.contains('pharmacy')) {
      return Icons.local_hospital_rounded;
    } else if (lower.contains('sport') ||
        lower.contains('gym') ||
        lower.contains('leisure')) {
      return Icons.sports_rounded;
    } else if (lower.contains('airport') ||
        lower.contains('transport') ||
        lower.contains('bus') ||
        lower.contains('train')) {
      return Icons.directions_transit_rounded;
    } else if (lower.contains('beach') || lower.contains('sea')) {
      return Icons.beach_access_rounded;
    } else if (lower.contains('entertain') || lower.contains('cinema')) {
      return Icons.local_movies_rounded;
    } else if (lower.contains('education') ||
        lower.contains('school') ||
        lower.contains('university')) {
      return Icons.school_rounded;
    } else if (lower.contains('bank') || lower.contains('finance')) {
      return Icons.account_balance_rounded;
    }
    return Icons.place_rounded;
  }

  /// Capitalises each word and replaces underscores with spaces.
  static String formatCategory(String category) {
    if (category.isEmpty) return 'Place';
    return category
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
