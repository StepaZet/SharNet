import 'package:latlong2/latlong.dart';

import '../models/shark.dart';
import '../models/shark_point.dart';
import '../models/track.dart';

List<Shark> getSharks(){
  List<Track> tracks = [
    Track(points: [
      SharkPoint(coordinates: LatLng(37.4219983, -122.084)),
      SharkPoint(coordinates: LatLng(37.3919983, -122.084)),
      SharkPoint(coordinates: LatLng(37.3619983, -122.084)),

    ]),
    Track(points: [
      SharkPoint(coordinates: LatLng(25.761681, -80.191788)),
      SharkPoint(coordinates: LatLng(25.731681, -80.191788)),
      SharkPoint(coordinates: LatLng(25.701681, -80.191788)),
    ]),
  ];

  List<Track> tracks_2 = [
    Track(points: [
      SharkPoint(coordinates: LatLng(55.4219983, -122.084)),
      SharkPoint(coordinates: LatLng(59.3919983, -122.084)),
      SharkPoint(coordinates: LatLng(65.3619983, -122.084)),

    ]),
    Track(points: [
      SharkPoint(coordinates: LatLng(47.761681, -84.191788)),
      SharkPoint(coordinates: LatLng(49.731681, -83.191788)),
      SharkPoint(coordinates: LatLng(57.701681, -82.191788)),
    ]),
  ];
  List<Shark> sharks = [
    Shark(id: "1", age:2, name: 'Sweet Shark', length: 167, weight: 112, sex: 'female', tracks: tracks),
    Shark(id: "2", age:3, name: 'Ilya\'s Mom', length: 169, weight: 312, sex: 'female', tracks: tracks_2),
  ];

  return sharks;
}