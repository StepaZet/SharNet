// Определение класса для возвращаемого объекта
import '../models/config.dart';

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
  // Захардкодированные данные
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
  // Захардкодированная информация о проекте
  return AboutProjectInfo(
      info: "This project is dedicated to tracking marine life using advanced sensors. Our goal is to provide valuable data for marine biology research and conservation efforts."
  );
}
