import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20.0,
        left: 10.0,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgPicture.asset('assets/MarkerShark.svg'),
                  const SizedBox(width: 8),
                  const Text('Shark'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  SvgPicture.asset('assets/MarkerBuoy.svg'),
                  const SizedBox(width: 8),
                  const Text('Buoy'),
                ],
              ),
            ],
          ),
        ));
  }
}
