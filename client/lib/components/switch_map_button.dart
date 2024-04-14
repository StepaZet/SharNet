import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider for managing selected map url
final useOpenStreetMapProvider = StateProvider<bool>((ref) => true);

class SwitchMapButton extends ConsumerWidget {
  const SwitchMapButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useOpenStreetMap = ref.watch(useOpenStreetMapProvider);

    return Positioned(
      bottom: 20.0,
      right: 10.0,
      height: 40,
      child: FloatingActionButton(
        heroTag: 'switchMap',
        backgroundColor: Colors.white,
        child: Icon(
          useOpenStreetMap ? Icons.map_outlined : Icons.satellite_outlined, // Use outlined icons for better contrast on white background
          color: Colors.blue,
        ),
        onPressed: () => ref.read(useOpenStreetMapProvider.notifier).state = !useOpenStreetMap,
      ),
    );
  }
}
