import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/buoy_card.dart';
import '../../components/shark_track_map.dart';
import '../../models/shark.dart';

class SharkPage extends StatefulWidget {
  final SharkMapInfo shark;
  final SharkFullInfo sharkFullInfo;

  const SharkPage(
      {super.key, required this.shark, required this.sharkFullInfo});

  @override
  SharkPageState createState() => SharkPageState();
}

class SharkPageState extends State<SharkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize =
        baseSizeHeight * 0.03; // Например, 5% от ширины экрана

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sharkFullInfo.name, style: const TextStyle(fontFamily: 'Inter', fontSize: 25)),
        // center it
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.sharkFullInfo.photo),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//                   InfoLine(label: 'ID', value: widget.sharkFullInfo.id, baseFontSize: baseFontSize),
//                   SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Length',
                      value: '${widget.sharkFullInfo.length} cm',
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Weight',
                      value: '${widget.sharkFullInfo.weight} kg',
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Sex',
                      value: widget.sharkFullInfo.sex,
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Age',
                      value: widget.sharkFullInfo.age,
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Tracks',
                      value: '${widget.sharkFullInfo.tracks}',
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  InfoLine(
                      label: 'Passed miles',
                      value:
                          widget.sharkFullInfo.passedMiles.toStringAsFixed(2),
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Deployment length',
                      value: widget.sharkFullInfo.deploymentLength,
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'First tagged',
                      value: widget.sharkFullInfo.firstTagged,
                      baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(
                      label: 'Last tagged',
                      value: widget.sharkFullInfo.lastTagged,
                      baseFontSize: baseFontSize),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    widget.sharkFullInfo.description,
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                tabs: const [
                  Tab(text: 'Pings'),
                  Tab(text: 'Buoys'),
                  Tab(text: 'Compare'),
                  Tab(text: 'Top'),
                ],
              ),
            ),
            SizedBox(
              height: baseSizeWidth,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                // Запрет на свайпы
                children: [
                  SharkTrackMap(shark: widget.shark),
                  _buildBuoyList(),
                  _buildComparison(),
                  _buildTables(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparison() {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseFontSize =
        baseSizeHeight * 0.03; // Например, 5% от ширины экрана

    double sharkLength = widget.sharkFullInfo.length; // Длина вашей акулы
    double averageLength = widget.sharkFullInfo.averageLength; // Средняя длина
    double scale = min(sharkLength, averageLength) /
        max(sharkLength, averageLength); // Масштаб для белой акулы

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLine(
                label: 'Age',
                value: widget.sharkFullInfo.age,
                baseFontSize: baseFontSize),
            SizedBox(height: baseFontSize * 0.2),
            InfoLine(
                label: 'Length',
                value: '${widget.sharkFullInfo.length} cm',
                baseFontSize: baseFontSize),
            SizedBox(height: baseFontSize * 0.2),
            InfoLine(
                label: 'Weight',
                value: '${widget.sharkFullInfo.weight} kg',
                baseFontSize: baseFontSize),
            SizedBox(height: baseFontSize * 0.2),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            InfoLine(
                label: 'Average values for this age:',
                value: "",
                baseFontSize: baseFontSize),
            SizedBox(height: baseFontSize * 0.6),
            InfoLine(
                label: 'Length',
                value:
                    '${widget.sharkFullInfo.averageLength.toStringAsFixed(2)} cm',
                baseFontSize: baseFontSize),
            SizedBox(height: baseFontSize * 0.2),
            InfoLine(
                label: 'Weight',
                value:
                    '${widget.sharkFullInfo.averageWeight.toStringAsFixed(2)} kg',
                baseFontSize: baseFontSize),
            SizedBox(height: baseFontSize * 0.2),
            SizedBox(
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
                            // child: Image.asset(
                            //   'assets/white_shark.png', // Замените на ваш путь к белому изображению акулы
                            //   color: Colors.white.withOpacity(0.8), // Делаем изображение белым
                            //   colorBlendMode: BlendMode.modulate, // Применяем цвет
                            // ),
                          ),
                        ),
                      ],
                    ))),
            SizedBox(height: baseFontSize * 0.2),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    String blueName;
    String whiteName;

    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    if (widget.sharkFullInfo.averageLength > widget.sharkFullInfo.length) {
      blueName = 'Average values';
      whiteName = widget.sharkFullInfo.name;
    } else {
      blueName = widget.sharkFullInfo.name;
      whiteName = 'Average values';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/RectangleBlue.svg'),
            const SizedBox(width: 8), // Расстояние между иконкой и текстом
            Text(blueName, style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          ],
        ),
        const SizedBox(height: 8), // Расстояние между строками
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/RectangleWhite.svg'),
            const SizedBox(width: 8), // Расстояние между иконкой и текстом
            Text(whiteName, style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          ],
        ),
      ],
    );
  }

  Widget _buildBuoyList() {
    return ListView.builder(
      itemCount: widget.sharkFullInfo.buoysList.length,
      itemBuilder: (context, index) {
        double baseHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: baseHeight * 0.2,
          child: BuoyCard(buoy: widget.sharkFullInfo.buoysList[index]),
        );
      },
    );
  }

  Widget _buildTables() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLengthTable(),
          const SizedBox(height: 26), // Расстояние между таблицами
          _buildWeightTable(),
        ],
      ),
    );
  }

  Color getBlueColor(Set<MaterialState> states) {
    return Colors.blue.shade50;
  }

  Color getWhiteColor(Set<MaterialState> states) {
    return Colors.white;
  }

  Widget _buildLengthTable() {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseFontSize =
        baseSizeHeight * 0.03; // Например, 5% от ширины экрана

    return Card(
      child: DataTable(
        columnSpacing: baseSizeWidth / 8,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        columns: [
          DataColumn(
              label: Text('#',
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
          DataColumn(
              label: Text('Name',
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
          DataColumn(
              label: Text('Length',
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
        ],
        rows: List<DataRow>.generate(
          widget.sharkFullInfo.topLength.length,
          // Предполагается, что у вас есть список sharkInfo с информацией о акулах
          (index) => DataRow(
              color: widget.sharkFullInfo.name ==
                      widget.sharkFullInfo.topLength[index][1]
                  ? MaterialStateProperty.resolveWith(getBlueColor)
                  : MaterialStateProperty.resolveWith(getWhiteColor),
              cells: [
                DataCell(Text(widget.sharkFullInfo.topLength[index][0],
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7))),
                DataCell(Text(
                  widget.sharkFullInfo.topLength[index][1],
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7),
                )),
                DataCell(Text(widget.sharkFullInfo.topLength[index][2],
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7))),
              ]),
        ),
      ),
    );
  }

  Widget _buildWeightTable() {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseFontSize =
        baseSizeHeight * 0.03; // Например, 5% от ширины экрана

    return Card(
      child: DataTable(
        columnSpacing: baseSizeWidth / 8,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        columns: [
          DataColumn(
              label: Text('#',
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
          DataColumn(
              label: Text('Name',
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
          DataColumn(
              label: Text('Weight',
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
        ],
        rows: List<DataRow>.generate(
          widget.sharkFullInfo.topWeight.length,
          // Предполагается, что у вас есть список sharkInfo с информацией о акулах
          (index) => DataRow(
              color: widget.sharkFullInfo.name ==
                      widget.sharkFullInfo.topWeight[index][1]
                  ? MaterialStateProperty.resolveWith(getBlueColor)
                  : MaterialStateProperty.resolveWith(getWhiteColor),
              cells: [
                DataCell(Text(widget.sharkFullInfo.topWeight[index][0],
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7))),
                DataCell(Text(
                  widget.sharkFullInfo.topWeight[index][1],
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7),
                )),
                DataCell(Text(widget.sharkFullInfo.topWeight[index][2],
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7))),
              ]),
        ),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final double baseFontSize;

  const InfoLine(
      {Key? key,
      required this.label,
      required this.value,
      required this.baseFontSize})
      : super(key: key);

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
