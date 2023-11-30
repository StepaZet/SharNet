import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/config.dart';

class BuoyMap extends StatefulWidget {
  final double locationLongitude;
  final double locationLatitude;

  BuoyMap({
    super.key,
    required this.locationLongitude,
    required this.locationLatitude,
  });

  @override
  _BuoyMapState createState() => _BuoyMapState();
}

class _BuoyMapState extends State<BuoyMap> {
  bool _useOpenStreetMap = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(widget.locationLatitude, widget.locationLongitude),
            zoom: 3.2,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: _useOpenStreetMap
                  ? Config.simpleMapUrl : Config.realisticMapUrl,
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(widget.locationLatitude, widget.locationLongitude),
                  builder: (ctx) => Icon(Icons.place, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 50.0,
          right: 10.0,
          child: FloatingActionButton(
            child: Icon(
              _useOpenStreetMap ? Icons.satellite : Icons.map,
            ),
            onPressed: () {
              setState(() {
                _useOpenStreetMap = !_useOpenStreetMap;
              });
            },
          ),
        )
      ],
    );
  }
}




/*

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

import '../models/config.dart';

class BuoyMap extends StatefulWidget {
  final double locationLongitude;
  final double locationLatitude;

  BuoyMap({
    required this.locationLongitude,
    required this.locationLatitude,
  });

  @override
  _BuoyMapState createState() => _BuoyMapState();
}

class _BuoyMapState extends State<BuoyMap> {
  bool _useOpenStreetMap = true;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 3.2,
      ),
      children: [
        TileLayer(
          //tileProvider: CancellableNetworkTileProvider(),
          urlTemplate: _useOpenStreetMap
              ? Config.simpleMapUrl : Config.realisticMapUrl,
          subdomains: const ['a', 'b', 'c'],
        ),
        // MarkerLayer(
        //   markers: [
        //     Marker(
        //       width: 80.0,
        //       height: 80.0,
        //       point: LatLng(widget.locationLatitude, widget.locationLongitude),
        //       child: const Icon(Icons.place, color: Colors.red),
        //     ),  // TODO: Проверить работу
        //   ],
        // ),
        Positioned(
          bottom: 50.0,
          right: 10.0,
          child: FloatingActionButton(
            child: Icon(
              _useOpenStreetMap ? Icons.satellite : Icons.map,
            ),
            onPressed: () {
              setState(() {
                _useOpenStreetMap = !_useOpenStreetMap;
              });
            },
          ),
        )
      ],
    );
  }
}

 */
