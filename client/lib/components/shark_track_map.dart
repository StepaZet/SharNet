import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/config.dart';
import '../models/track.dart';

class SharkTrackMap extends StatelessWidget {
  final List<Track> tracks;

  SharkTrackMap({required this.tracks});

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    List<Polyline> polylines = [];

    for (var track in tracks) {
      for (var point in track.points) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: point.coordinates,
            builder: (ctx) =>
                Container(
                  child: Icon(Icons.location_on, color: Colors.red),
                ),
          ),
        );
      }

      var polylinePoints = track.points.map((e) => e.coordinates).toList();
      polylines.add(
        Polyline(
          points: polylinePoints,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      );
    }

    return FlutterMap(
      options: MapOptions(
        center: tracks.isNotEmpty && tracks.first.points.isNotEmpty
            ? tracks.first.points.first.coordinates
            : LatLng(0, 0),
        zoom: 5.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: Config.simpleMapUrl,
          subdomains: ['a', 'b', 'c'],
        ),
        PolylineLayerOptions(
          polylines: polylines,
        ),
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }
}
