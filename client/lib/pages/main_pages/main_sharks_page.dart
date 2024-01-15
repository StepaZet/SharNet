// import 'package:flutter/material.dart';
//
// import '../../api/sharks.dart';
// import '../../components/shark_card.dart';
// import '../../mocks/sharks_list.dart';
// import '../../models/shark.dart';
//
//
// class SharksPage extends StatelessWidget {
//   // const SharksPage({super.key});
//
//   List<SharkMapInfo> sharks;
//
//   SharksPage({super.key, required this.sharks});
//
//   // Здесь будет функция для получения списка акул
//
//   @override
//   Widget build(BuildContext context) {
//
//     final List<SharkMapInfo> sharks = await searchShark("something").sharks;  // TODO: replace with actual search query
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sharks'),
//       ),
//       body: ListView.builder(
//         itemCount: sharks.length,
//         itemBuilder: (context, index) {
//           return SharkCard(shark: sharks[index]);
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// import '../../api/sharks.dart';
// import '../../components/shark_card.dart';
// import '../../models/shark.dart';
//
// class SharksPage extends StatelessWidget {
//   const SharksPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sharks'),
//       ),
//       body: FutureBuilder<SharkSearchInfo>(
//         future: searchShark("something"), // Здесь можно использовать фактический поисковый запрос
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
//             return const Center(child: Text('No sharks found'));
//           } else {
//             List<SharkMapInfo> sharks = snapshot.data!.sharks;
//             return ListView.builder(
//               itemCount: sharks.length,
//               itemBuilder: (context, index) {
//                 return SharkCard(shark: sharks[index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
//
// import 'package:flutter/material.dart';
//
// import '../../api/sharks.dart';
// import '../../components/shark_card.dart';
// import '../../models/shark.dart';
//
// class SharksPage extends StatefulWidget {
//   const SharksPage({super.key});
//
//   @override
//   _SharksPageState createState() => _SharksPageState();
// }
//
// class _SharksPageState extends State<SharksPage> {
//   final TextEditingController _searchController = TextEditingController();
//   Future<SharkSearchInfo>? _sharksFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // Запускаем начальный поиск с пустым запросом
//     _sharksFuture = searchShark("");
//     _searchController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       // Обновляем Future каждый раз при изменении текста
//       _sharksFuture = searchShark(_searchController.text);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search for sharks...',
//             border: InputBorder.none,
//             suffixIcon: Icon(Icons.search),
//           ),
//         ),
//       ),
//       body: FutureBuilder<SharkSearchInfo>(
//         future: _sharksFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
//             return const Center(child: Text('No sharks found'));
//           } else {
//             List<SharkMapInfo> sharks = snapshot.data!.sharks;
//             return ListView.builder(
//               itemCount: sharks.length,
//               itemBuilder: (context, index) {
//                 return SharkCard(shark: sharks[index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }


//
// import 'package:flutter/material.dart';
//
// import '../../api/sharks.dart';
// import '../../components/shark_card.dart';
// import '../../models/shark.dart';
//
// class SharksPage extends StatefulWidget {
//   const SharksPage({super.key});
//
//   @override
//   _SharksPageState createState() => _SharksPageState();
// }
//
// class _SharksPageState extends State<SharksPage> {
//   final TextEditingController _searchController = TextEditingController();
//   Future<SharkSearchInfo>? _sharksFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _sharksFuture = searchShark("");
//     _searchController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       _sharksFuture = searchShark(_searchController.text);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sharks'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: SharkSearchDelegate(_sharksFuture),
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<SharkSearchInfo>(
//         future: _sharksFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
//             return const Center(child: Text('No sharks found'));
//           } else {
//             List<SharkMapInfo> sharks = snapshot.data!.sharks;
//             return ListView.builder(
//               itemCount: sharks.length,
//               itemBuilder: (context, index) {
//                 return SharkCard(shark: sharks[index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class SharkSearchDelegate extends SearchDelegate {
//   final Future<SharkSearchInfo>? sharksFuture;
//
//   SharkSearchDelegate(this.sharksFuture);
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder<SharkSearchInfo>(
//       future: sharksFuture, // Here you can call the search API with query
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();
//         else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
//           return const Center(child: Text('No sharks found'));
//         } else {
//           List<SharkMapInfo> sharks = snapshot.data!.sharks;
//           return ListView.builder(
//             itemCount: sharks.length,
//             itemBuilder: (context, index) {
//               return SharkCard(shark: sharks[index]);
//             },
//           );
//         }
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return FutureBuilder<SharkSearchInfo>(
//       future: sharksFuture, // Here you can call the search API with query
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();
//         else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
//           return const Center(child: Text('No sharks found'));
//         } else {
//           List<SharkMapInfo> sharks = snapshot.data!.sharks;
//           return ListView.builder(
//             itemCount: sharks.length,
//             itemBuilder: (context, index) {
//               return SharkCard(shark: sharks[index]);
//             },
//           );
//         }
//       },
//     );
//   }
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../api/sharks.dart';
import '../../components/shark_card.dart';
import '../../models/shark.dart';

class SharksPage extends StatefulWidget {
  const SharksPage({Key? key}) : super(key: key);

  @override
  _SharksPageState createState() => _SharksPageState();
}

class _SharksPageState extends State<SharksPage> {
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
        title: const Text('Sharks'),
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
              return Container(
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
    if (query.isEmpty) {
      return const Center(child: Text('Enter a search term to begin'));
    }
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
    // Действия в AppBar для очистки поиска
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
    // Ведущий виджет в AppBar (обычно кнопка "назад")
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