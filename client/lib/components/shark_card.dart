import 'package:flutter/material.dart';

import '../api/sharks.dart';
import '../models/shark.dart';
import '../pages/details/shark_details_page.dart';

class SharkCard extends StatelessWidget {
  final SharkMapInfo shark;

  const SharkCard({Key? key, required this.shark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseHeight * 0.025; // Например, 5% от ширины экрана


    return Card(
      clipBehavior: Clip.antiAlias, // Обрезка содержимого по границе карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Скругленные углы
      ),
      child: InkWell(
        onTap: () async {
          SharkFullInfo sharkFullInfo = await getSharkFullInfo(shark.id);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SharkPage(shark: shark, sharkFullInfo: sharkFullInfo)),
          );
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                shark.photo,
                fit: BoxFit.cover, // Изображение будет заполнять всю высоту карточки
                height: baseHeight * 0.3,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(shark.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize * 0.8)),
                    SizedBox(height: baseFontSize * 0.1), // Расстояние между элементами
                    InfoLine(label: 'Length', value: '${shark.length} cm', baseFontSize: baseFontSize),
                    InfoLine(label: 'Weight', value: '${shark.weight} kg', baseFontSize: baseFontSize),
                    InfoLine(label: 'Sex', value: shark.sex, baseFontSize: baseFontSize),
                    InfoLine(label: 'Tracks', value: '${shark.tracks}', baseFontSize: baseFontSize),
                    InfoLine(label: 'Last tagged', value: shark.lastTagged, baseFontSize: baseFontSize),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final double baseFontSize;

  const InfoLine({Key? key, required this.label, required this.value, required this.baseFontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text('$label\t', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
        Text(value, style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
      ],
    );
  }
}
