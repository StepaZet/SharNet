import 'package:flutter/material.dart';

import 'package:client/models/shark.dart';

Color getBlueColor(Set<MaterialState> states) {
  return Colors.blue.shade50;
}

Color getWhiteColor(Set<MaterialState> states) {
  return Colors.white;
}

class SharkDataTable extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;
  final List<List<String>> top;
  final String title; // New parameter for table title (weight/length)

  const SharkDataTable({
    super.key,
    required this.sharkFullInfo,
    required this.top,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseFontSize = baseSizeHeight * 0.03;

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
              label: Text(title, // Use title parameter here
                  style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: baseFontSize * 0.7,
                      color: Colors.white))),
        ],
        rows: List<DataRow>.generate(
          top.length, // Use appropriate list based on title
          (index) => DataRow(
            color: sharkFullInfo.name == top[index][1]
                ? MaterialStateProperty.resolveWith(getBlueColor)
                : MaterialStateProperty.resolveWith(getWhiteColor),
            cells: [
              DataCell(Text(top[index][0],
                  // Use appropriate list based on title
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7))),
              DataCell(Text(
                top[index][1],
                // Use appropriate list based on title
                style: TextStyle(
                    fontFamily: 'inter', fontSize: baseFontSize * 0.7),
              )),
              DataCell(Text(top[index][2],
                  // Use appropriate list based on title
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7))),
            ],
          ),
        ),
      ),
    );
  }
}

class SharkWeightTable extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;

  const SharkWeightTable({super.key, required this.sharkFullInfo});

  @override
  Widget build(BuildContext context) {
    return SharkDataTable(
      sharkFullInfo: sharkFullInfo,
      top: sharkFullInfo.topWeight,
      title: 'Weight',
    );
  }
}

class SharkLengthTable extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;

  const SharkLengthTable({super.key, required this.sharkFullInfo});

  @override
  Widget build(BuildContext context) {
    return SharkDataTable(
      sharkFullInfo: sharkFullInfo,
      top: sharkFullInfo.topLength,
      title: 'Length',
    );
  }
}

class SharkTables extends StatelessWidget {
  final SharkFullInfo sharkFullInfo;

  const SharkTables({super.key, required this.sharkFullInfo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SharkLengthTable(sharkFullInfo: sharkFullInfo),
          const SizedBox(height: 26),
          SharkWeightTable(sharkFullInfo: sharkFullInfo),
        ],
      ),
    );
  }
}
