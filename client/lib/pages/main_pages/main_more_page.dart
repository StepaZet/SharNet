import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../api/about.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
      ),
      body: ListView(
        children: ListTile.divideTiles( // Добавляем разделитель между пунктами списка
          context: context,
          tiles: [
            ListTile(
              title: Text('About white sharks'),
              onTap: () {
                // Обработка нажатия, переход на страницу "About white sharks"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutWhiteSharksPage()),
                );
              },
            ),
            ListTile(
              title: Text('About project'),
              onTap: () {
                // Обработка нажатия, переход на страницу "About project"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutProjectPage()),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About white sharks'),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutSharksInfo>(
        future: getInfoAboutSharks(), // Предполагаем, что эта функция импортирована
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Если данные еще не получены, показываем индикатор загрузки
            return Center(child: CircularProgressIndicator());
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
                    Image.network(snapshot.data!.photo),
                    SizedBox(height: 16), // Добавляем немного пространства между изображением и текстом
                    Text(snapshot.data!.info, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          } else {
            // Если данных нет, показываем сообщение об этом
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Заглушка для страницы "About project"
class AboutProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About project'),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutProjectInfo>(
        future: getInfoAboutProject(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Если данные еще не получены, показываем индикатор загрузки
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Если произошла ошибка при загрузке данных
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Когда данные успешно загружены, отображаем их
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data!.info, style: TextStyle(fontSize: 16)),
            );
          } else {
            // Если данных нет, показываем сообщение об этом
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}