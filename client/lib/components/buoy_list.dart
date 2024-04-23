import 'package:client/components/buoy_card.dart';
import 'package:flutter/cupertino.dart';

import '../models/buoy.dart';

class BuoyList extends StatelessWidget {
  final List<BuoyMapInfo> buoys;

  const BuoyList({super.key, required this.buoys});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: buoys.length,
      itemBuilder: (context, index) {
        double baseHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: baseHeight * 0.2,
          child: BuoyCard(buoy: buoys[index]),
        );
      },
    );
  }
}
