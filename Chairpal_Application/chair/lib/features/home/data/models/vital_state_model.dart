class VitalStateModel {
  final int id;
  final int wheelchairId;
  final num heartRate;
  final String heartRateStatus;
  final num temperature;
  final String temperatureStatus;
  final num mpuAngle;
  final String fallStatus;
  final String riskLevel;
  final String reason;
  final String recommendation;
  final DateTime updatedAt;

  VitalStateModel({
    required this.id,
    required this.wheelchairId,
    required this.heartRate,
    required this.heartRateStatus,
    required this.temperature,
    required this.temperatureStatus,
    required this.mpuAngle,
    required this.fallStatus,
    required this.riskLevel,
    required this.reason,
    required this.recommendation,
    required this.updatedAt,
  });

  factory VitalStateModel.fromJson(Map<String, dynamic> json) {
    return VitalStateModel(
      id: json['id'] ?? 0,
      wheelchairId: json['wheelchair_id'] ?? 0,
      heartRate: json['heart_rate'] ?? 0,
      heartRateStatus: json['heart_rate_status'] ?? '',
      temperature: json['temperature'] ?? 0,
      temperatureStatus: json['temperature_status'] ?? '',
      mpuAngle: json['mpu_angle'] ?? 0,
      fallStatus: json['fall_status'] ?? '',
      riskLevel: json['risk_level'] ?? '',
      reason: json['reason'] ?? '',
      recommendation: json['recommendation'] ?? '',
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
