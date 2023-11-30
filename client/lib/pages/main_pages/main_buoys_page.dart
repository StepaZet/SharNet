import 'package:flutter/material.dart';

import '../../models/buoy.dart';
import '../../components/buoy_card.dart';

class BuoysPage extends StatelessWidget {
  const BuoysPage({super.key});

  @override
  Widget build(BuildContext context) {

    List<Buoy> buoys = [
      Buoy(name: 'New Buoy', pings: 37, detectedSharks: 3, detectedTracks: 7, id: '1', status: 'Active', latitude: 37.4219983, longitude: -122.084),
      Buoy(name: 'New Buoy', pings: 37, detectedSharks: 0, detectedTracks: 0, id: '2', status: 'Active', latitude: 25.761681, longitude: -80.191788),
      Buoy(name: 'New Buoy', pings: 37, detectedSharks: 1, detectedTracks: 1, id: '3', status: 'Active', latitude: 19.8967662, longitude: -155.5827818),
      // Добавьте другие буйки здесь
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bouys'),
      ),
      body: ListView.builder(
        itemCount: buoys.length,
        itemBuilder: (context, index) {
          return BuoyCard(buoy: buoys[index]);
        },
      )
    );

  }
}