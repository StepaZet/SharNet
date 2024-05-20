import 'package:client/api/profile.dart';
import 'package:client/components/like_button.dart';
import 'package:flutter/material.dart';
import 'package:client/api/buoys.dart';
import 'package:client/models/buoy.dart';
import 'package:client/pages/details/buoy_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'info_line.dart';

class BuoyCard extends ConsumerWidget {
  final BuoyMapInfo buoy;
  final favoriteProvider = StateProvider<bool?>((ref) => null);
  final loadingProvider = StateProvider<bool>((ref) => false);

  BuoyCard({super.key, required this.buoy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double baseHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseHeight * 0.025;

    Future.microtask(() {
      ref.read(favoriteProvider.notifier).state = buoy.isFavorite;
    });

    return Card(
      clipBehavior: Clip.antiAlias, // Обрезка содержимого по границе карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Скругленные углы
      ),
      elevation: 2, // Небольшая тень для карточки
      child: InkWell(
        onTap: () async {
          BuoyFullInfo buoyFullInfo = await getBuoyFullInfo(buoy.id);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuoyDetails(buoyFullInfo: buoyFullInfo),
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                buoy.photo,
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
                        Text(buoy.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: baseFontSize * 0.8)),
                        LikeButton(
                          favoriteProvider: favoriteProvider,
                          loadingProvider: loadingProvider,
                          onFavorite: () async {
                            return await addBuoyToFavorite(buoy.id);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: baseFontSize * 0.1),
                    // Расстояние между элементами
                    InfoLine(
                        label: 'Location',
                        value:
                            '${buoy.location.latitude.toStringAsFixed(2)}, ${buoy.location.longitude.toStringAsFixed(2)}',
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Pings',
                        value: '${buoy.pings}',
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Sharks',
                        value: '${buoy.detectedSharks}',
                        baseFontSize: baseFontSize),
                    InfoLine(
                        label: 'Last ping',
                        value: buoy.lastPing,
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
