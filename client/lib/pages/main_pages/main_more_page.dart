import 'package:flutter/material.dart';

import '../../api/about.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('More', style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: ListView(
        children: ListTile.divideTiles( // Добавляем разделитель между пунктами списка
          context: context,
          tiles: [
            ListTile(
              title: Text('About white sharks', style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
              onTap: () {
                // Обработка нажатия, переход на страницу "About white sharks"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutWhiteSharksPage()),
                );
              },
            ),
            ListTile(
              title: Text('About project', style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
              onTap: () {
                // Обработка нажатия, переход на страницу "About project"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutProjectPage()),
                );
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}

// Заглушка для страницы "About white sharks"
class AboutWhiteSharksPage extends StatelessWidget {
  const AboutWhiteSharksPage({super.key});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About white sharks', style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutSharksInfo>(
        future: getInfoAboutSharks(), // Предполагаем, что эта функция импортирована
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Если данные еще не получены, показываем индикатор загрузки
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Если произошла ошибка при загрузке данных
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Когда данные успешно загружены, отображаем их
            return SingleChildScrollView( // Для прокрутки содержимого
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // Радиус закругления
                      child: Image.network(snapshot.data!.photo),
                    ),
                    const SizedBox(height: 16), // Добавляем немного пространства между изображением и текстом
                    Text(snapshot.data!.info, style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                  ],
                ),
              ),
            );
          } else {
            // Если данных нет, показываем сообщение об этом
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Заглушка для страницы "About project"
class AboutProjectPage extends StatelessWidget {
  const AboutProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About project', style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutProjectInfo>(
        future: getInfoAboutProject(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Если данные еще не получены, показываем индикатор загрузки
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Если произошла ошибка при загрузке данных
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Когда данные успешно загружены, отображаем их
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data!.info, style: TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
            );
          } else {
            // Если данных нет, показываем сообщение об этом
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}