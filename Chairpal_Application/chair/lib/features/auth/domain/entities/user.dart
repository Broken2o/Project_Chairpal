import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String? username;
  final String email;
  final String? role;
  final String? accessToken;
  final int? accessTokenExpiresIn;
  final String? rememberToken;
  final int? rememberTokenExpiresIn;
  final String? phone;
  final String? gender;
  final String? birthDate;
  final num? weight;
  final num? height;
  final List<int>? medicalConditionIds;
  final String? location;
  final String? image;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    this.username,
    required this.email,
    this.role,
    this.accessToken,
    this.accessTokenExpiresIn,
    this.rememberToken,
    this.rememberTokenExpiresIn,
    this.phone,
    this.gender,
    this.birthDate,
    this.weight,
    this.height,
    this.medicalConditionIds,
    this.location,
    this.image,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        role,
        accessToken,
        accessTokenExpiresIn,
        rememberToken,
        rememberTokenExpiresIn,
        phone,
        gender,
        birthDate,
        weight,
        height,
        medicalConditionIds,
        location,
        image,
        createdAt,
      ];
}
