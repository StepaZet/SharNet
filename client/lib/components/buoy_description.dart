import 'package:flutter/material.dart';

import 'package:client/models/buoy.dart';
import 'info_line.dart';

class BuoyDescription extends StatelessWidget {
  final BuoyFullInfo buoyFullInfo;
  final double baseFontSize;

  const BuoyDescription(
      {super.key, required this.buoyFullInfo, required this.baseFontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLine(
              label: 'Location',
              value: '${buoyFullInfo.location.latitude.toStringAsFixed(2)}, '
                  '${buoyFullInfo.location.longitude.toStringAsFixed(2)}',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Status',
              value: buoyFullInfo.status,
              baseFontSize: baseFontSize),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          InfoLine(
              label: 'Pings',
              value: '${buoyFullInfo.pings}',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Active buoy days',
              value: '${buoyFullInfo.activeBuoyDays}',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Detected sharks',
              value: '${buoyFullInfo.detectedSharks}',
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Date of placement',
              value: buoyFullInfo.dateOfPlacement,
              baseFontSize: baseFontSize),
          SizedBox(height: baseFontSize * 0.2),
          InfoLine(
              label: 'Last ping',
              value: buoyFullInfo.lastPing,
              baseFontSize: baseFontSize),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            buoyFullInfo.description,
            style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7),
          ),
        ],
      ),
    );
  }
}
