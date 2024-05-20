// Определение класса для возвращаемого объекта
import 'package:client/models/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Для работы с json

class AboutSharksInfo {
  String photo; // bytes для изображения
  String info;

  AboutSharksInfo({
    required this.photo,
    required this.info,
  });
}

// Функция, возвращающая объект PhotoInfo
Future<AboutSharksInfo> getInfoAboutSharks() async {
  String url = "${Config.apiUrl}/sharks/info";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return AboutSharksInfo(
      photo: Config.defaultSharkUrl,
      info: data['info'],
    );
  }


  return AboutSharksInfo(
    photo: Config.defaultSharkUrl,
    info: "This is a sample information string.",
  );
}


// Определение класса для возвращаемого объекта
class AboutProjectInfo {
  String info;

  AboutProjectInfo({
    required this.info,
  });
}

// Функция, возвращающая информацию о проекте
Future<AboutProjectInfo> getInfoAboutProject() async {
  String url = "${Config.apiUrl}/common/info/";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return AboutProjectInfo(
      info: data['info'],
    );
  }

  return AboutProjectInfo(
      info: "This project is dedicated to tracking marine life using advanced sensors. Our goal is to provide valuable data for marine biology research and conservation efforts."
  );
}
