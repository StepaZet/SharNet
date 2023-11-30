import 'package:flutter/material.dart';

import '../../components/shark_card.dart';
import '../../mocks/sharks_list.dart';
import '../../models/shark.dart';


class SharksPage extends StatelessWidget {
  const SharksPage({super.key});

  // Здесь будет функция для получения списка акул

  @override
  Widget build(BuildContext context) {
    // Предполагаем, что у вас есть функция getSharks() возвращающая List<Shark>
    final List<Shark> sharks = getSharks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sharks'),
      ),
      body: ListView.builder(
        itemCount: sharks.length,
        itemBuilder: (context, index) {
          return SharkCard(shark: sharks[index]);
        },
      ),
    );
  }
}
