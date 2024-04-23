import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  Marker _createMarker(
      LatLng coordinates, String type, Future<void> Function()? onTap) {

    String imagePath;
    String semanticsLabel;

    if (type == 'shark') {
      imagePath = 'assets/MarkerShark.svg';
      semanticsLabel = 'Shark Marker';
    } else if (type == 'buoy') {
      imagePath = 'assets/MarkerBuoy.svg';
      semanticsLabel = 'Buoy Marker';
    } else {
      imagePath = 'assets/MarkerPoint.svg';
      semanticsLabel = 'Point Marker';
    }

    return Marker(
      width: 20.0,
      height: 20.0,
      point: coordinates,
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(imagePath, semanticsLabel: semanticsLabel),
      ),
    );
  }

  Marker createSharkMarker(
    LatLng coordinates,
    Future<void> Function()? onTap,
  ) {
    return _createMarker(coordinates, 'shark', onTap);
  }

  Marker createBuoyMarker(
    LatLng coordinates,
    Future<void> Function()? onTap,
  ) {
    return _createMarker(coordinates, 'buoy', onTap);
  }

  Marker createPointMarker(
    LatLng coordinates,
    Future<void> Function()? onTap,
  ) {
    return _createMarker(coordinates, 'point', onTap);
  }
}
