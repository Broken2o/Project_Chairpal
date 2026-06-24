import 'place_model.dart';

class AdminDashboardModel {
  final List<PlaceModel> organizations;
  final List<ActivityLogModel> recentActivityLogs;

  AdminDashboardModel({
    required this.organizations,
    required this.recentActivityLogs,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      organizations: (json['organizations'] as List?)
              ?.map((p) => PlaceModel.fromJson(p))
              .toList() ??
          [],
      recentActivityLogs: (json['recent_activity_logs'] as List?)
              ?.map((l) => ActivityLogModel.fromJson(l))
              .toList() ??
          [],
    );
  }
}

class ActivityLogModel {
  final String type;
  final String message;
  final String createdAt;

  ActivityLogModel({
    required this.type,
    required this.message,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
