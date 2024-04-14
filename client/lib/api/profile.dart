import '../models/config.dart';
import '../models/profile_info.dart';


Future<PossibleErrorResult<ProfileInfo>> getUserInfo() async {
  if (Config.accessToken == null){
    return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.unauthorized);
  }

  var result = ProfileInfo(
    name: 'Zloy Husit',
    email: 'account@enterneta.net',
    photoUrl: 'https://static.sobaka.ru/images/post/00/05/59/00/_huge.jpg?v=1594891809',
  );

  return PossibleErrorResult(resultData: result, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult> checkMailExist(String email) async {
  return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.emailAlreadyExist);
}

Future<PossibleErrorResult> registerUser(String name, String username, String email, String password) async {
  return PossibleErrorResult(resultData: null, resultStatus: ResultEnum.ok);
}

Future<PossibleErrorResult<String>> loginUser(String email, String password) async {
  return PossibleErrorResult(resultData: "Token", resultStatus: ResultEnum.ok);
}