import 'package:client/components/shark_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/api/sharks.dart';
import 'package:client/components/shark_card.dart';
import 'package:client/models/shark.dart';


class SharksPage extends StatelessWidget {
  const SharksPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharks',
            style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SharkSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<SharkSearchInfo>(
        future: searchShark(''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.sharks.isEmpty) {
            return const Center(child: Text('No buoys found'));
          }
          return SharkList(sharks: snapshot.data!.sharks);
        },
      ),
    );
    //   body: sharkSearchInfo.when(
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //     error: (error, stackTrace) => Center(child: Text('Error: $error')),
    //     data: (data) {
    //       if (data.sharks.isEmpty) {
    //         return const Center(child: Text('No sharks found'));
    //       }
    //       return ListView.builder(
    //         itemCount: data.sharks.length,
    //         itemBuilder: (context, index) {
    //           double baseHeight = MediaQuery.of(context).size.height;
    //
    //           return SizedBox(
    //             height: baseHeight * 0.2,
    //             child: SharkCard(shark: data.sharks[index]),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}

class SharkSearchDelegate extends SearchDelegate {
  @override
  Widget buildSuggestions(BuildContext context) {
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
        return SharkList(sharks: snapshot.data!.sharks);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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
        return SharkList(sharks: snapshot.data!.sharks);
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
    super.close(context, '');
  }
}
