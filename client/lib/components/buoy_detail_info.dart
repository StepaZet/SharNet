import 'package:flutter/material.dart';

import '../models/buoy.dart';
import '../models/config.dart';


class BuoyDetailInfo extends StatelessWidget {
  final Buoy buoy;

  BuoyDetailInfo({required this.buoy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(Config.defaultBuoyUrl), // URL или локальное изображение
          Text('ID: ${buoy.id}'),
          Text('Location: ${buoy.longitude}, ${buoy.latitude}'),
          Text('Status: ${buoy.status}'),
          // ... добавьте другую информацию по желанию
        ],
      ),
    );
  }
}
