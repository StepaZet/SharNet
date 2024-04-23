import 'package:client/models/buoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../api/map.dart';
import '../../components/buoy_card.dart';
import '../../components/date_picker.dart';
import '../../components/map.dart';
import '../../components/map_marker.dart';
import '../../components/map_screen.dart';
import '../../components/reset_button.dart';
import '../../components/shark_card.dart';
import '../../models/config.dart';
import '../../models/positions.dart';
import '../../models/shark.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedSharkProvider = StateProvider<SharkMapInfo?>((ref) => null);
final selectedBuoyProvider = StateProvider<BuoyMapInfo?>((ref) => null);

final mapMarkersProvider = StateProvider<List<Marker>>((ref) => []);
final mapPolylineProvider = StateProvider<List<Polyline>>((ref) => []);

class MainMapPage extends ConsumerStatefulWidget {
  const MainMapPage({super.key});

  @override
  _MainMapPageState createState() => _MainMapPageState();
}

class _MainMapPageState extends ConsumerState<MainMapPage>
    with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  final MapController mapController = MapController();

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<Marker>>(
              future: updateMap(ref, needUpdate: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var markers = snapshot.data!;

                return MapScreen(
                  mapController: mapController,
                  mapMarkersProvider: mapMarkersProvider,
                  mapPolylineProvider: mapPolylineProvider,
                  datePickersSubscribers: [updateMap],
                  markers: markers,
                );
              }),
          Consumer(builder: (context, ref, child) {
            final selectedShark = ref.watch(selectedSharkProvider);
            if (selectedShark != null) {
              return _buildInfoCard(
                  context, ref, SharkCard(shark: selectedShark));
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
              return ResetButton(
                  selectedSharkProvider: selectedSharkProvider,
                  selectedBuoyProvider: selectedBuoyProvider,
                  mapPolylineProvider: mapPolylineProvider);
            }

            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Future<List<Marker>> updateMap(WidgetRef ref,
      {bool needUpdate = true}) async {
    var mapMarker = MapMarker();

    final startDate = ref.read(startDateProvider);
    final endDate = ref.read(endDateProvider);

    var info = await getMapShortInfo(startDate, endDate);

    List<Marker> markers = [
      ...info.sharks.map((shark) => mapMarker.createSharkMarker(
          shark.coordinates, () => _selectShark(shark, ref))),
      ...info.buoys.map((buoy) => mapMarker.createBuoyMarker(
          buoy.coordinates, () => _selectBuoy(buoy, ref))),
    ];

    if (needUpdate) {
      ref.read(mapMarkersProvider.notifier).state = markers;
    }

    return markers;
  }

  Future<void> _selectShark(ShortPositionInfo shark, WidgetRef ref) async {
    SharkMapInfo sharkInfo = await getSharkMapInfo(
        shark.id, Config.defaultStartDate, Config.defaultEndDate);

    ref.read(selectedBuoyProvider.notifier).state = null;
    ref.read(selectedSharkProvider.notifier).state = sharkInfo;
    ref.read(mapPolylineProvider.notifier).state = sharkInfo.getRoute();

    ref.read(mapZoomProvider.notifier).state = 10;
    ref.read(mapCenterProvider.notifier).state =
        sharkInfo.tracksList.last.last.coordinates;
    _animatedMapMove(sharkInfo.tracksList.last.last.coordinates, 10);
  }

  Future<void> _selectBuoy(ShortPositionInfo buoy, WidgetRef ref) async {
    BuoyMapInfo buoyInfo = await getBuoyMapInfo(
        buoy.id, Config.defaultStartDate, Config.defaultEndDate);

    ref.read(selectedSharkProvider.notifier).state = null;
    ref.read(selectedBuoyProvider.notifier).state = buoyInfo;

    ref.read(mapZoomProvider.notifier).state = 10;
    ref.read(mapCenterProvider.notifier).state = buoyInfo.location;

    _animatedMapMove(buoyInfo.location, 10);
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
