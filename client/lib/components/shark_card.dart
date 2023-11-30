import 'package:client/models/config.dart';
import 'package:flutter/material.dart';

import '../models/shark.dart';
import '../pages/details/shark_details_page.dart';

class SharkCard extends StatelessWidget {
  final Shark shark;

  const SharkCard({Key? key, required this.shark}) : super(key: key);

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
          borderRadius: BorderRadius.circular(16), // Согласование с фоном
        ),
        child: ListTile(
          leading: Image.network(Config.defaultSharkUrl, fit: BoxFit.cover),
          title: Text(shark.name),
          subtitle: Text('Длина: ${shark.length} см\nВес: ${shark.weight} кг'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SharkPage(shark: shark)),
            );
          },
        ),
      ),
    );
  }
}
