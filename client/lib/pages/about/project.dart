import 'package:client/api/about.dart';
import 'package:flutter/material.dart';

class AboutProjectPage extends StatelessWidget {
  const AboutProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About project',
            style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutProjectInfo>(
        future: getInfoAboutProject(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data!.info,
                  style: TextStyle(
                      fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
