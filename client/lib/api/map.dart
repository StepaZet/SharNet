import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:client/models/buoy.dart';
import 'package:client/models/config.dart';
import 'package:client/models/positions.dart';
import 'package:client/models/shark.dart';

Future<MapShortInfo> getMapShortInfo(
    DateTime startDate, DateTime endDate) async {
  String url =
      "${Config.apiUrl}/common/by_date/?date_from=${startDate.toIso8601String()}&date_to=${endDate.toIso8601String()}";

  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return MapShortInfo.fromJson(data);
  }

  return MapShortInfo(sharks: [
    ShortPositionInfo(coordinates: LatLng(37.4219983, -122.0840579), id: "1"),
    // ShortPositionInfo(coordinates: LatLng(37.4219983, -122.0840579), id: "2"),
  ], buoys: [
    // ShortPositionInfo(coordinates: LatLng(37.4219983, -122.0840579), id: "1"),
    // ShortPositionInfo(coordinates: LatLng(37.4219983, -122.0840579), id: "2"),
  ]);
}

Future<BuoyMapInfo> getBuoyMapInfo(
    String buoyId, DateTime start, DateTime end) async {
  String url =
      "${Config.apiUrl}/buoys/by_id_and_date/$buoyId/?date_from=${start.toIso8601String()}&date_to=${end.toIso8601String()}";

  Map<String, String> headers = {};

  if (Config.accessToken != null) {
    headers['Authorization'] = 'Bearer ${Config.accessToken}';
    headers['Content-Type'] = 'application/json';
  }

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return BuoyMapInfo.fromJson(data);
  }

  // Захардкодированные данные для буя
  return BuoyMapInfo(
    id: buoyId,
    name: "Test Buoy",
    photo: Config.defaultBuoyUrl,
    location: const LatLng(37.4219983, -122.0840579),
    pings: 10,
    detectedSharks: 2,
    lastPing: "2024-01-07",
    sharksList: [],
  );
}

Future<SharkMapInfo> getSharkMapInfo(
    String sharkId, DateTime start, DateTime end) async {
  String url =
      "${Config.apiUrl}/sharks/get_by_id_and_date/$sharkId/?date_from=${start.toIso8601String()}&date_to=${end.toIso8601String()}";

  Map<String, String> headers = {};

  if (Config.accessToken != null) {
    headers['Authorization'] = 'Bearer ${Config.accessToken}';
    headers['Content-Type'] = 'application/json';
  }

  var response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return SharkMapInfo.fromJson(data);
  }

  // Захардкодированные данные для акулы
  return SharkMapInfo(
    id: sharkId,
    name: "Great White Shark",
    photo: Config.defaultSharkUrl,
    length: 5.5,
    // длина в метрах
    weight: 1200.0,
    // вес в кг
    sex: "Female",
    tracks: 1,
    lastTagged: "2023-12-15",
    tracksList: [
      [
        PointInfo(
            coordinates: LatLng(37.4219983, -122.0840579),
            dateTime: DateTime.parse("2023-12-15T10:00:00Z")),
        PointInfo(
            coordinates: LatLng(67.4220000, -122.0840575),
            dateTime: DateTime.parse("2023-12-15T11:00:00Z")),
        PointInfo(
            coordinates: LatLng(50.4220000, -92.0840575),
            dateTime: DateTime.parse("2023-12-15T11:00:00Z"))
      ],
    ],
  );
}
