import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.username,
    required super.email,
    super.role,
    super.accessToken,
    super.accessTokenExpiresIn,
    super.rememberToken,
    super.rememberTokenExpiresIn,
    super.phone,
    super.gender,
    super.birthDate,
    super.weight,
    super.height,
    super.medicalConditionIds,
    super.location,
    super.image,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userJson = json['data'] ?? json['user'] ?? json;
    
    return UserModel(
      id: userJson['id'] ?? 0,
      name: userJson['name'] ?? '',
      username: userJson['username'],
      email: userJson['email'] ?? '',
      role: userJson['role'],
      accessToken: json['access_token'],
      accessTokenExpiresIn: json['access_token_expires_in'],
      rememberToken: json['remember_token'],
      rememberTokenExpiresIn: json['remember_token_expires_in'],
      phone: userJson['phone'],
      gender: userJson['gender'],
      birthDate: userJson['birth_date'],
      weight: userJson['weight'],
      height: userJson['height'],
      medicalConditionIds: userJson['medical_conditions'] != null
          ? (userJson['medical_conditions'] as List)
              .map((e) => e is Map ? (e['id'] as int) : (e as int))
              .toList()
          : null,

      location: userJson['location'],
      image: _parseImage(userJson['image'] ?? userJson['profile_image'] ?? userJson['avatar'] ?? userJson['profile_picture']),
      createdAt: userJson['created_at'] != null ? DateTime.tryParse(userJson['created_at']) : null,
    );
  }

  static String? _parseImage(dynamic img) {
    if (img == null || img == 'null' || img == '') return null;
    String imageStr = img.toString();
    if (!imageStr.startsWith('http')) {
      final String path = imageStr.startsWith('/') ? imageStr.substring(1) : imageStr;
      return 'https://chairpal-api.duckdns.org/storage/$path';
    }
    return imageStr;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'role': role,
        'phone': phone,
        'gender': gender,
        'birth_date': birthDate,
        'weight': weight,
        'height': height,
        'medical_condition_ids': medicalConditionIds,
        'location': location,
        'image': image,
        'created_at': createdAt?.toIso8601String(),
      },
      'access_token': accessToken,
      'access_token_expires_in': accessTokenExpiresIn,
      'remember_token': rememberToken,
      'remember_token_expires_in': rememberTokenExpiresIn,
    };
  }
}
