import 'package:client/pages/about/project.dart';
import 'package:client/pages/about/sharks.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('More',
            style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text('About white sharks',
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutWhiteSharksPage()),
                );
              },
            ),
            ListTile(
              title: Text('About project',
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutProjectPage()),
                );
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
