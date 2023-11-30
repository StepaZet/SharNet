import 'package:client/mocks/sharks_list.dart';
import 'package:client/models/buoy.dart';
import 'package:flutter/material.dart';
import '../models/config.dart';
import '../models/shark.dart';
import '../pages/details/buoy_details_page.dart';

class BuoyCard extends StatelessWidget {
  final Buoy buoy;

  BuoyCard({super.key, required this.buoy});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Фон карточки
        borderRadius: BorderRadius.circular(16), // Скругленные углы
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Цвет тени
            blurRadius: 10, // Радиус размытия тени
            offset: Offset(0, 2), // Смещение тени по X и Y
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Скругленные углы
        ),
        child: ListTile(
          leading: Image.network(Config.defaultBuoyUrl, fit: BoxFit.cover),
          title: Text(buoy.name),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0), // Добавьте отступ для разделения текста, если нужно
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pings: ${buoy.pings}'),
                Text('Detected sharks: ${buoy.detectedSharks}'),
                Text('Detected tracks: ${buoy.detectedTracks}'),
              ],
            ),
          ),
          onTap: () {
            List<Shark> sharks = getSharks();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuoyDetailsPage(buoy: buoy, sharks: sharks)),
            );
          },
        ),
      ),
    );
  }
}
