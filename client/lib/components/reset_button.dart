import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/buoy.dart';
import '../models/shark.dart';

class ResetButton extends ConsumerWidget {
  final StateProvider<SharkMapInfo?> selectedSharkProvider;
  final StateProvider<BuoyMapInfo?> selectedBuoyProvider;
  final StateProvider<List<Polyline>> mapPolylineProvider;

  const ResetButton(
      {super.key,
      required this.selectedSharkProvider,
      required this.selectedBuoyProvider,
      required this.mapPolylineProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}
