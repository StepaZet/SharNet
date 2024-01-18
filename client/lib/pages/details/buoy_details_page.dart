import 'package:flutter/material.dart';
import '../../components/buoy_map.dart';
import '../../components/shark_card.dart';
import '../../models/buoy.dart';
import '../../models/shark.dart';

class BuoyDetailsPage extends StatefulWidget {
  final BuoyMapInfo buoy;
  final List<SharkMapInfo> sharks;
  final BuoyFullInfo buoyFullInfo;

  const BuoyDetailsPage({super.key, required this.buoy, required this.sharks, required this.buoyFullInfo});

  @override
  BuoyDetailsPageState createState() => BuoyDetailsPageState();
}

class BuoyDetailsPageState extends State<BuoyDetailsPage> with SingleTickerProviderStateMixin {
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
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03; // Например, 5% от ширины экрана

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buoyFullInfo.name, style: const TextStyle(fontFamily: 'Inter', fontSize: 25)),
        // center it
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.buoyFullInfo.photo),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // InfoLine(label: 'ID', value: widget.buoyFullInfo.id, baseFontSize: baseFontSize),
                  // SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Location', value: '${widget.buoyFullInfo.location.latitude.toStringAsFixed(2)}, ${widget.buoyFullInfo.location.longitude.toStringAsFixed(2)}', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Status', value: widget.buoyFullInfo.status, baseFontSize: baseFontSize),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  InfoLine(label: 'Pings', value: '${widget.buoyFullInfo.pings}', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Active buoy days', value: '${widget.buoyFullInfo.activeBuoyDays}', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Detected sharks', value: '${widget.buoyFullInfo.detectedSharks}', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Date of placement', value: widget.buoyFullInfo.dateOfPlacement, baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Last ping', value: widget.buoyFullInfo.lastPing, baseFontSize: baseFontSize),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    widget.buoyFullInfo.description,
                    style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7),
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
                  Tab(text: 'Location'),
                  Tab(text: 'Sharks'),
                ],
              ),
            ),
            SizedBox(
              height: baseSizeWidth,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(), // Запрет на свайпы
                children: [
                  BuoyMap(
                    locationLongitude: widget.buoyFullInfo.location.longitude,
                    locationLatitude: widget.buoyFullInfo.location.latitude,
                  ),
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
        double baseHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: baseHeight * 0.2,
          child: SharkCard(shark: widget.sharks[index]),
        );
      },
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label\t', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
        Text(value, style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
      ],
    );
  }
}
