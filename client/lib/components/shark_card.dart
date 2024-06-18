import 'package:client/api/profile.dart';
import 'package:client/components/like_button.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:client/api/sharks.dart';
import 'package:client/models/shark.dart';
import 'package:client/pages/details/shark_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'info_line.dart';

class SharkCard extends ConsumerWidget {
  final SharkMapInfo shark;
  final favoriteProvider = StateProvider<bool?>((ref) => null);
  final loadingProvider = StateProvider<bool>((ref) => false);

  SharkCard({super.key, required this.shark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double baseHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseHeight * 0.025; // Например, 5% от ширины экрана

    Future.microtask(() {
      ref.read(favoriteProvider.notifier).state = shark.isFavourite;
    });

    return Card(
      clipBehavior: Clip.antiAlias, // Обрезка содержимого по границе карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Скругленные углы
      ),
      child: InkWell(
        onTap: () async {
          SharkFullInfo sharkFullInfo = await getSharkFullInfo(shark.id);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SharkPage(shark: shark, sharkFullInfo: sharkFullInfo)),
          );
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                shark.photo,
                fit: BoxFit.cover,
                // Изображение будет заполнять всю высоту карточки
                height: baseHeight * 0.3,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(shark.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: baseFontSize * 0.8)),
                        LikeButton(
                          favoriteProvider: favoriteProvider,
                          loadingProvider: loadingProvider,
                          onFavorite: () async {

                            var result = await changeSharkFavoriteValue(shark.id, shark.isFavourite!);

                            if (result.resultStatus == ResultEnum.ok) {
                              shark.isFavourite = !shark.isFavourite!;
                            }

                            return result;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: baseFontSize * 0.1),
                    // Расстояние между элементами
                    InfoLine(
                        label: 'Length',
                        value: '${shark.length} cm',
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Weight',
                        value: '${shark.weight} kg',
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Sex',
                        value: shark.sex,
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Tracks',
                        value: '${shark.tracks}',
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Last tagged',
                        value: shark.lastTagged,
                        baseFontSize: baseFontSize),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
