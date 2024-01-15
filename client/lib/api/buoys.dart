// Функция поиска буев
import 'package:latlong2/latlong.dart';

import '../models/buoy.dart';
import '../models/config.dart';
import 'map.dart';

Future<BuoySearchInfo> searchBuoy(String query) async {
  // Список захардкодированных буев (пример)
  List<BuoyMapInfo> allBuoys = [
    await getBuoyMapInfo("buoy1")
    // Добавьте дополнительные буи здесь
  ];

  // Фильтрация списка буев по введенному запросу
  // List<BuoyMapInfo> filteredBuoys = allBuoys.where((buoy) {
  //   return buoy.name.toLowerCase().contains(query.toLowerCase());
  // }).toList();

  return BuoySearchInfo(buoys: allBuoys);
}


Future<BuoyFullInfo> getBuoyFullInfo(String buoyId) async {
  // Захардкодированные данные
  return BuoyFullInfo(
    id: buoyId,
    name: "Buoy Name",
    photo: Config.defaultBuoyUrl,
    location: LatLng(37.4219983, -122.0840579),
    status: "Active",
    pings: 20,
    activeBuoyDays: 365,
    detectedSharks: 5,
    dateOfPlacement: "2023-01-01",
    description: "Detailed description of the buoy.",
    lastPing: "2024-01-07",
    sharksList: [
      await getSharkMapInfo("shark1")
    ],
  );
}