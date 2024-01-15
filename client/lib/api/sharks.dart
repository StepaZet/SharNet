import '../models/config.dart';
import '../models/shark.dart';
import 'map.dart';

Future<SharkSearchInfo> searchShark(String query) async {
  // Список захардкодированных акул (пример)
  List<SharkMapInfo> allSharks = [
    await getSharkMapInfo("shark1"),
    // Добавьте дополнительные акулы здесь
  ];

  // Фильтрация списка акул по введенному запросу
  // List<SharkMapInfo> filteredSharks = allSharks.where((shark) {
  //   return shark.name.toLowerCase().contains(query.toLowerCase());
  // }).toList();

  return SharkSearchInfo(sharks: allSharks);
}

Future<SharkFullInfo> getSharkFullInfo(String sharkId) async {
  // Захардкодированные данные
  return SharkFullInfo(
    id: sharkId,
    name: "Great White Shark",
    photo: Config.defaultSharkUrl,
    length: 5.5,
    weight: 1200.0,
    sex: "Female",
    age: "10 years",
    tracks: 15,
    description: "A detailed description of the shark.",

    passedMiles: 2500.0,
    deploymentLength: "5 years",
    firstTagged: "2019-01-01",
    lastTagged: "2024-01-01",

    buoysList: [
      await getBuoyMapInfo("buoy1"),
    ],

    averageLength: 4.5,
    averageWeight: 1100.0,
  );
}