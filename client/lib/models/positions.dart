import 'package:latlong2/latlong.dart';

class ShortPositionInfo {
  LatLng coordinates;
  String id;

  ShortPositionInfo({
    required this.coordinates,
    required this.id,
  });

  // from json
  static ShortPositionInfo fromJson(Map<String, dynamic> json) {
    return ShortPositionInfo(
      coordinates: LatLng(json["coordinates"][0], json["coordinates"][1]), // [latitude, longitude]
      id: json['id'],
    );
  }
}


class PointInfo {
  LatLng coordinates;
  DateTime dateTime;

  PointInfo({
    required this.coordinates,
    required this.dateTime,
  });

  // from json
  static PointInfo fromJson(Map<String, dynamic> json) {
    return PointInfo(
      coordinates: LatLng(json["coordinates"][0], json["coordinates"][1]), // [latitude, longitude]
      dateTime: DateTime.parse(json["date"]),
    );
  }
}


class MapShortInfo {
  List<ShortPositionInfo> sharks;
  List<ShortPositionInfo> buoys;

  MapShortInfo({
    required this.sharks,
    required this.buoys,
  });

  // from json
  static MapShortInfo fromJson(Map<String, dynamic> json) {
    List<ShortPositionInfo> sharks = [];
    List<ShortPositionInfo> buoys = [];

    for (var shark in json['sharks']) {
      sharks.add(ShortPositionInfo.fromJson(shark));
    }
    for (var buoy in json['buoys']) {
      buoys.add(ShortPositionInfo.fromJson(buoy));
    }

    return MapShortInfo(sharks: sharks, buoys: buoys);
  }
}