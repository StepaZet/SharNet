import 'package:client/models/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeButton extends ConsumerWidget {
  final StateProvider<bool?> favoriteProvider;
  final StateProvider<bool> loadingProvider;
  final Future<PossibleErrorResult> Function() onFavorite;

  const LikeButton(
      {super.key,
      required this.favoriteProvider,
      required this.loadingProvider,
      required this.onFavorite});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteProvider);
    final isLoading = ref.watch(loadingProvider);

    Widget icon;
    if (isLoading) {
      icon = const CircularProgressIndicator();
    } else if (isFavorite == true) {
      icon = const Icon(Icons.favorite, color: Colors.red);
    } else if (isFavorite == false) {
      icon = const Icon(Icons.favorite_border, color: Colors.red);
    } else {
      // Для случая, когда isFavorite == null
      icon = Container();
    }

    return Row(
      children: [
        IconButton(
          icon: icon,
          onPressed: isFavorite == null ? null : () async {
            
            ref.read(loadingProvider.notifier).state = true;
            var result = await onFavorite();

            if (result.resultStatus != ResultEnum.ok) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Error while updating favorite status'),
              ));
              ref.read(loadingProvider.notifier).state = false;

              return;
            }

            ref.read(favoriteProvider.notifier).state =
                !ref.read(favoriteProvider.notifier).state!;
            ref.read(loadingProvider.notifier).state = false;
          },
        ),
      ],
    );
  }
}
