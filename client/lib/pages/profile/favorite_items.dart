import 'package:client/api/profile.dart';
import 'package:client/components/buoy_list.dart';
import 'package:client/components/shark_list.dart';
import 'package:client/models/buoy.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/models/shark.dart';
import 'package:flutter/material.dart';

// class FavoriteItemsData {
//   final List<SharkMapInfo> sharks;
//   final List<BuoyMapInfo> buoys;
//
//   FavoriteItemsData({required this.sharks, required this.buoys});
// }

class FavoriteItems extends StatelessWidget {
  // final List<SharkMapInfo> sharks;
  // final List<BuoyMapInfo> buoys;

  const FavoriteItems({super.key});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(fontFamily: 'Inter', fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image.network(buoyFullInfo.photo),
            // BuoyDescription(
            //     buoyFullInfo: buoyFullInfo, baseFontSize: baseFontSize),
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
                        Tab(text: 'Sharks'),
                        Tab(text: 'Bouys'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FutureBuilder<PossibleErrorResult<SharkSearchInfo>>(
                            future: getFavoriteSharks(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError || !snapshot.hasData) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.data!.resultStatus !=
                                  ResultEnum.ok) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'An error occurred while loading the sharks. Please try again later.'),
                                ));
                                return const SharkList(sharks: []);
                              }

                              var sharks = snapshot.data!.resultData!.sharks;

                              return SharkList(sharks: sharks);
                            },
                          ),
                          FutureBuilder<PossibleErrorResult<BuoySearchInfo>>(
                            future: getFavoriteBuoys(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError || !snapshot.hasData) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.data!.resultStatus !=
                                  ResultEnum.ok) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'An error occurred while loading the buoys. Please try again later.'),
                                ));
                                return const BuoyList(buoys: []);
                              }

                              var buoys = snapshot.data!.resultData!.buoys;

                              return BuoyList(buoys: buoys);
                            },
                          ),
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
