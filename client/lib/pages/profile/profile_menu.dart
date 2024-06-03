import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
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

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Consumer(builder: (context, ref, child) {
                  final photoUrl = ref.watch(photoUrlProvider);

                  if (photoUrl.isEmpty) {
                    return const CircularProgressIndicator();
                  }

                  return Image.network(
                    photoUrl,
                    fit: BoxFit.scaleDown,
                    // Изображение будет заполнять всю высоту карточки
                    height: baseSizeHeight * 0.2,
                  );
                }),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Consumer(builder: (context, ref, child) {
                        final name = ref.watch(nameProvider);
                        final surname = ref.watch(surnameProvider);

                        return Text('$name $surname',
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
                ),
              )
            ],
          ),
        ),
        ListTile(
          title: Text('Edit profile',
              style:
                  TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          leading: const Icon(Icons.edit),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(userInfo: userInfo),
              ),
            );
          },
        ),
        ListTile(
          title: Text('Favourites',
              style:
                  TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          leading: const Icon(Icons.favorite),
          onTap: () {
            // var sharks = await getFavoriteSharks();
            // var buoys = await getFavoriteBuoys();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoriteItems(),
              ),
            );
          },
        ),
        ListTile(
          title: Text('Notifications',
              style:
                  TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          leading: const Icon(Icons.notifications),
          onTap: () {},
        ),
        ListTile(
          title: Text('Payments',
              style:
                  TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          leading: const Icon(Icons.payment),
          onTap: () {},
        ),
        ListTile(
          title: Text('Donate',
              style:
                  TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
          leading: const Icon(Icons.card_giftcard),
          onTap: () {},
        ),
      ],
    );
  }
}
