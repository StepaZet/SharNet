import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SharkComparisonDiagram extends StatelessWidget {
  final double scale;

  const SharkComparisonDiagram({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseSizeWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: baseSizeHeight * 0.2,
      width: baseSizeWidth,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.blue, // Задний фон цветом
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              // начало градиента сверху
              end: Alignment.topCenter,
              colors: [
                Colors.blue.shade200,
                Colors.grey.shade50
              ]), // Градиентный фон
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          // Выравниваем элементы стека слева
          children: [
            Positioned(
              left: baseSizeWidth / 5.5,
              // Начальная позиция белой акулы
              child: SvgPicture.asset('assets/SharkBlue.svg'),
            ),
            Positioned(
              left: baseSizeWidth / 5.5,
              // Начальная позиция белой акулы
              child: Transform.scale(
                scale: scale,
                // Масштабируем белую акулу
                alignment: Alignment.bottomLeft,
                // Точка масштабирования - центр левой стороны
                child: Opacity(
                  opacity: 0.8,
                  child: SvgPicture.asset('assets/SharkWhite.svg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
