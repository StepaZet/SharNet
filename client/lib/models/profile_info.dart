import 'dart:core';

import 'package:client/models/config.dart';

enum ResultEnum {
  ok,
  unauthorized,
  emailAlreadyExists,
  emailNotFound,
  emailNotVerified,
  wrongPassword,
  unknownError,
  unknownToken,
}

class PossibleErrorResult<T> {
  final T? resultData;
  final ResultEnum resultStatus;

  PossibleErrorResult({required this.resultData, required this.resultStatus});
}

class ProfileInfo {
  String name;
  String surname;
  String email;
  String photoUrl;
  String username;
  DateTime? birthDate;

  ProfileInfo({
    required this.name,
    required this.surname,
    required this.email,
    required this.photoUrl,
    required this.username,
    this.birthDate,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      photoUrl: json['photo'] ?? Config.defaultAvatarUrl,
      username: json['username'],
      birthDate: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
    );
  }
}
