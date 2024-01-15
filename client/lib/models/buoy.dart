import 'dart:typed_data';

import 'package:client/models/positions.dart';
import 'package:client/models/shark.dart';
import 'package:latlong2/latlong.dart';

class BuoyMapInfo {
  String id;
  String name;
  String photo; // bytes для изображения
  List<double> location; // tuple[float, float]
  int pings;
  int detectedSharks;
  int detectedTracks;
  String lastPing; // datetime в формате ISO
  List<ShortPositionInfo> sharksList;

  BuoyMapInfo({
    required this.id,
    required this.name,
    required this.photo,
    required this.location,
    required this.pings,
    required this.detectedSharks,
    required this.detectedTracks,
    required this.lastPing,
    required this.sharksList,
  });
}

class BuoySearchInfo {
  List<BuoyMapInfo> buoys;

  BuoySearchInfo({
    required this.buoys,
  });
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
}
