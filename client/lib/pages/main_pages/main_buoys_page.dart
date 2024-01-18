import 'package:flutter/material.dart';
import '../../api/buoys.dart';
import '../../models/buoy.dart';
import '../../components/buoy_card.dart';

class BuoysPage extends StatefulWidget {
  const BuoysPage({Key? key}) : super(key: key);

  @override
  BuoysPageState createState() => BuoysPageState();
}

class BuoysPageState extends State<BuoysPage> {
  late Future<BuoySearchInfo> _buoyListFuture;

  @override
  void initState() {
    super.initState();
    _buoyListFuture = searchBuoy('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buoys', style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: BuoySearchDelegate(),
              );
              setState(() {
                _buoyListFuture = searchBuoy('');
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<BuoySearchInfo>(
        future: _buoyListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.buoys.isEmpty) {
            return const Center(child: Text('No buoys found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.buoys.length,
            itemBuilder: (context, index) {
              double baseHeight = MediaQuery.of(context).size.height;

              return SizedBox(
                height: baseHeight * 0.2,
                child: BuoyCard(buoy: snapshot.data!.buoys[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class BuoySearchDelegate extends SearchDelegate {
  @override
  Widget buildSuggestions(BuildContext context) {
    // Отображение подсказок поиска
    // if (query.isEmpty) {
    //   return const Center(child: Text('Enter a search term to begin'));
    // }
    return FutureBuilder<BuoySearchInfo>(
      future: searchBuoy(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.buoys.isEmpty) {
          return const Center(child: Text('No buoys found'));
        }
        return _buildBuoyList(snapshot.data!.buoys);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Отображение результатов поиска
    return FutureBuilder<BuoySearchInfo>(
      future: searchBuoy(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.buoys.isEmpty) {
          return const Center(child: Text('No buoys found'));
        }
        return _buildBuoyList(snapshot.data!.buoys);
      },
    );
  }

  Widget _buildBuoyList(List<BuoyMapInfo> buoys) {
    // Метод для построения списка карточек буйков
    return ListView.builder(
      itemCount: buoys.length,
      itemBuilder: (context, index) {
        double baseHeight = MediaQuery.of(context).size.height;

        return SizedBox(
          height: baseHeight * 0.2,
          child: BuoyCard(buoy: buoys[index]),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_sharp),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  void close(BuildContext context, result) {
    super.close(context, ''); // передача пустой строки как результата
  }
}
