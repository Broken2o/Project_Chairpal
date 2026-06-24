class SensorReadingModel {
  final int id;
  final int wheelchairId;
  final num heartRateMin;
  final num heartRateMax;
  final num heartRateAvg;
  final num temperatureMin;
  final num temperatureMax;
  final num temperatureAvg;
  final num mpuAngleMin;
  final num mpuAngleMax;
  final num mpuAngleAvg;
  final DateTime readingTime;

  SensorReadingModel({
    required this.id,
    required this.wheelchairId,
    required this.heartRateMin,
    required this.heartRateMax,
    required this.heartRateAvg,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.temperatureAvg,
    required this.mpuAngleMin,
    required this.mpuAngleMax,
    required this.mpuAngleAvg,
    required this.readingTime,
  });

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      id: json['id'] ?? 0,
      wheelchairId: json['wheelchair_id'] ?? 0,
      heartRateMin: json['heart_rate_min'] ?? 0,
      heartRateMax: json['heart_rate_max'] ?? 0,
      heartRateAvg: json['heart_rate_avg'] ?? 0,
      temperatureMin: json['temperature_min'] ?? 0,
      temperatureMax: json['temperature_max'] ?? 0,
      temperatureAvg: json['temperature_avg'] ?? 0,
      mpuAngleMin: json['mpu_angle_min'] ?? 0,
      mpuAngleMax: json['mpu_angle_max'] ?? 0,
      mpuAngleAvg: json['mpu_angle_avg'] ?? 0,
      readingTime: DateTime.parse(json['reading_time']),
    );
  }
}
