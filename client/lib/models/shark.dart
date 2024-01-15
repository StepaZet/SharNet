import 'dart:typed_data';

import 'package:client/models/buoy.dart';
import 'package:client/models/positions.dart';

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
    required this.lastTagged,
    required this.tracksList,
  }) : tracks = tracksList.length;
}

class SharkSearchInfo {
  List<SharkMapInfo> sharks;

  SharkSearchInfo({
    required this.sharks,
  });
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
  });
}