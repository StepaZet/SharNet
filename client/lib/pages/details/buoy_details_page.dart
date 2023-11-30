import 'package:flutter/material.dart';
import '../../components/buoy_map.dart';
import '../../components/shark_card.dart';
import '../../models/buoy.dart';
import '../../models/config.dart';
import '../../models/shark.dart';

class BuoyDetailsPage extends StatefulWidget {
  final Buoy buoy;
  final List<Shark> sharks;

  BuoyDetailsPage({required this.buoy, required this.sharks});

  @override
  _BuoyDetailsPageState createState() => _BuoyDetailsPageState();
}

class _BuoyDetailsPageState extends State<BuoyDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Buoy"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(Config.defaultBuoyUrl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${widget.buoy.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Location: ${widget.buoy.latitude}, ${widget.buoy.longitude}'),
                  Text('Status: ${widget.buoy.status}'),
                  SizedBox(height: 8),
                  Divider(),
                  Text('Ping log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Pings: ${widget.buoy.pings}'),
                  Text('Active buoy days: ${widget.buoy.activeDays}'),
                  Text('Detected sharks: ${widget.buoy.detectedSharks}'),
                  Text('Detected tracks: ${widget.buoy.detectedTracks}'),
                  Text('Date of placement: ${widget.buoy.dateOfPlacement}'),
                  Text('Last ping: ${widget.buoy.lastPing}'),
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
                tabs: [
                  Tab(text: 'Location'),
                  Tab(text: 'Sharks'),
                ],
              ),
            ),
            SizedBox(
              height: 300, // Это примерная высота, которую можно изменить
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(), // Запрет на свайпы
                children: [
                  BuoyMap(
                    locationLongitude: widget.buoy.longitude,
                    locationLatitude: widget.buoy.latitude,
                  ), // Предполагаемый виджет детальной информации о буе
                  _buildSharkList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharkList() {
    return ListView.builder(
      itemCount: widget.sharks.length,
      itemBuilder: (context, index) {
        return SharkCard(shark: widget.sharks[index]);
      },
    );
  }
}
