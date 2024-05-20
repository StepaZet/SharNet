import 'package:client/models/buoy.dart';
import 'package:client/models/positions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SharkMapInfo {
  String id;
  String name;
  String photo; // bytes для изображения
  double length;
  double weight;
  String sex;
  int tracks;
  String lastTagged; // datetime в формате ISO
  List<List<PointInfo>> tracksList;

  SharkMapInfo({
    required this.id,
    required this.name,
    required this.photo,
    required this.length,
    required this.weight,
    required this.sex,
    required this.tracks,
    required this.lastTagged,
    required this.tracksList,
  });

  // from json
  static SharkMapInfo fromJson(Map<String, dynamic> json) {
    List<List<PointInfo>> tracksList = [];

    for (var track in json['tracks_list']) {
      List<PointInfo> trackList = [];
      for (var point in track) {
        trackList.add(PointInfo.fromJson(point));
      }
      tracksList.add(trackList);
    }

    String sex;
    if (json["sex"] == 'F') {
      sex = 'Female';
    } else if (json["sex"] == 'M') {
      sex = 'Male';
    } else {
      sex = 'Unknown';
    }

    return SharkMapInfo(
      id: json["id"],
      name: json["name"],
      photo: json["photo_url"],
      length: json["length"],
      weight: json["weight"],
      tracks: json["tracks"],
      sex: sex,
      lastTagged: json["last_tagged"].substring(0, 10),
      // Обрезать
      tracksList: tracksList,
    );
  }

  List<Polyline> getRoute() {
    List<Polyline> polylines = [];
    for (var track in tracksList) {
      List<LatLng> polylinePoints = [];
      for (var point in track) {
        // Добавляем точку в полилинию
        polylinePoints.add(
            LatLng(point.coordinates.latitude, point.coordinates.longitude));
      }
      // Добавляем полилинию в список
      polylines.add(Polyline(
        points: polylinePoints,
        color: Colors.blueAccent,
        strokeWidth: 2.0,
      ));
    }
    return polylines;
  }
}

class SharkSearchInfo {
  List<SharkMapInfo> sharks;

  SharkSearchInfo({
    required this.sharks,
  });

  // from json
  static SharkSearchInfo fromJson(List<dynamic> json) {
    List<SharkMapInfo> sharks = [];

    for (var shark in json) {
      sharks.add(SharkMapInfo.fromJson(shark));
    }

    return SharkSearchInfo(
      sharks: sharks,
    );
  }
}

class SharkFullInfo {
  String id;
  String name;
  String photo; // bytes для изображения
  double length;
  double weight;
  String sex;
  String age;
  int tracks;
  String description;

  double passedMiles;
  String deploymentLength;
  String firstTagged;
  String lastTagged;

  List<BuoyMapInfo> buoysList;

  double averageLength;
  double averageWeight;

  List<List<String>> topWeight;
  List<List<String>> topLength;

  SharkFullInfo({
    required this.id,
    required this.name,
    required this.photo,
    required this.length,
    required this.weight,
    required this.sex,
    required this.age,
    required this.tracks,
    required this.description,
    required this.passedMiles,
    required this.deploymentLength,
    required this.firstTagged,
    required this.lastTagged,
    required this.buoysList,
    required this.averageLength,
    required this.averageWeight,
    required this.topWeight,
    required this.topLength,
  });

  // from json
  static SharkFullInfo fromJson(Map<String, dynamic> json) {
    List<BuoyMapInfo> buoysList = [];
    for (var buoy in json['buoys_list']) {
      buoysList.add(BuoyMapInfo.fromJson(buoy));
    }

    String sex;
    if (json["sex"] == 'F') {
      sex = 'Female';
    } else if (json["sex"] == 'M') {
      sex = 'Male';
    } else {
      sex = 'Unknown';
    }

    List<List<String>> topWeight = [];
    List<List<String>> topLength = [];

    for (var record in json["top_weight"]) {
      List<String> result = [];
      for (var data in record) {
        result.add(data);
      }
      topWeight.add(result);
    }

    for (var record in json["top_length"]) {
      List<String> result = [];
      for (var data in record) {
        result.add(data);
      }
      topLength.add(result);
    }


    return SharkFullInfo(
      id: json["id"],
      name: json["name"],
      photo: json["photo_url"],
      length: json["length"],
      weight: json["weight"],
      sex: sex,
      age: json["age"],
      tracks: json["tracks"],
      description: json["description"],
      passedMiles: json["passed_miles"],
      deploymentLength: json["deployment_length"],
      firstTagged: json["first_tagged"].substring(0, 10),
      lastTagged: json["last_tagged"].substring(0, 10),
      buoysList: buoysList,
      averageLength: json["average_length"],
      averageWeight: json["average_weight"],  // опечатка, как Илья исправит, так и здесь исправлю
      topWeight: topWeight,
      topLength: topLength,
    );
  }
}
