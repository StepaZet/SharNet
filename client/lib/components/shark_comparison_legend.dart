import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:client/models/shark.dart';

class SharkComparisonLegend extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;

  const SharkComparisonLegend({super.key, required this.sharkFullInfo});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    final legendItems = [
      LegendItem(
        color: Colors.blue,
        name: sharkFullInfo.averageLength > sharkFullInfo.length
            ? 'Average values'
            : sharkFullInfo.name,
      ),
      LegendItem(
        color: Colors.white,
        name: sharkFullInfo.averageLength > sharkFullInfo.length
            ? sharkFullInfo.name
            : 'Average values',
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legendItems
          .map((item) => _buildLegendItem(item, baseFontSize))
          .toList(),
    );
  }

  Widget _buildLegendItem(LegendItem item, double baseFontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(item.color == Colors.blue
            ? 'assets/RectangleBlue.svg'
            : 'assets/RectangleWhite.svg'),
        const SizedBox(width: 8),
        Text(item.name,
            style:
                TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
        // Use a fixed font size
      ],
    );
  }
}

class LegendItem {
  final Color color;
  final String name;

  const LegendItem({required this.color, required this.name});
}
