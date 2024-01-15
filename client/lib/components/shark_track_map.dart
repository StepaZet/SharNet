// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:latlong2/latlong.dart';
//
// import '../models/config.dart';
// import '../models/positions.dart';
//
// class SharkTrackMap extends StatelessWidget {
//   final List<List<PointInfo>> tracks;
//   final bool _useOpenStreetMap = true;
//
//   const SharkTrackMap({super.key, required this.tracks});
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> widgets = [
//       _buildMap(),
//       _buildSwitchMapButton(),
//       _buildDatePicker(context),
//     ];
//
//     return Scaffold(
//       body: Stack(
//         children: widgets,
//       ),
//     );
//   }
//
//   Widget _buildSwitchMapButton() {
//     return Positioned(
//       bottom: 20.0,
//       right: 10.0,
//       height: 40,
//       child: FloatingActionButton(
//         heroTag: 'switchMap',
//         backgroundColor: Colors.white,
//         child: Icon(_useOpenStreetMap ? Icons.satellite : Icons.map,
//             color: Colors.blue),
//         onPressed: () {
//           setState(() {
//             _useOpenStreetMap = !_useOpenStreetMap;
//           });
//         },
//       ),
//     );
//   }
//
//   Widget _buildMap() {
//     List<Marker> markers = [];
//     List<Polyline> polylines = [];
//
//     for (var track in tracks) {
//       for (var point in track) {
//         markers.add(
//           Marker(
//             width: 20.0,
//             height: 20.0,
//             point: point.coordinates,
//             builder: (ctx) =>
//                 Container(
//                   child: SvgPicture.asset('MarkerPoint.svg', semanticsLabel: 'Point Marker'),
//                 ),
//           ),
//         );
//       }
//
//       var polylinePoints = track.map((e) => e.coordinates).toList();
//       polylines.add(
//         Polyline(
//           points: polylinePoints,
//           color: Colors.blueAccent,
//           strokeWidth: 2.0,
//         ),
//       );
//     }
//
//     return FlutterMap(
//       options: MapOptions(
//         center: tracks.isNotEmpty && tracks.first.isNotEmpty
//             ? tracks.first.first.coordinates
//             : LatLng(0, 0),
//         zoom: 5.0,
//       ),
//       layers: [
//         TileLayerOptions(
//           urlTemplate: Config.simpleMapUrl,
//           subdomains: ['a', 'b', 'c'],
//         ),
//         PolylineLayerOptions(
//           polylines: polylines,
//         ),
//         MarkerLayerOptions(
//           markers: markers,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/config.dart';
import '../models/positions.dart';

class SharkTrackMap extends StatefulWidget {
  final List<List<PointInfo>> tracks;

  const SharkTrackMap({super.key, required this.tracks});

  @override
  SharkTrackMapState createState() => SharkTrackMapState();
}

class SharkTrackMapState extends State<SharkTrackMap> {
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

  Widget _buildMap() {
    List<Marker> markers = [];
    List<Polyline> polylines = [];

    for (var track in widget.tracks) {
      for (var point in track) {
        markers.add(
          Marker(
            width: 20.0,
            height: 20.0,
            point: point.coordinates,
            builder: (ctx) => SvgPicture.asset('MarkerPoint.svg', semanticsLabel: 'Point Marker'),
          ),
        );
      }

      var polylinePoints = track.map((e) => e.coordinates).toList();
      polylines.add(
        Polyline(
          points: polylinePoints,
          color: Colors.blueAccent,
          strokeWidth: 2.0,
        ),
      );
    }

    return FlutterMap(
      options: MapOptions(
        center: widget.tracks.isNotEmpty && widget.tracks.first.isNotEmpty
            ? widget.tracks.first.first.coordinates
            : LatLng(0, 0),
        zoom: 5.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: _useOpenStreetMap
              ? Config.simpleMapUrl
              : Config.realisticMapUrl,
          subdomains: ['a', 'b', 'c'],
        ),
        PolylineLayerOptions(
          polylines: polylines,
        ),
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMap(),
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
