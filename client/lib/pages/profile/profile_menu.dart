import 'package:client/components/styles.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/profile/donate.dart';
import 'package:client/pages/profile/favorite_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_profile.dart';

final nameProvider = StateProvider<String>((ref) => '');
final surnameProvider = StateProvider<String>((ref) => '');
final photoUrlProvider = StateProvider<String>((ref) => '');

class ProfileMenu extends ConsumerWidget {
  final ProfileInfo userInfo;

  const ProfileMenu({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    Future.microtask(() {
      ref.read(nameProvider.notifier).state = userInfo.name ?? '';
      ref.read(surnameProvider.notifier).state = userInfo.surname ?? '';
      ref.read(photoUrlProvider.notifier).state = userInfo.photoUrl ?? '';
    });

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: ListView(
          children: [
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Consumer(builder: (context, ref, child) {
                      final photoUrl = ref.watch(photoUrlProvider);

                      if (photoUrl.isEmpty) {
                        return const Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.scaleDown,
                          // Изображение будет заполнять всю высоту карточки
                          // height: baseSizeHeight * 0.2,
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: SizedBox(
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Consumer(builder: (context, ref, child) {
                                  final name = ref.watch(nameProvider);
                                  final surname = ref.watch(surnameProvider);

                                  final profileName = name == '' ? "Name Surname" : '$name $surname';

                                  return Text(profileName,
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        fontSize: baseFontSize * 0.7,
                                      ));
                                }),
                                // Text('${userInfo.name} ${userInfo.surname}',
                                //     style: TextStyle(
                                //         fontFamily: 'inter',
                                //         fontSize: baseFontSize * 0.7)),
                                SizedBox(height: baseFontSize * 0.1),
                                Text(userInfo.email,
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      fontSize: baseFontSize * 0.55,
                                      color: Colors.grey,
                                    )),
                                // Расстояние между элементами
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: accentButtonStyle,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(userInfo: userInfo),
                                    ),
                                  );
                                },
                                child: const Text('Edit profile'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: accentButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteItems(),
                    ),
                  );
                },
                child: const Text('Favourites'),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child:     Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.blue,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonatePage(),
                    ),
                  );
                },
                child: const Text('Donate'),
              ),
            ),
          ],
        ),
    );
  }
}
