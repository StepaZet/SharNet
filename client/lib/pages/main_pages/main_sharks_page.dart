import 'package:flutter/material.dart';
import '../../api/sharks.dart';
import '../../components/shark_card.dart';
import '../../models/shark.dart';

class SharksPage extends StatefulWidget {
  const SharksPage({Key? key}) : super(key: key);

  @override
  SharksPageState createState() => SharksPageState();
}

class SharksPageState extends State<SharksPage> {
  late Future<SharkSearchInfo> _sharkListFuture;

  @override
  void initState() {
    super.initState();
    // Инициализация будущего с пустым запросом для получения всех акул
    _sharkListFuture = searchShark('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharks', style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SharkSearchDelegate(),
              );
              // Перезагрузить список акул после закрытия поиска
              setState(() {
                _sharkListFuture = searchShark('');
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<SharkSearchInfo>(
        future: _sharkListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
            return const Center(child: Text('No sharks found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.sharks.length,
            itemBuilder: (context, index) {

              double baseHeight = MediaQuery.of(context).size.height;
              return SizedBox(
                height: baseHeight * 0.2,
                child: SharkCard(shark: snapshot.data!.sharks[index]),
              );
            },
          );
        },
      ),
    );
  }
}


class SharkSearchDelegate extends SearchDelegate {
  @override
  Widget buildSuggestions(BuildContext context) {
    //Отображение подсказок поиска
    // if (query.isEmpty) {
    //   return const Center(child: Text('Enter a search term to begin'));
    // }
    return FutureBuilder<SharkSearchInfo>(
      future: searchShark(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
          return const Center(child: Text('No sharks found'));
        }
        return _buildSharkList(snapshot.data!.sharks);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Отображение результатов поиска
    return FutureBuilder<SharkSearchInfo>(
      future: searchShark(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
          return const Center(child: Text('No sharks found'));
        }
        return _buildSharkList(snapshot.data!.sharks);
      },
    );
  }

  Widget _buildSharkList(List<SharkMapInfo> sharks) {


    // Вынесенный метод для построения списка карточек акул
    return ListView.builder(
      itemCount: sharks.length,
      itemBuilder: (context, index) {
        double baseHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: baseHeight * 0.2,
          child: SharkCard(shark: sharks[index]),
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