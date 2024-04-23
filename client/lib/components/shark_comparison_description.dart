import 'package:flutter/material.dart';

import '../models/shark.dart';
import 'info_line.dart';

class SharkComparisonDescription extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;

  const SharkComparisonDescription({super.key, required this.sharkFullInfo});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize =
        baseSizeHeight * 0.03; // Например, 5% от ширины экрана

    return Column(
      children: [
        InfoLine(
            label: 'Age', value: sharkFullInfo.age, baseFontSize: baseFontSize),
        SizedBox(height: baseFontSize * 0.2),
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
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        InfoLine(
            label: 'Average values:', value: "", baseFontSize: baseFontSize),
        SizedBox(height: baseFontSize * 0.6),
        InfoLine(
            label: 'Length',
            value: '${sharkFullInfo.averageLength.toStringAsFixed(2)} cm',
            baseFontSize: baseFontSize),
        SizedBox(height: baseFontSize * 0.2),
        InfoLine(
            label: 'Weight',
            value: '${sharkFullInfo.averageWeight.toStringAsFixed(2)} kg',
            baseFontSize: baseFontSize),
        SizedBox(height: baseFontSize * 0.2),
      ],
    );
  }
}
