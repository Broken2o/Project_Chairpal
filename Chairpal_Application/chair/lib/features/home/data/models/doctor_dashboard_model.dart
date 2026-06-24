class DoctorDashboardModel {
  final DoctorStatistics statistics;
  final List<DoctorPatient> patients;
  final List<DoctorAlert> alerts;

  DoctorDashboardModel({
    required this.statistics,
    required this.patients,
    required this.alerts,
  });

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      statistics: DoctorStatistics.fromJson(json['statistics'] ?? {}),
      patients: (json['patients'] as List?)
              ?.map((p) => DoctorPatient.fromJson(p))
              .toList() ??
          [],
      alerts: (json['alerts'] as List?)
              ?.map((a) => DoctorAlert.fromJson(a))
              .toList() ??
          [],
    );
  }
}

class DoctorStatistics {
  final int total;
  final int normal;
  final int medium;
  final int critical;

  DoctorStatistics({
    required this.total,
    required this.normal,
    required this.medium,
    required this.critical,
  });

  factory DoctorStatistics.fromJson(Map<String, dynamic> json) {
    return DoctorStatistics(
      total: json['total'] ?? 0,
      normal: json['normal'] ?? 0,
      medium: json['medium'] ?? 0,
      critical: json['critical'] ?? 0,
    );
  }
}

class DoctorPatient {
  final int id;
  final int? wheelchairId;
  final String name;
  final String? email;
  final String? image;
  final int? age;
  final String? lastUpdate;

  DoctorPatient({
    required this.id,
    this.wheelchairId,
    required this.name,
    this.email,
    this.image,
    this.age,
    this.lastUpdate,
  });

  factory DoctorPatient.fromJson(Map<String, dynamic> json) {
    return DoctorPatient(
      id: json['id'] ?? 0,
      wheelchairId: json['wheelchair_id'],
      name: json['name'] ?? '',
      email: json['email'],
      image: json['image'],
      age: json['age'],
      lastUpdate: json['last_update'],
    );
  }
}

class DoctorAlert {
  final int id;
  final String patientName;
  final String issue;
  final String time;
  final String severity; // e.g. "Medium", "High"

  DoctorAlert({
    required this.id,
    required this.patientName,
    required this.issue,
    required this.time,
    required this.severity,
  });

  factory DoctorAlert.fromJson(Map<String, dynamic> json) {
    return DoctorAlert(
      id: json['id'] ?? 0,
      patientName: json['patient_name'] ?? '',
      issue: json['issue'] ?? '',
      time: json['time'] ?? '',
      severity: json['severity'] ?? 'Medium',
    );
  }
}
