import '../../domain/entities/medical_condition.dart';

class MedicalConditionModel extends MedicalCondition {
  const MedicalConditionModel({
    required super.id,
    required super.name,
    super.category,
    super.description,
  });

  factory MedicalConditionModel.fromJson(Map<String, dynamic> json) {
    return MedicalConditionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
    };
  }
}
