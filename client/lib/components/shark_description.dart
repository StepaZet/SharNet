import 'package:flutter/material.dart';

import '../models/shark.dart';
import 'info_line.dart';

class SharkDescription extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;
  final double baseFontSize;

  const SharkDescription(
      {super.key, required this.sharkFullInfo, required this.baseFontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLine(
              label: 'Length',
              value: '${sharkFullInfo.length} cm',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Weight',
              value: '${sharkFullInfo.weight} kg',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Sex', value: sharkFullInfo.sex, baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Age', value: sharkFullInfo.age, baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Tracks',
              value: '${sharkFullInfo.tracks}',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          InfoLine(
              label: 'Passed miles',
              value: sharkFullInfo.passedMiles.toStringAsFixed(2),
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Deployment length',
              value: sharkFullInfo.deploymentLength,
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'First tagged',
              value: sharkFullInfo.firstTagged,
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Last tagged',
              value: sharkFullInfo.lastTagged,
              baseFontSize: baseFontSize),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            sharkFullInfo.description,
            style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7),
          ),
        ],
      ),
    );
  }
}
