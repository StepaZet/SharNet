import 'dart:math';

import 'package:client/components/shark_comparison_description.dart';
import 'package:client/components/shark_comparison_diagram.dart';
import 'package:client/components/shark_comparison_legend.dart';
import 'package:client/models/shark.dart';
import 'package:flutter/material.dart';


class SharkComparison extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;

  const SharkComparison({super.key, required this.sharkFullInfo});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize =
        baseSizeHeight * 0.03;

    double sharkLength = sharkFullInfo.length;
    double averageLength = sharkFullInfo.averageLength;
    double scale = min(sharkLength, averageLength) /
        max(sharkLength, averageLength); // Масштаб для белой акулы

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SharkComparisonDescription(sharkFullInfo: sharkFullInfo),
            SharkComparisonDiagram(scale: scale),
            SizedBox(height: baseFontSize * 0.2),
            SharkComparisonLegend(sharkFullInfo: sharkFullInfo),
          ],
        ),
      ),
    );
  }
}
