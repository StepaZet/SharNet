import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

import '../api/map.dart';
import '../models/config.dart';
import '../models/positions.dart';
import '../models/shark.dart';
import 'date_picker.dart';

class SharkTrackMap extends StatefulWidget {
  final SharkMapInfo shark;

  const SharkTrackMap({super.key, required this.shark});

  @override
  SharkTrackMapState createState() => SharkTrackMapState();
}

class SharkTrackMapState extends State<SharkTrackMap> {
  bool _useOpenStreetMap = true;

  DateTime _startDate = Config.defaultStartDate;
  DateTime _endDate = Config.defaultEndDate;



  // Widget _buildMap() {
  //   List<Marker> markers = [];
  //   List<Polyline> polylines = [];
  //
  //   for (var track in widget.tracks) {
  //     for (var point in track) {
  //       markers.add(
  //         Marker(
  //           width: 20.0,
  //           height: 20.0,
  //           point: point.coordinates,
  //           builder: (ctx) => SvgPicture.asset('assets/MarkerPoint.svg', semanticsLabel: 'Point Marker'),
  //         ),
  //       );
  //     }
  //
  //     var polylinePoints = track.map((e) => e.coordinates).toList();
  //     polylines.add(
  //       Polyline(
  //         points: polylinePoints,
  //         color: Colors.blueAccent,
  //         strokeWidth: 2.0,
  //       ),
  //     );
  //   }
  //
  //   return FlutterMap(
  //     options: MapOptions(
  //       center: widget.tracks.isNotEmpty && widget.tracks.first.isNotEmpty
  //           ? widget.tracks.first.first.coordinates
  //           : LatLng(0, 0),
  //       zoom: 3.2,
  //       interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
  //     ),
  //     layers: [
  //       TileLayerOptions(
  //         urlTemplate: _useOpenStreetMap
  //             ? Config.simpleMapUrl
  //             : Config.realisticMapUrl,
  //         subdomains: ['a', 'b', 'c'],
  //       ),
  //       PolylineLayerOptions(
  //         polylines: polylines,
  //       ),
  //       MarkerLayerOptions(
  //         markers: markers,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMap() {

    return FutureBuilder<SharkMapInfo>(
      future: getSharkMapInfo(widget.shark.id, Config.defaultStartDate, Config.defaultEndDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Marker> markers = [];
        List<Polyline> polylines = [];

        List<List<PointInfo>> tracks = snapshot.data!.tracksList;

        for (var track in tracks) {
          for (var point in track) {
            markers.add(
              Marker(
                width: 20.0,
                height: 20.0,
                point: point.coordinates,
                child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset('assets/MarkerBuoy.svg',
                      semanticsLabel: 'Point Buoy'),
                ),

                // builder: (ctx) => SvgPicture.asset('assets/MarkerBuoy.svg', semanticsLabel: 'Point Buoy'),
              ),
            );
          }

          var polylinePoints = track.map((e) => e.coordinates).toList();
          polylines.add(
            Polyline(
              points: polylinePoints,
              color: Colors.blueAccent,
              strokeWidth: 2.0,
            ),
          );
        }

        return FlutterMap(
          options: MapOptions(
            initialCenter: tracks.isNotEmpty && tracks.first.isNotEmpty
                ? tracks.first.first.coordinates
                : const LatLng(0, 0),
            initialZoom: tracks.isNotEmpty && tracks.first.isNotEmpty ? 10 : 3.2,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          ),
          children: [
            TileLayer(
              urlTemplate: _useOpenStreetMap
                  ? Config.simpleMapUrl
                  : Config.realisticMapUrl,
              subdomains: const ['a', 'b', 'c'],
            ),
            PolylineLayer(
              polylines: polylines,
            ),
            MarkerLayer(
              markers: markers,
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMap(),
        Positioned(
          bottom: 20.0,
          right: 10.0,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'switchMap',
            backgroundColor: Colors.white,
            child: Icon(_useOpenStreetMap ? Icons.satellite : Icons.map,
                color: Colors.blue),
            onPressed: () {
              setState(() {
                _useOpenStreetMap = !_useOpenStreetMap;
              });
            },
          ),
        ),
        const DatePicker(),
      ],
    );
  }
}
