import 'package:flutter/cupertino.dart';

class InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final double baseFontSize;

  const InfoLine(
      {super.key,
        required this.label,
        required this.value,
        required this.baseFontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label\t',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'inter',
                fontSize: baseFontSize * 0.7)),
        Text(value,
            style:
            TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
      ],
    );
  }
}