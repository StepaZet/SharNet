import 'package:flutter/material.dart';

import '../../components/shark_track_map.dart';
import '../../models/shark.dart';
import '../../models/config.dart';

class SharkPage extends StatelessWidget {
  final Shark shark;

  SharkPage({required this.shark});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shark Page'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildSharkDetails(shark),
              buildTabBar(),
              buildTabBarView(shark),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSharkDetails(Shark shark) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  shark.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Container(
                  height: 200,
                  child: Container(
                    height: 200, // Высота для изображения
                    child: PageView(
                      children: <Widget>[
                        Image.network(Config.defaultSharkUrl),
                        Image.network(Config.defaultSharkUrl),
                        Image.network(Config.defaultSharkUrl),
                        // Добавьте больше изображений если нужно
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 20, thickness: 2),
              sharkAttribute('ID', shark.id),
              sharkAttribute('Length', '${shark.length} cm'),
              sharkAttribute('Weight', '${shark.weight} kg'),
              sharkAttribute('Sex', shark.sex),
              sharkAttribute('Age', '${shark.age} years'),
              sharkAttribute('Tracks', '${shark.tracks.length}'),
              SizedBox(height: 16),
              Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'bla bla bla (description))',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return TabBar(
      isScrollable: true,
      tabs: [
        Tab(text: "Pings"),
        Tab(text: "Buoys"),
        Tab(text: "Comparison"),
        Tab(text: "Top"),
      ],
      indicatorColor: Colors.blue,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
    );
  }

  Widget buildTabBarView(Shark shark) {
    return Container(
      height: 300, // Примерная высота для контейнера TabBarView
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // Запрет на свайпы
        children: [
          SharkTrackMap(tracks: shark.tracks),
          Center(child: Text('Buoys Content')),
          Center(child: Text('Comparison Content')),
          Center(child: Text('Top Content')),
        ],
      ),
    );
  }

  Widget sharkAttribute(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
