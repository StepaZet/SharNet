import 'package:client/components/shark_card.dart';
import 'package:flutter/cupertino.dart';

import '../models/shark.dart';

class SharkList extends StatelessWidget {
  final List<SharkMapInfo> sharks;

  const SharkList({super.key, required this.sharks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sharks.length,
      itemBuilder: (context, index) {
        double baseHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: baseHeight * 0.2,
          child: SharkCard(shark: sharks[index]),
        );
      },
    );
  }
}