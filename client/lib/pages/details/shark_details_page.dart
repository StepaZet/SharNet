// import 'package:flutter/material.dart';
//
// import '../../components/shark_track_map.dart';
// import '../../models/shark.dart';
//
// class SharkPage extends StatelessWidget {
//   final SharkMapInfo shark;
//   final SharkFullInfo sharkFullInfo;
//
//   SharkPage({super.key, required this.shark, required this.sharkFullInfo});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(sharkFullInfo.name),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               buildSharkDetails(shark, sharkFullInfo),
//               buildTabBar(),
//               buildTabBarView(shark),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildSharkDetails(SharkMapInfo shark, SharkFullInfo sharkFullInfo) {
//
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Center(
//                 child: Container(
//                   height: 200, // Высота контейнера для изображения
//                   child: Image.memory(sharkFullInfo.photo), // Отображение одного изображения
//                 ),
//               ),
//
//               const Divider(height: 20, thickness: 2),
//               sharkAttribute('ID', sharkFullInfo.id),
//               sharkAttribute('Length', '${sharkFullInfo.length} cm'),
//               sharkAttribute('Weight', '${sharkFullInfo.weight} kg'),
//               sharkAttribute('Sex', sharkFullInfo.sex),
//               sharkAttribute('Age', '${sharkFullInfo.age} years'),
//               sharkAttribute('Tracks', '${sharkFullInfo.tracks}'),
//               const SizedBox(height: 16),
//               const Text(
//                 'About',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 sharkFullInfo.description,
//                 textAlign: TextAlign.justify,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildTabBar() {
//     return const TabBar(
//       isScrollable: true,
//       tabs: [
//         Tab(text: "Pings"),
//         Tab(text: "Buoys"),
//         Tab(text: "Comparison"),
//         Tab(text: "Top"),
//       ],
//       indicatorColor: Colors.blue,
//       labelColor: Colors.black,
//       unselectedLabelColor: Colors.grey,
//     );
//   }
//
//   Widget buildTabBarView(SharkMapInfo shark) {
//     return Container(
//       height: 300, // Примерная высота для контейнера TabBarView
//       child: TabBarView(
//         physics: const NeverScrollableScrollPhysics(), // Запрет на свайпы
//         children: [
//           SharkTrackMap(tracks: shark.tracksList),
//           const Center(child: Text('Buoys Content')),
//           const Center(child: Text('Comparison Content')),
//           const Center(child: Text('Top Content')),
//         ],
//       ),
//     );
//   }
//
//   Widget sharkAttribute(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }


// -------------


import 'package:flutter/material.dart';
import '../../components/buoy_card.dart';
import '../../components/shark_track_map.dart';
import '../../models/shark.dart';

class SharkPage extends StatefulWidget {
  final SharkMapInfo shark;
  final SharkFullInfo sharkFullInfo;

  const SharkPage({super.key, required this.shark, required this.sharkFullInfo});


  @override
  SharkPageState createState() => SharkPageState();
}

class SharkPageState extends State<SharkPage> with SingleTickerProviderStateMixin {
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
        title: Text(widget.sharkFullInfo.name),
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
                  //               const Divider(height: 20, thickness: 2),
//               sharkAttribute('ID', sharkFullInfo.id),
//               sharkAttribute('Length', '${sharkFullInfo.length} cm'),
//               sharkAttribute('Weight', '${sharkFullInfo.weight} kg'),
//               sharkAttribute('Sex', sharkFullInfo.sex),
//               sharkAttribute('Age', '${sharkFullInfo.age} years'),
//               sharkAttribute('Tracks', '${sharkFullInfo.tracks}'),
//               const SizedBox(height: 16),
//               const Text(
//                 'About',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 sharkFullInfo.description,
//                 textAlign: TextAlign.justify,
//               ),
                  InfoLine(label: 'ID', value: widget.sharkFullInfo.id, baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Length', value: '${widget.sharkFullInfo.length} cm', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Weight', value: '${widget.sharkFullInfo.weight} kg', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Sex', value: widget.sharkFullInfo.sex, baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Age', value: '${widget.sharkFullInfo.age} years', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Tracks', value: '${widget.sharkFullInfo.tracks}', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  InfoLine(label: 'Passed miles', value: '${widget.sharkFullInfo.passedMiles}', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Deployment length', value: '${widget.sharkFullInfo.deploymentLength} days', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'First tagged', value: '${widget.sharkFullInfo.firstTagged} days', baseFontSize: baseFontSize),
                  SizedBox(height: baseFontSize * 0.2),
                  InfoLine(label: 'Last tagged', value: '${widget.sharkFullInfo.lastTagged} days', baseFontSize: baseFontSize),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    widget.sharkFullInfo.description,
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
                  Tab(text: 'Pings'),
                  Tab(text: 'Buoys'),
                ],
              ),
            ),
            SizedBox(
              height: baseSizeWidth,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(), // Запрет на свайпы
                children: [
                  SharkTrackMap(tracks: widget.shark.tracksList),
                  _buildBuoyList(),
                ],
              ),
            ),
          ],
        ),
      ),
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