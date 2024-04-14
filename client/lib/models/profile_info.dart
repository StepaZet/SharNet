import 'dart:core';

enum ResultEnum {
  ok,
  unauthorized,
  emailAlreadyExist,
  emailNotFound,
  emailNotVerified,
  wrongPassword,
}

class PossibleErrorResult<T> {
  final T? resultData;
  final ResultEnum resultStatus;

  PossibleErrorResult({required this.resultData, required this.resultStatus});
}

class ProfileInfo {
  String name;
  String email;
  String photoUrl;

ProfileInfo({
    required this.name,
    required this.email,
    required this.photoUrl,
  });
}
