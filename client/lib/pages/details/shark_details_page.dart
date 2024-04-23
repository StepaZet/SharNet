import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/map.dart';
import '../../components/buoy_list.dart';
import '../../components/date_picker.dart';
import '../../components/map_marker.dart';
import '../../components/map_screen.dart';
import '../../components/shark_comparison.dart';
import '../../components/shark_description.dart';
import '../../components/shark_tables.dart';
import '../../models/shark.dart';

final detailMarkersProvider = StateProvider<List<Marker>>((ref) => []);
final detailPolylineProvider = StateProvider<List<Polyline>>((ref) => []);

class SharkPage extends StatelessWidget {
  final SharkMapInfo shark;
  final SharkFullInfo sharkFullInfo;

  const SharkPage({
    super.key,
    required this.shark,
    required this.sharkFullInfo,
  });

  Future<void> updateMap(WidgetRef ref, {bool needUpdate = true}) async {
    var mapMarker = MapMarker();

    final startDate = ref.read(startDateProvider);
    final endDate = ref.read(endDateProvider);

    var sharkInfo = await getSharkMapInfo(shark.id, startDate, endDate);

    List<Marker> markers = [];
    for (var track in sharkInfo.tracksList) {
      markers.addAll(
        track.map(
          (e) => mapMarker.createBuoyMarker(e.coordinates, null),
        ),
      );
    }

    List<Polyline> polyline = sharkInfo.getRoute();

    if (needUpdate) {
      ref.read(detailMarkersProvider.notifier).state = markers;
      ref.read(detailPolylineProvider.notifier).state = polyline;
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    var mapMarker = MapMarker();

    List<Marker> markers = [];
    for (var track in shark.tracksList) {
      markers.addAll(
        track.map(
          (e) => mapMarker.createBuoyMarker(e.coordinates, null),
        ),
      );
    }

    List<Polyline> polyline = shark.getRoute();

    return Scaffold(
      appBar: AppBar(
        title: Text(sharkFullInfo.name,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 25)),
        // center it
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(sharkFullInfo.photo),
            SharkDescription(
                sharkFullInfo: sharkFullInfo, baseFontSize: baseFontSize),
            SizedBox(
              height: baseSizeHeight * 0.5,
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      tabs: const [
                        Tab(text: 'Pings'),
                        Tab(text: 'Buoys'),
                        Tab(text: 'Compare'),
                        Tab(text: 'Top'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          MapScreen(
                            markers: markers,
                            polyline: polyline,
                            mapMarkersProvider: detailMarkersProvider,
                            mapPolylineProvider: detailPolylineProvider,
                            datePickersSubscribers: [updateMap],
                          ),
                          BuoyList(buoys: sharkFullInfo.buoysList),
                          SharkComparison(sharkFullInfo: sharkFullInfo),
                          SharkTables(sharkFullInfo: sharkFullInfo),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
