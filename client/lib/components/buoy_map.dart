import 'package:client/components/switch_map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

import '../models/config.dart';
import 'date_picker.dart';

class BuoyMap extends StatefulWidget {
  final double locationLongitude;
  final double locationLatitude;

  const BuoyMap({
    super.key,
    required this.locationLongitude,
    required this.locationLatitude,
  });

  @override
  BuoyMapState createState() => BuoyMapState();
}

class BuoyMapState extends State<BuoyMap> {
  bool _useOpenStreetMap = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(widget.locationLatitude, widget.locationLongitude),
            initialZoom: 3.2,
            // interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          ),
          children: [
            TileLayer(
              urlTemplate: _useOpenStreetMap
                  ? Config.simpleMapUrl
                  : Config.realisticMapUrl,
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 20.0,
                  height: 20.0,
                  point:
                      LatLng(widget.locationLatitude, widget.locationLongitude),
                  child: GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/MarkerBuoy.svg',
                        semanticsLabel: 'Buoy Marker'),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SwitchMapButton(),
        const DatePicker(),
      ],
    );
  }
}
