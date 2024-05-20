import 'package:client/models/shark.dart';
import 'package:latlong2/latlong.dart';

class BuoyMapInfo {
  String id;
  String name;
  String photo; // bytes для изображения
  LatLng location; // tuple[float, float]
  int pings;
  int detectedSharks;
  String lastPing; // datetime в формате ISO
  List<String> sharksList;
  bool? isFavorite;

  BuoyMapInfo({
    required this.id,
    required this.name,
    required this.photo,
    required this.location,
    required this.pings,
    required this.detectedSharks,
    required this.lastPing,
    required this.sharksList,
    this.isFavorite,
  });

  // from json
  static BuoyMapInfo fromJson(Map<String, dynamic> json) {
    List<String> sharksList = [];

    for (var shark in json['sharks_list']) {
      sharksList.add(shark['id']);
    }

    return BuoyMapInfo(
      id: json["id"],
      name: json["name"],
      photo: json["photo_url"],
      location: LatLng(json["location"][0], json["location"][1]),
      pings: json["pings"],
      detectedSharks: json["detected_sharks"],
      lastPing: json["last_ping"].substring(0, 10),  // Обрезать
      sharksList: sharksList,
      isFavorite: json["is_favourite"],
    );
  }
}


class BuoySearchInfo {
  List<BuoyMapInfo> buoys;

  BuoySearchInfo({
    required this.buoys,
  });

  // from json
  static BuoySearchInfo fromJson(List<dynamic> json) {
    List<BuoyMapInfo> buoys = [];

    for (var buoy in json) {
      buoys.add(BuoyMapInfo.fromJson(buoy));
    }

    return BuoySearchInfo(
      buoys: buoys,
    );
  }
}


class BuoyFullInfo {
  String id;
  String name;
  String photo; // bytes для изображения
  LatLng location;
  String status;
  int pings;
  int activeBuoyDays;
  int detectedSharks;
  String dateOfPlacement;
  String description;
  String lastPing;
  List<SharkMapInfo> sharksList;

  BuoyFullInfo({
    required this.id,
    required this.name,
    required this.photo,
    required this.location,
    required this.status,
    required this.pings,
    required this.activeBuoyDays,
    required this.detectedSharks,
    required this.dateOfPlacement,
    required this.description,
    required this.lastPing,
    required this.sharksList,
  });

  // from json

  static BuoyFullInfo fromJson(Map<String, dynamic> json) {
    List<SharkMapInfo> sharksList = [];

    for (var buoy in json['sharks_list']) {
      sharksList.add(SharkMapInfo.fromJson(buoy));
    }

    return BuoyFullInfo(
      id: json["id"],
      name: json["name"],
      photo: json["photo_url"],
      location: LatLng(json["location"][0], json["location"][1]),
      status: json["status"],
      pings: json["pings"],
      activeBuoyDays: json["active_buoy_days"],
      detectedSharks: json["detected_sharks"],
      dateOfPlacement: json["date_of_placement"].substring(0, 10),
      description: json["description"],
      lastPing: json["last_ping"].substring(0, 10),
      sharksList: sharksList,
    );
  }
}
