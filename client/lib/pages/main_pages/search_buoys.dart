import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/api/buoys.dart';
import 'package:client/components/buoy_list.dart';
import 'package:client/models/buoy.dart';
import 'package:client/components/buoy_card.dart';


class BuoysPage extends StatelessWidget {
  const BuoysPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buoys',
            style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: BuoySearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<BuoySearchInfo>(
        future: searchBuoy(''),
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
          return BuoyList(buoys: snapshot.data!.buoys);
        },
      ),
      // buoySearchInfo.when(
      //   loading: () => const Center(child: CircularProgressIndicator()),
      //   error: (error, stackTrace) => Center(child: Text('Error: $error')),
      //   data: (data) {
      //     if (data.buoys.isEmpty) {
      //       return const Center(child: Text('No buoys found'));
      //     }
      //     return ListView.builder(
      //       itemCount: data.buoys.length,
      //       itemBuilder: (context, index) {
      //         double baseHeight = MediaQuery.of(context).size.height;
      //
      //         return SizedBox(
      //           height: baseHeight * 0.2,
      //           child: BuoyCard(buoy: data.buoys[index]),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}

class BuoySearchDelegate extends SearchDelegate {
  @override
  Widget buildSuggestions(BuildContext context) {
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
        return BuoyList(buoys: snapshot.data!.buoys);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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
        return BuoyList(buoys: snapshot.data!.buoys);
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
