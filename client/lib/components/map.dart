import 'package:client/components/switch_map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:client/models/config.dart';

final mapCenterProvider =
    StateProvider<LatLng>((ref) => const LatLng(37.4219999, -122.0862462));
final mapZoomProvider = StateProvider<double>((ref) => 3.2);

class MapComponent extends ConsumerStatefulWidget {
  final MapController? mapController;
  final StateProvider? _mapMarkersProvider;
  final StateProvider? _mapPolylineProvider;

  const MapComponent(
      {super.key,
      this.mapController,
      StateProvider<dynamic>? mapMarkersProvider,
      StateProvider<dynamic>? mapPolylineProvider})
      : _mapPolylineProvider = mapPolylineProvider,
        _mapMarkersProvider = mapMarkersProvider;

  @override
  ConsumerState<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends ConsumerState<MapComponent> {
  @override
  Widget build(BuildContext contextf) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: ref.read(mapCenterProvider),
        initialZoom: ref.read(mapZoomProvider),
      ),
      children: [
        Consumer(builder: (context, ref, child) {
          final openStreetMap = ref.watch(useOpenStreetMapProvider);
          return TileLayer(
            urlTemplate:
                openStreetMap ? Config.simpleMapUrl : Config.realisticMapUrl,
            subdomains: const ['a', 'b', 'c'],
          );
        }),
        Consumer(builder: (context, ref, child) {
          if (widget._mapPolylineProvider == null) {
            return const SizedBox();
          }

          final polyline = ref.watch(widget._mapPolylineProvider!);
          return PolylineLayer(
            polylines: polyline,
          );
        }),
        Consumer(builder: (context, ref, child) {
          if (widget._mapMarkersProvider == null) {
            return const SizedBox();
          }

          final markers = ref.watch(widget._mapMarkersProvider!);
          return MarkerLayer(
            markers: markers,
          );
        }),
        Consumer(builder: (context, ref, child) {
          if (widget._mapMarkersProvider == null) {
            return const SizedBox();
          }

          final markers = ref.watch(widget._mapMarkersProvider!);
          return MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 120,
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              markers: markers,
              builder: (context, markers) {
                return FloatingActionButton(
                  onPressed: null,
                  child: Text(markers.length.toString()),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
