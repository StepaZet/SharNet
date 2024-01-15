import 'package:client/models/buoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../api/map.dart';
import '../../components/buoy_card.dart';
import '../../components/shark_card.dart';
import '../../models/config.dart';
import '../../models/positions.dart';
import '../../models/shark.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  bool _useOpenStreetMap = true;
  SharkMapInfo? _selectedShark;
  BuoyMapInfo? _selectedBuoy;
  LatLng lastCenter = LatLng(37.4219999, -122.0862462);
  double zoom = 3.2;

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
    List<Widget> widgets = [
      _buildMap(),
      _buildSwitchMapButton(),
      _buildLegend(),
      _buildDatePicker(context),
    ];

    if (_selectedShark != null) {
      widgets.add(_buildResetSharkButton());
      widgets.add(_buildSharkInfoCard());
    }

    if (_selectedBuoy != null) {
      widgets.add(_buildResetSharkButton());
      widgets.add(_buildBuoyInfoCard());
    }

    return Scaffold(
      body: Stack(
        children: widgets,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Positioned(
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
    );
  }

  Widget _buildResetSharkButton() {
    return Positioned(
      top: 20,
      left: 5,
      height: 40,
      child: FloatingActionButton(
        heroTag: 'resetShark',
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_back_ios_sharp, color: Colors.blue),
        onPressed: () {
          setState(() {
            _selectedShark = null;
            _selectedBuoy = null;
          });
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Positioned(
        bottom: 20.0,
        left: 10.0,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLegendItem('Shark', 'MarkerShark.svg'),
              // Замените на путь к вашему ресурсу иконки
              SizedBox(height: 8),
              _buildLegendItem('Buoy', 'MarkerBuoy.svg'),
              // Замените на путь к вашему ресурсу иконки
            ],
          ),
        )
    );
  }

  Widget _buildLegendItem(String title, String imagePath) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(imagePath),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }

  Widget _buildMap() {
    return FutureBuilder<MapShortInfo>(
      future: getMapShortInfo(Config.defaultStartDate, Config.defaultEndDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Marker> markers = _buildMarkerList(snapshot.data!);

        return FlutterMap(
          options: MapOptions(
            center: lastCenter,
            zoom: zoom,
            plugins: [MarkerClusterPlugin()],
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: _useOpenStreetMap
                  ? Config.simpleMapUrl
                  : Config.realisticMapUrl,
              subdomains: ['a', 'b', 'c'],
            ),
            if (_selectedShark != null)
              PolylineLayerOptions(
                polylines: getPolylines(_selectedShark!),
              ),
            MarkerClusterLayerOptions(
              maxClusterRadius: 120,
              size: const Size(40, 40),
              anchor: AnchorPos.align(AnchorAlign.center),
              fitBoundsOptions:
                  const FitBoundsOptions(padding: EdgeInsets.all(50)),
              markers: markers,
              builder: (context, markers) {
                return FloatingActionButton(
                  onPressed: null,
                  child: Text(markers.length.toString()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<Marker> _buildMarkerList(MapShortInfo info) {
    List<Marker> markers = [];
    markers.addAll(info.sharks.map((shark) => _createMarker(shark, 'shark')));
    markers.addAll(info.buoys.map((buoy) => _createMarker(buoy, 'buoy')));

    if (_selectedShark != null) {
      markers.addAll(getPoints(_selectedShark!)
          .map((point) => _createMarkerForPoint(point)));
    }

    return markers;
  }

  Marker _createMarkerForPoint(PointInfo point) {
    return Marker(
      width: 20.0,
      height: 20.0,
      point: point.coordinates,
      builder: (ctx) => GestureDetector(
        onTap: () {},
        child: SvgPicture.asset(
          'MarkerPoint.svg',
          semanticsLabel: 'Point Marker',
        ),
      ),
    );
  }

  Marker _createMarker(ShortPositionInfo data, String type) {
    void Function()? onTap;
    String imagePath;
    String semanticsLabel;

    if (type == 'shark') {
      onTap = () async => await _selectShark(data);
      imagePath = 'MarkerShark.svg';
      semanticsLabel = 'Shark Marker';
    } else if (type == 'buoy') {
      onTap = () async => await _selectBuoy(data);
      imagePath = 'MarkerBuoy.svg';
      semanticsLabel = 'Buoy Marker';
    } else {
      onTap = () {};
      imagePath = 'MarkerPoint.svg';
      semanticsLabel = 'Point Marker';
    }

    // SvgPicture.asset('MarkerPoint.svg', semanticsLabel: 'Point Marker')
    return Marker(
      width: 20.0, // Установите требуемый размер
      height: 20.0, // Установите требуемый размер
      point: LatLng(data.coordinates.latitude, data.coordinates.longitude),
      builder: (ctx) => GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(imagePath, semanticsLabel: semanticsLabel),
      ),
    );
  }

  Future<void> _selectShark(ShortPositionInfo shark) async {
    SharkMapInfo sharkInfo = await getSharkMapInfo(shark.id);

    setState(() {
      _selectedShark = sharkInfo;
      _selectedBuoy = null;
      lastCenter = shark.coordinates;
      zoom = 10;
    });
  }

  Future<void> _selectBuoy(ShortPositionInfo buoy) async {
    BuoyMapInfo buoyInfo = await getBuoyMapInfo(buoy.id);

    setState(() {
      _selectedBuoy = buoyInfo;
      _selectedShark = null;
      lastCenter = buoy.coordinates;
      zoom = 10;
    });
  }

  Widget _buildSharkInfoCard() {
    double topPadding = MediaQuery.of(context).padding.top;
    double baseHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: topPadding + 60,
      left: 0,
      right: 0,
      child: Container(
        height: baseHeight * 0.2,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        child: SharkCard(shark: _selectedShark!),
      ),
    );
  }

  Widget _buildBuoyInfoCard() {
    double topPadding = MediaQuery.of(context).padding.top;
    double baseHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: topPadding + 60,
      left: 0,
      right: 0,
      child: Container(
        height: baseHeight * 0.2,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        child: BuoyCard(buoy: _selectedBuoy!),
      ),
    );
  }

  Widget _buildSwitchMapButton() {
    return Positioned(
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
    );
  }

  List<Polyline> getPolylines(SharkMapInfo shark) {
    List<Polyline> polylines = [];
    for (var track in shark.tracksList) {
      List<LatLng> polylinePoints = [];
      for (var point in track) {
        // Добавляем точку в полилинию
        polylinePoints.add(
            LatLng(point.coordinates.latitude, point.coordinates.longitude));
      }
      // Добавляем полилинию в список
      polylines.add(Polyline(
        points: polylinePoints,
        color: Colors.blueAccent,
        strokeWidth: 2.0,
      ));
    }
    return polylines;
  }

  List<PointInfo> getPoints(SharkMapInfo shark) {
    List<PointInfo> points = [];
    for (var track in shark.tracksList) {
      for (var point in track.skip(1)) {
        points.add(point);
      }
    }
    return points;
  }
}
