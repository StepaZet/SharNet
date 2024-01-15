import 'package:latlong2/latlong.dart';

import '../models/buoy.dart';
import '../models/config.dart';
import '../models/positions.dart';
import '../models/shark.dart';

Future<MapShortInfo> getMapShortInfo(DateTime startDate, DateTime endDate) async{
  // Захардкодированные данные
  List<ShortPositionInfo> mockSharks = [
    ShortPositionInfo(coordinates: LatLng(27.4219999, -122.0862462), id: "shark1"),
    // ShortPositionInfo(coordinates: LatLng(47.4220000, -142.0840575), id: "shark2"),
  ];

  List<ShortPositionInfo> mockBuoys = [
    ShortPositionInfo(coordinates: LatLng(29.4219983, -123.0840579), id: "buoy1"),
    // ShortPositionInfo(coordinates: LatLng(36.4219991, -121.0862467), id: "buoy2"),
  ];

  return MapShortInfo(sharks: mockSharks, buoys: mockBuoys);
}


Future<BuoyMapInfo> getBuoyMapInfo(String buoyId) async{
  // Захардкодированные данные для буя
  return BuoyMapInfo(
    id: buoyId,
    name: "Test Buoy",
    photo: Config.defaultBuoyUrl,
    location: [37.4219983, -122.0840579],
    pings: 10,
    detectedSharks: 2,
    detectedTracks: 5,
    lastPing: "2024-01-07",
    sharksList: [
      ShortPositionInfo(coordinates: LatLng(37.4219999, -122.0862462), id: "shark1"),
      ShortPositionInfo(coordinates: LatLng(37.4220000, -122.0840575), id: "shark2"),
    ],
  );
}


Future<SharkMapInfo> getSharkMapInfo(String sharkId) async {
  // Захардкодированные данные для акулы
  return SharkMapInfo(
    id: sharkId,
    name: "Great White Shark",
    photo: Config.defaultSharkUrl,
    length: 5.5, // длина в метрах
    weight: 1200.0, // вес в кг
    sex: "Female",
    lastTagged: "2023-12-15",
    tracksList: [
      [
        PointInfo(coordinates: LatLng(27.4219999, -122.0862462), dateTime: DateTime.parse("2023-12-15T10:00:00Z")),
        PointInfo(coordinates: LatLng(67.4220000, -122.0840575), dateTime: DateTime.parse("2023-12-15T11:00:00Z")),
        PointInfo(coordinates: LatLng(50.4220000, -92.0840575), dateTime: DateTime.parse("2023-12-15T11:00:00Z"))
      ],
      // [
      //   PointInfo(coordinates: LatLng(38.4219999, -123.0862462), dateTime: DateTime.parse("2023-12-15T10:00:00Z")),
      //   PointInfo(coordinates: LatLng(38.4220000, -123.0840575), dateTime: DateTime.parse("2023-12-15T11:00:00Z")),
      // ],
    ],
  );
}