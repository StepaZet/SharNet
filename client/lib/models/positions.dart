import 'package:latlong2/latlong.dart';

class ShortPositionInfo {
  LatLng coordinates;
  String id;

  ShortPositionInfo({
    required this.coordinates,
    required this.id,
  });
}


class PointInfo {
  LatLng coordinates;
  DateTime dateTime;

  PointInfo({
    required this.coordinates,
    required this.dateTime,
  });
}


class MapShortInfo {
  List<ShortPositionInfo> sharks;
  List<ShortPositionInfo> buoys;

  MapShortInfo({
    required this.sharks,
    required this.buoys,
  });
}