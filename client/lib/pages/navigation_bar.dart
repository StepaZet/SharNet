import 'package:client/pages/main_pages/main_buoys_page.dart';
import 'package:client/pages/main_pages/main_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'main_pages/main_more_page.dart';
import 'main_pages/main_profile_page.dart';
import 'main_pages/main_sharks_page.dart';

// Provider to hold the currently selected page index
final selectedPageProvider = StateProvider((ref) => 0);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageIndex = ref.watch(selectedPageProvider);

    return Scaffold(
      body: _widgetOptions.elementAt(selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconMap.svg', semanticsLabel: 'MapIcon', color: selectedPageIndex == 0 ? Colors.blue : Colors.grey),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconShark.svg', semanticsLabel: 'SharkIcon', color: selectedPageIndex == 1 ? Colors.blue : Colors.grey),
            label: 'Sharks',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconBuoy.svg', semanticsLabel: 'BuoyIcon', color: selectedPageIndex == 2 ? Colors.blue : Colors.grey),
            label: 'Buoys',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconMore.svg', semanticsLabel: 'MoreIcon', color: selectedPageIndex == 3 ? Colors.blue : Colors.grey),
            label: 'More',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconProfile.svg', semanticsLabel: 'ProfileIcon', color: selectedPageIndex == 4 ? Colors.blue : Colors.grey),
            label: 'Profile',
          ),
        ],
        selectedLabelStyle: const TextStyle(
          fontFamily: "inter",
          fontSize: 0,
          color: Colors.blue,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "inter",
          fontSize: 0,
          color: Colors.grey,
        ),
        currentIndex: selectedPageIndex,
        onTap: (int index) => ref.read(selectedPageProvider.notifier).state = index,
      ),
    );
  }
}

// List of available pages
const List<Widget> _widgetOptions = [
  ProviderScope(child: MainMapPage()),
  ProviderScope(child: SharksPage()),
  ProviderScope(child: BuoysPage()),
  ProviderScope(child: MorePage()),
  ProviderScope(child: ProfilePage()),
];
