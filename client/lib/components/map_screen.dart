import 'package:client/components/switch_map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'date_picker.dart';
import 'legend.dart';
import 'map.dart';

class MapScreen extends ConsumerWidget {
  final List<Future<void> Function(WidgetRef)> datePickersSubscribers;

  final MapController? mapController;
  final StateProvider<List<Marker>>? mapMarkersProvider;
  final StateProvider<List<Polyline>>? mapPolylineProvider;
  final List<Marker> markers;
  final List<Polyline> polyline;

  const MapScreen(
      {super.key,
      this.datePickersSubscribers = const [],
      this.mapController,
      this.mapMarkersProvider,
      this.mapPolylineProvider,
      this.markers = const [],
      this.polyline = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mapMarkersProvider =
        this.mapMarkersProvider ?? StateProvider((ref) => markers);
    var mapPolylineProvider =
        this.mapPolylineProvider ?? StateProvider((ref) => polyline);

    Future.microtask(() {
      ref.read(mapMarkersProvider.notifier).state = markers;
      ref.read(mapPolylineProvider.notifier).state = polyline;
    });

    return Scaffold(
      body: Stack(children: [
        MapComponent(
          mapController: mapController,
          mapMarkersProvider: mapMarkersProvider,
          mapPolylineProvider: mapPolylineProvider,
        ),
        const SwitchMapButton(),
        const Legend(),
        DatePicker(subscribers: datePickersSubscribers),
      ]),
    );
  }
}
