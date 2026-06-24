class UserDashboardModel {
  final VitalsModel currentVitals;
  final Map<String, List<OverviewPointModel>> overviews;
  final List<AlertModel> recentAlerts;
  final AiRecommendationModel? aiRecommendation;

  UserDashboardModel({
    required this.currentVitals,
    required this.overviews,
    required this.recentAlerts,
    this.aiRecommendation,
  });

  factory UserDashboardModel.fromJson(Map<String, dynamic> json) {
    final vitalsJson = json['current_vitals'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final overviewsJson = json['overviews'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final Map<String, List<OverviewPointModel>> parsedOverviews = {};
    overviewsJson.forEach((key, value) {
      if (value is List) {
        parsedOverviews[key] = value.map((v) => OverviewPointModel.fromJson(v)).toList();
      }
    });

    final alertsJson = json['recent_alerts'] as List? ?? [];
    final parsedAlerts = alertsJson.map((v) => AlertModel.fromJson(v)).toList();

    return UserDashboardModel(
      currentVitals: VitalsModel.fromJson(vitalsJson),
      overviews: parsedOverviews,
      recentAlerts: parsedAlerts,
      aiRecommendation: json['ai_recommendation'] != null 
          ? AiRecommendationModel.fromJson(json['ai_recommendation']) 
          : null,
    );
  }
}

class VitalsModel {
  final VitalDetailModel? heart;
  final VitalDetailModel? temperature;
  final ObstacleModel? obstacle;

  VitalsModel({
    this.heart,
    this.temperature,
    this.obstacle,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      heart: json['heart'] != null ? VitalDetailModel.fromJson(json['heart']) : null,
      temperature: json['temperature'] != null ? VitalDetailModel.fromJson(json['temperature']) : null,
      obstacle: json['obstacle'] != null ? ObstacleModel.fromJson(json['obstacle']) : null,
    );
  }
}

class VitalDetailModel {
  final num value;
  final String status;

  VitalDetailModel({
    required this.value,
    required this.status,
  });

  factory VitalDetailModel.fromJson(Map<String, dynamic> json) {
    return VitalDetailModel(
      value: json['value'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class ObstacleModel {
  final String movement;
  final num mpuAngle;
  final String status;

  ObstacleModel({
    required this.movement,
    required this.mpuAngle,
    required this.status,
  });

  factory ObstacleModel.fromJson(Map<String, dynamic> json) {
    return ObstacleModel(
      movement: json['movement'] ?? '',
      mpuAngle: json['mpu_angle'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class OverviewPointModel {
  final String xAxis;
  final num yAxis;

  OverviewPointModel({
    required this.xAxis,
    required this.yAxis,
  });

  factory OverviewPointModel.fromJson(Map<String, dynamic> json) {
    return OverviewPointModel(
      xAxis: json['x_axis'] ?? '',
      yAxis: json['y_axis'] ?? 0,
    );
  }
}

class AlertModel {
  final int id;
  final String title;
  final String time;
  final String icon;
  final String severity;

  AlertModel({
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.severity,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      icon: json['icon'] ?? '',
      severity: json['severity'] ?? '',
    );
  }
}

class AiRecommendationModel {
  final String riskLevel;
  final String recommendation;

  AiRecommendationModel({
    required this.riskLevel,
    required this.recommendation,
  });

  factory AiRecommendationModel.fromJson(Map<String, dynamic> json) {
    return AiRecommendationModel(
      riskLevel: json['risk_level'] ?? '',
      recommendation: json['recommendation'] ?? '',
    );
  }
}
