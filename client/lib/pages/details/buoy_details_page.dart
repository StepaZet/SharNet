import 'package:flutter/material.dart';

import '../../components/buoy_descriprion.dart';
import '../../components/map_marker.dart';
import '../../components/map_screen.dart';
import '../../components/shark_list.dart';
import '../../models/buoy.dart';

class BuoyDetails extends StatelessWidget {
  final BuoyFullInfo buoyFullInfo;

  const BuoyDetails({super.key, required this.buoyFullInfo});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: Text(buoyFullInfo.name,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(buoyFullInfo.photo),
            BuoyDescription(
                buoyFullInfo: buoyFullInfo, baseFontSize: baseFontSize),
            SizedBox(
              height: baseSizeHeight * 0.5,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
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
                    Expanded(
                      child: TabBarView(
                        children: [
                          MapScreen(markers: [
                            MapMarker().createBuoyMarker(
                                buoyFullInfo.location, null)
                          ]),
                          SharkList(sharks: buoyFullInfo.sharksList),
                        ],
                      ),
                    ),
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
