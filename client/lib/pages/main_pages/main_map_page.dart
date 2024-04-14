import 'package:client/models/buoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/map.dart';
import '../../components/buoy_card.dart';
import '../../components/date_picker.dart';
import '../../components/legent.dart';
import '../../components/map.dart';
import '../../components/shark_card.dart';
import '../../components/switch_map_button.dart';
import '../../models/config.dart';
import '../../models/positions.dart';
import '../../models/shark.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedSharkProvider = StateProvider<SharkMapInfo?>((ref) => null);
final selectedBuoyProvider = StateProvider<BuoyMapInfo?>((ref) => null);

class MainMapPage extends ConsumerStatefulWidget {
  const MainMapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainMapPage> createState() => _MainMapPageState();

}


class _MainMapPageState extends ConsumerState<MainMapPage> with SingleTickerProviderStateMixin {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    Future<void> _updateMap() async {
      final startDate = ref.read(startDateProvider);
      final endDate = ref.read(endDateProvider);

      MapShortInfo info = await getMapShortInfo(startDate, endDate);

      List<Marker> markers = [];
      markers.addAll(info.sharks.map((shark) => _createMarker(shark, 'shark', ref)));
      markers.addAll(info.buoys.map((buoy) => _createMarker(buoy, 'buoy', ref)));

      ref.read(mapMarkersProvider.notifier).state = markers;
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildMap(context, ref),
          const SwitchMapButton(),
          const Legend(),
          DatePicker(subscribers: [_updateMap]),
          Consumer(builder: (context, ref, child) {
            final selectedShark = ref.watch(selectedSharkProvider);
            if (selectedShark != null) {
              return _buildInfoCard(context, ref, SharkCard(shark: selectedShark));
            }
            return const SizedBox();
          }),

          Consumer(builder: (context, ref, child) {
            final selectedBuoy = ref.watch(selectedBuoyProvider);
            if (selectedBuoy != null) {
              return _buildInfoCard(context, ref, BuoyCard(buoy: selectedBuoy));
            }
            return const SizedBox();
          }),

          Consumer(builder: (context, ref, child) {
            final selectedShark = ref.watch(selectedSharkProvider);
            final selectedBuoy = ref.watch(selectedBuoyProvider);

            if (selectedShark != null || selectedBuoy != null) {
              return _buildResetButton(context, ref);
            }

            return const SizedBox();

          }),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 20,
      left: 5,
      height: 40,
      child: FloatingActionButton(
        heroTag: 'resetShark',
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_back_ios_sharp, color: Colors.blue),
        onPressed: () {
          ref.read(selectedSharkProvider.notifier).state = null;
          ref.read(selectedBuoyProvider.notifier).state = null;
          ref.read(mapPolylineProvider.notifier).state = [];
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context, WidgetRef ref) {
    return FutureBuilder<MapShortInfo>(
        future: getMapShortInfo(Config.defaultStartDate, Config.defaultEndDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Marker> markers = [];
          markers.addAll(snapshot.data!.sharks.map((shark) => _createMarker(shark, 'shark', ref)));
          markers.addAll(snapshot.data!.buoys.map((buoy) => _createMarker(buoy, 'buoy', ref)));

          Future.microtask(() {
            ref.read(mapMarkersProvider.notifier).state = markers;
          });

          return MapComponent(mapController: mapController);
        });
  }

  Marker _createMarker(ShortPositionInfo data, String type, WidgetRef ref) {
    void Function()? onTap;
    String imagePath;
    String semanticsLabel;

    if (type == 'shark') {
      onTap = () async => await _selectShark(data, ref);
      imagePath = 'assets/MarkerShark.svg';
      semanticsLabel = 'Shark Marker';
    } else if (type == 'buoy') {
      // onTap = () async => await _selectBuoy(data, ref);
      imagePath = 'assets/MarkerBuoy.svg';
      semanticsLabel = 'Buoy Marker';
    } else {
      onTap = () {};
      imagePath = 'assets/MarkerPoint.svg';
      semanticsLabel = 'Point Marker';
    }

    return Marker(
        width: 20.0, // Установите требуемый размер
        height: 20.0, // Установите требуемый размер
        point: LatLng(data.coordinates.latitude, data.coordinates.longitude),
        child: GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset(imagePath, semanticsLabel: semanticsLabel),
        ));
  }

  Future<void> _selectShark(ShortPositionInfo shark, WidgetRef ref) async {
    SharkMapInfo sharkInfo = await getSharkMapInfo(
        shark.id, Config.defaultStartDate, Config.defaultEndDate
    );

    ref.read(selectedBuoyProvider.notifier).state = null;
    ref.read(selectedSharkProvider.notifier).state = sharkInfo;
    ref.read(mapPolylineProvider.notifier).state = sharkInfo.getRoute();

    ref.read(mapCenterProvider.notifier).state = sharkInfo.tracksList.first.first.coordinates;
    ref.read(mapZoomProvider.notifier).state = 10;

    mapController.move(sharkInfo.tracksList.last.last.coordinates, 10);
  }


  Future<void> _selectBuoy(ShortPositionInfo buoy, WidgetRef ref) async {
    BuoyMapInfo buoyInfo = await getBuoyMapInfo(
        buoy.id, Config.defaultStartDate, Config.defaultEndDate
    );

    ref.read(selectedSharkProvider.notifier).state = null;
    ref.read(selectedBuoyProvider.notifier).state = buoyInfo;

    ref.read(mapCenterProvider.notifier).state = buoyInfo.location;
    ref.read(mapZoomProvider.notifier).state = 10;

  }

  Widget _buildInfoCard(BuildContext context, WidgetRef ref, Widget card) {
    double topPadding = MediaQuery.of(context).padding.top;
    double baseHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: topPadding + 60,
      left: 0,
      right: 0,
      child: Container(
        height: baseHeight * 0.2,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        child: card,
      ),
    );
  }
}



//
// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);
//
//   @override
//   MapPageState createState() => MapPageState();
// }
//
// class MapPageState extends State<MapPage> {
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> widgets = [
//       _buildMap(),
//       const SwitchMapButton(),
//       const Legend(),
//       const DatePicker(),
//     ];
//
//     if (_selectedShark != null) {
//       widgets.add(_buildResetSharkButton());
//       widgets.add(_buildSharkInfoCard());
//     }
//
//     if (_selectedBuoy != null) {
//       widgets.add(_buildResetSharkButton());
//       widgets.add(_buildBuoyInfoCard());
//     }
//
//     return Scaffold(
//       body: Stack(
//         children: widgets,
//       ),
//     );
//   }
//
//   Widget _buildResetSharkButton() {
//     return Positioned(
//       top: 20,
//       left: 5,
//       height: 40,
//       child: FloatingActionButton(
//         heroTag: 'resetShark',
//         backgroundColor: Colors.white,
//         child: const Icon(Icons.arrow_back_ios_sharp, color: Colors.blue),
//         onPressed: () {
//           setState(() {
//             _selectedShark = null;
//             _selectedBuoy = null;
//           });
//         },
//       ),
//     );
//   }
//
//   Widget _buildMap() {
//     return FutureBuilder<MapShortInfo>(
//       future: getMapShortInfo(Config.defaultStartDate, Config.defaultEndDate),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError || !snapshot.hasData) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         List<Marker> markers = _buildMarkerList(snapshot.data!);
//
//         return FlutterMap(
//           options: MapOptions(
//             initialCenter: lastCenter,
//             initialZoom:
//                 zoom, // interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: _useOpenStreetMap
//                   ? Config.simpleMapUrl
//                   : Config.realisticMapUrl,
//               subdomains: const ['a', 'b', 'c'],
//             ),
//             if (_selectedShark != null)
//               PolylineLayer(
//                 polylines: _selectedShark!.getRoute(),
//               ),
//             MarkerClusterLayerWidget(
//               options: MarkerClusterLayerOptions(
//                 maxClusterRadius: 120,
//                 size: const Size(40, 40),
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.all(50),
//                 markers: markers,
//                 builder: (context, markers) {
//                   return FloatingActionButton(
//                     onPressed: null,
//                     child: Text(markers.length.toString()),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   List<Marker> _buildMarkerList(MapShortInfo info) {
//     List<Marker> markers = [];
//     markers.addAll(info.sharks.map((shark) => _createMarker(shark, 'shark')));
//     markers.addAll(info.buoys.map((buoy) => _createMarker(buoy, 'buoy')));
//
//     return markers;
//   }
//
//   Marker _createMarker(ShortPositionInfo data, String type) {
//     void Function()? onTap;
//     String imagePath;
//     String semanticsLabel;
//
//     if (type == 'shark') {
//       onTap = () async => await _selectShark(data);
//       imagePath = 'assets/MarkerShark.svg';
//       semanticsLabel = 'Shark Marker';
//     } else if (type == 'buoy') {
//       onTap = () async => await _selectBuoy(data);
//       imagePath = 'assets/MarkerBuoy.svg';
//       semanticsLabel = 'Buoy Marker';
//     } else {
//       onTap = () {};
//       imagePath = 'assets/MarkerPoint.svg';
//       semanticsLabel = 'Point Marker';
//     }
//
//     return Marker(
//         width: 20.0, // Установите требуемый размер
//         height: 20.0, // Установите требуемый размер
//         point: LatLng(data.coordinates.latitude, data.coordinates.longitude),
//         child: GestureDetector(
//           onTap: onTap,
//           child: SvgPicture.asset(imagePath, semanticsLabel: semanticsLabel),
//         ));
//   }
//
//   Future<void> _selectShark(ShortPositionInfo shark) async {
//     SharkMapInfo sharkInfo = await getSharkMapInfo(
//         shark.id, Config.defaultStartDate, Config.defaultEndDate);
//
//     setState(() {
//       _selectedShark = sharkInfo;
//       _selectedBuoy = null;
//       lastCenter = shark.coordinates;
//       zoom = 10;
//     });
//   }
//
//   Future<void> _selectBuoy(ShortPositionInfo buoy) async {
//     BuoyMapInfo buoyInfo = await getBuoyMapInfo(
//         buoy.id, Config.defaultStartDate, Config.defaultEndDate);
//
//     setState(() {
//       _selectedBuoy = buoyInfo;
//       _selectedShark = null;
//       lastCenter = buoy.coordinates;
//       zoom = 10;
//     });
//   }
//
//   Widget _buildSharkInfoCard() {
//     double topPadding = MediaQuery.of(context).padding.top;
//     double baseHeight = MediaQuery.of(context).size.height;
//
//     return Positioned(
//       top: topPadding + 60,
//       left: 0,
//       right: 0,
//       child: Container(
//         height: baseHeight * 0.2,
//         margin: const EdgeInsets.all(2),
//         padding: const EdgeInsets.all(2),
//         child: SharkCard(shark: _selectedShark!),
//       ),
//     );
//   }
//
//   Widget _buildBuoyInfoCard() {
//     double topPadding = MediaQuery.of(context).padding.top;
//     double baseHeight = MediaQuery.of(context).size.height;
//
//     return Positioned(
//       top: topPadding + 60,
//       left: 0,
//       right: 0,
//       child: Container(
//         height: baseHeight * 0.2,
//         margin: const EdgeInsets.all(2),
//         padding: const EdgeInsets.all(2),
//         child: BuoyCard(buoy: _selectedBuoy!),
//       ),
//     );
//   }
// }
