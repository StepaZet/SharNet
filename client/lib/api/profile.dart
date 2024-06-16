import 'dart:convert';

import 'package:client/models/buoy.dart';
import 'package:client/models/shark.dart';
import 'package:http/http.dart' as http;
import 'package:client/models/config.dart';
import 'package:client/models/profile_info.dart';

Future<PossibleErrorResult<ProfileInfo>> getUserInfo() async {
  if (Config.accessToken == null) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var url = "${Config.apiUrl}/users/get/";
  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 401) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var data = jsonDecode(utf8.decode(response.bodyBytes));

  var result = ProfileInfo.fromJson(data);

  return PossibleErrorResult(resultData: result, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult> updateUserInfo(
    String name, String surname, String birthDate) async {
  if (Config.accessToken == null) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var url = "${Config.apiUrl}/users/update/";
  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  var body = jsonEncode({
    "first_name": name,
    "last_name": surname,
    "date_of_birth": birthDate,
  });

  var response = await http.put(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode != 204) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unknownError);
  }

  return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult> checkMailExist(String email) async {
  String url = "${Config.apiUrl}/auth/check_email_status/$email/";

  var response = await http.get(Uri.parse(url));

  var data = jsonDecode(response.body);

  var resultStatus = ResultEnum.emailNotFound;

  if (data["status"] == "verified") {
    resultStatus = ResultEnum.ok;
  } else if (data["status"] == "not found") {
    resultStatus = ResultEnum.emailNotFound;
  } else {
    resultStatus = ResultEnum.emailNotVerified;
  }

  return PossibleErrorResult(resultData: null, resultStatus: resultStatus);
}

Future<PossibleErrorResult> registerUser(
    String username, String email, String password) async {
  var body = jsonEncode({
    "username": username,
    "email": email,
    "password1": password,
    "password2": password,
  });

  String url = "${Config.apiUrl}/auth/registration/";

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 400) {
    var responseData = jsonDecode(response.body);

    if (responseData["email"] != null) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.emailAlreadyExists);
    }

    if (responseData["password1"] != null) {
      var messages = responseData["password1"];

      return PossibleErrorResult(
          resultData: messages, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.emailAlreadyExists);
  }

  return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult<Map<String, String>>> loginUser(
    String email, String password) async {
  var url = "${Config.apiUrl}/auth/token/";

  var body = jsonEncode({
    "username": email,
    "password": password,
  });

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 401 || response.statusCode == 400) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.wrongPassword);
  }

  var responseData = jsonDecode(response.body);
  var tokens = {
    "access": responseData["access"]?.toString() ?? "",
    "refresh": responseData["refresh"]?.toString() ?? "",
  };

  print(tokens["access"]);

  return PossibleErrorResult(resultData: tokens, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult<Map<String, String>>> loginGoogleUser(
    String idToken) async {
  var url = "${Config.apiUrl}/auth/firebase-login/";

  var body = jsonEncode({
    "idToken": idToken,
  });

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 401 || response.statusCode == 400) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.wrongPassword);
  }

  var responseData = jsonDecode(response.body);
  var tokens = {
    "access": responseData["access"]?.toString() ?? "",
    "refresh": responseData["refresh"]?.toString() ?? "",
  };

  print(tokens["access"]);

  return PossibleErrorResult(resultData: tokens, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult> sendPasswordResetEmail(String email) async {
  var url = "${Config.apiUrl}/auth/password_reset/";

  var body = jsonEncode({
    "email": email,
  });

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 400) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.emailNotFound);
  }

  return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult> resetPassword(String password, String token) async {
  var url = "${Config.apiUrl}/auth/password_reset/confirm/";

  var body = jsonEncode({
    "password": password,
    "token": token,
  });

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 404) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unknownToken);
  }

  if (response.statusCode == 400) {
    var responseData = jsonDecode(response.body);
    var messages = responseData["password"];

    return PossibleErrorResult(
        resultData: messages, resultStatus: ResultEnum.wrongPassword);
  }

  return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult<SharkSearchInfo>> getFavoriteSharks() async {
  if (Config.accessToken == null) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var url = "${Config.apiUrl}/sharks/get_favourite/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 401) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var data = jsonDecode(response.body);

  return PossibleErrorResult(
      resultData: SharkSearchInfo.fromJson(data), resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult<BuoySearchInfo>> getFavoriteBuoys() async {
  if (Config.accessToken == null) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var url = "${Config.apiUrl}/buoys/list_favourite/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 401) {
    return PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var data = jsonDecode(response.body);

  return PossibleErrorResult(
      resultData: BuoySearchInfo.fromJson(data), resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult> _addBuoyToFavorite(String buoyId) {
  if (Config.accessToken == null) {
    return Future.value(PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized));
  }

  var url = "${Config.apiUrl}/buoys/add_to_favourite/$buoyId/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  return http.put(Uri.parse(url), headers: headers).then((response) {
    if (response.statusCode == 401) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unauthorized);
    }

    if (response.statusCode != 204) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
  });
}

Future<PossibleErrorResult> _removeBuoyFromFavorite(String buoyId) {
  if (Config.accessToken == null) {
    return Future.value(PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized));
  }

  var url = "${Config.apiUrl}/buoys/remove_from_favourite/$buoyId/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  return http.delete(Uri.parse(url), headers: headers).then((response) {
    if (response.statusCode == 401) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unauthorized);
    }

    if (response.statusCode != 204) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
  });
}

Future<PossibleErrorResult> changeBuoyFavoriteValue(String buoyId, bool lastValue) {
  if (lastValue) {
    return _removeBuoyFromFavorite(buoyId);
  }

  return _addBuoyToFavorite(buoyId);
}

Future<PossibleErrorResult> _addSharkToFavoriteValue(String sharkId) {
  if (Config.accessToken == null) {
    return Future.value(PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized));
  }

  var url = "${Config.apiUrl}/sharks/add_to_favourite/$sharkId/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  return http.put(Uri.parse(url), headers: headers).then((response) {
    if (response.statusCode == 401) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unauthorized);
    }

    if (response.statusCode != 204) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
  });
}

Future<PossibleErrorResult> _removeSharkFromFavorite(String sharkId) {
  if (Config.accessToken == null) {
    return Future.value(PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized));
  }

  var url = "${Config.apiUrl}/sharks/remove_from_favourite/$sharkId/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  return http.delete(Uri.parse(url), headers: headers).then((response) {
    if (response.statusCode == 401) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unauthorized);
    }

    if (response.statusCode != 204) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
  });
}

Future<PossibleErrorResult> changeSharkFavoriteValue(String sharkId, bool lastValue) {
  if (lastValue) {
    return _removeSharkFromFavorite(sharkId);
  }

  return _addSharkToFavoriteValue(sharkId);
}

Future<PossibleErrorResult> deletePhoto() {
  if (Config.accessToken == null) {
    return Future.value(PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized));
  }

  var url = "${Config.apiUrl}/users/delete_photo/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  return http.delete(Uri.parse(url), headers: headers).then((response) {
    if (response.statusCode == 401) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unauthorized);
    }

    if (response.statusCode != 200) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
  });
}

Future<PossibleErrorResult> updatePhoto(String photo) {
  if (Config.accessToken == null) {
    return Future.value(PossibleErrorResult(
        resultData: null, resultStatus: ResultEnum.unauthorized));
  }

  var url = "${Config.apiUrl}/users/add_photo/";

  var headers = {
    "Authorization": "Bearer ${Config.accessToken}",
    "Content-Type": "application/json",
  };

  var body = jsonEncode({
    "photo": photo,
  });

  return http.post(Uri.parse(url), headers: headers, body: body).then((response) {
    if (response.statusCode == 401) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unauthorized);
    }

    if (response.statusCode != 204) {
      return PossibleErrorResult(
          resultData: null, resultStatus: ResultEnum.unknownError);
    }

    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
  });
}