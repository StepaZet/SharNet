import 'package:flutter/material.dart';
import '../api/buoys.dart';
import '../models/buoy.dart';
import '../pages/details/buoy_details_page.dart';

class BuoyCard extends StatelessWidget {
  final BuoyMapInfo buoy;

  const BuoyCard({super.key, required this.buoy});

  @override
  Widget build(BuildContext context) {
    double baseHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseHeight * 0.025; // Например, 5% от ширины экрана

    return Card(
      clipBehavior: Clip.antiAlias, // Обрезка содержимого по границе карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Скругленные углы
      ),
      elevation: 2, // Небольшая тень для карточки
      child: InkWell(
        onTap: () async {
          BuoyFullInfo buoyFullInfo = await getBuoyFullInfo(buoy.id);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuoyDetails(buoyFullInfo: buoyFullInfo)),
          );
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                buoy.photo,
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
                    Text(buoy.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize * 0.8)),
                    SizedBox(height: baseFontSize * 0.1), // Расстояние между элементами
                    InfoLine(label: 'Location', value: '${buoy.location.latitude.toStringAsFixed(2)}, ${buoy.location.longitude.toStringAsFixed(2)}', baseFontSize: baseFontSize),
                    InfoLine(label: 'Pings', value: '${buoy.pings}', baseFontSize: baseFontSize),
                    InfoLine(label: 'Sharks', value: '${buoy.detectedSharks}', baseFontSize: baseFontSize),
                    InfoLine(label: 'Last ping', value: buoy.lastPing, baseFontSize: baseFontSize),
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
