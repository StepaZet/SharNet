
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import '../../components/shark_card.dart';
import '../../mocks/sharks_list.dart';
import '../../models/config.dart';
import '../../models/shark.dart';
import '../../models/shark_point.dart';
import '../../models/track.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _useOpenStreetMap = true;
  List<Marker> _markers = [];
  Shark? _selectedShark;

  @override
  void initState() {
    super.initState();
    _setupMarkers();
  }

  void _setupMarkers() {
    List<Shark> sharks = getSharks();
    _markers = sharks.map((shark) => _createMarker(shark)).toList();
  }

  Marker _createMarker(Shark shark) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: shark.tracks[0].points[0].coordinates,
      builder: (ctx) => GestureDetector(
        onTap: () => _selectShark(shark),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Center(
            child: Icon(
              Icons.tsunami,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _selectShark(Shark shark) {
    setState(() {
      _selectedShark = shark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(51.509364, -0.128928),
              zoom: 3.2,
              plugins: [
                MarkerClusterPlugin(),
              ],
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: _useOpenStreetMap
                    ? Config.simpleMapUrl
                    : Config.realisticMapUrl,
                subdomains: ['a', 'b', 'c'],
              ),
              if (_selectedShark != null)
                PolylineLayerOptions(
                  polylines: getPolylines(_selectedShark!),
                ),
              MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                size: Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: FitBoundsOptions(padding: EdgeInsets.all(20)),
                markers: _markers,
                builder: (context, markers) {
                  return FloatingActionButton(
                    child: Text(
                      markers.length.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: null,
                  );
                },
              ),
            ],
          ),
          _buildSharkInfoCard(),
          _buildSwitchMapButton(),
        ],
      ),
    );
  }

  Widget _buildSharkInfoCard() {
    if (_selectedShark == null) {
      return SizedBox
          .shrink(); // Возвращает пустой виджет, если акула не выбрана
    }

    // Используйте MediaQuery для учета высоты статус бара
    double topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 10, // Отступ сверху плюс 10 для небольшого пространства
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(2),
        child: SharkCard(shark: _selectedShark!), // Ваш SharkCard виджет
      ),
    );
  }

  Widget _buildSwitchMapButton() {
    // Виджет кнопки для переключения карты
    return Positioned(
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
    );
  }


  List<Polyline> getPolylines(Shark shark) {
    List<Polyline> polylines = [];

    for (Track track in shark.tracks) {
      List<LatLng> points = [];
      for (SharkPoint point in track.points) {
        points.add(point.coordinates);
      }
      polylines.add(
        Polyline(
          points: points,
          color: Colors.red,
          strokeWidth: 2.0,
        ),
      );
    }

    return polylines;
  }



}
