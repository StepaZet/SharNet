import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/config.dart';

class BuoyMap extends StatefulWidget {
  final double locationLongitude;
  final double locationLatitude;

  const BuoyMap({
    super.key,
    required this.locationLongitude,
    required this.locationLatitude,
  });

  @override
  BuoyMapState createState() => BuoyMapState();
}

class BuoyMapState extends State<BuoyMap> {
  bool _useOpenStreetMap = true;

  DateTime _startDate = Config.defaultStartDate;
  DateTime _endDate = Config.defaultEndDate;

  void _onDateSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // Здесь вы можете обработать изменение выбранного диапазона дат
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value;
      _startDate = range.startDate!;
      _endDate = range.endDate!;
    }
  }

  bool _isDatesEqual(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _customDatePickerCellBuilder(
      BuildContext context, DateRangePickerCellDetails cellDetails) {
    final bool isStartEdge = _isDatesEqual(cellDetails.date, _startDate);
    final bool isEndEdge = _isDatesEqual(cellDetails.date, _endDate);
    final bool isInRange = cellDetails.date.isAfter(_startDate) &&
        cellDetails.date.isBefore(_endDate);

    BoxDecoration decoration;

    if (_isDatesEqual(cellDetails.date, DateTime.now())) {
      // Today's decoration
      decoration = BoxDecoration(
          color: Colors.blue.withOpacity(0.75), shape: BoxShape.rectangle);
    } else if (isStartEdge || isEndEdge) {
      // Start/End edges decoration
      decoration =
          const BoxDecoration(color: Colors.blue, shape: BoxShape.rectangle);
    } else if (isInRange) {
      // In-range decoration
      decoration = BoxDecoration(
          color: Colors.blue.withOpacity(0.5), shape: BoxShape.rectangle);
    } else {
      // Default decoration
      decoration = const BoxDecoration(shape: BoxShape.rectangle);
    }

    return Container(
      decoration: decoration,
      child: Center(
        child: Text(
          cellDetails.date.day.toString(),
          style: TextStyle(color: isInRange ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseSizeHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select date range'),
          content: SizedBox(
            height: baseSizeHeight * 0.5, // Установите желаемую высоту диалога
            width: baseSizeWidth * 0.8, // Установите желаемую ширину диалога
            child: SfDateRangePicker(
              onSelectionChanged: _onDateSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.extendableRange,
              initialSelectedRange: PickerDateRange(
                _startDate,
                _endDate,
              ),
              cellBuilder: _customDatePickerCellBuilder,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Config.defaultStartDate = _startDate;
                Config.defaultEndDate = _endDate;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(widget.locationLatitude, widget.locationLongitude),
            zoom: 3.2,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: _useOpenStreetMap
                  ? Config.simpleMapUrl
                  : Config.realisticMapUrl,
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 20.0,
                  height: 20.0,
                  point:
                      LatLng(widget.locationLatitude, widget.locationLongitude),
                  builder: (ctx) => GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('MarkerBuoy.svg',
                        semanticsLabel: 'Buoy Marker'),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 20.0,
          right: 10.0,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'switchMap',
            backgroundColor: Colors.white,
            child: Icon(_useOpenStreetMap ? Icons.satellite : Icons.map,
                color: Colors.blue),
            onPressed: () {
              setState(() {
                _useOpenStreetMap = !_useOpenStreetMap;
              });
            },
          ),
        ),
        Positioned(
          top: 20,
          right: 10,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'datePicker',
            backgroundColor: Colors.white,
            child: const Icon(Icons.date_range, color: Colors.blue),
            onPressed: () {
              _showDateRangePicker(context);
            },
          ),
        )
      ],
    );
  }
}
