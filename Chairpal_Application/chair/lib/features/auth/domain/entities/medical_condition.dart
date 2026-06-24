import 'package:equatable/equatable.dart';

class MedicalCondition extends Equatable {
  final int id;
  final String name;
  final String? category;
  final String? description;

  const MedicalCondition({
    required this.id,
    required this.name,
    this.category,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, category, description];
}
