import 'package:client/pages/main_pages/main_buoys_page.dart';
import 'package:client/pages/main_pages/main_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'main_pages/main_more_page.dart';
import 'main_pages/main_profile_page.dart';
import 'main_pages/main_sharks_page.dart';


class MyHomePage extends StatefulWidget {
  final Type? selectedWidget;

  const MyHomePage({super.key, this.selectedWidget = null});

  @override
  MyHomePageState createState() => MyHomePageState(selectedWidget);
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  MyHomePageState(Type? selectedWidget){
    for (int i = 0; i < _widgetOptions.length; i++) {
      if (selectedWidget == _widgetOptions[i].runtimeType) {
        _selectedIndex = i;
        break;
      }
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const MapPage(),
    const SharksPage(),
    const BuoysPage(),
    const MorePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconMap.svg', semanticsLabel: 'MapIcon', color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconShark.svg', semanticsLabel: 'SharkIcon', color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
            label: 'Sharks',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconBuoy.svg', semanticsLabel: 'BuoyIcon', color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
            label: 'Buoys',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconMore.svg', semanticsLabel: 'MoreIcon', color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
            label: 'More',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/IconProfile.svg', semanticsLabel: 'ProfileIcon', color: _selectedIndex == 4 ? Colors.blue : Colors.grey),
            label: 'More',
          ),
        ],
        selectedLabelStyle: const TextStyle(
          fontFamily:  "inter",
          fontSize: 0,
          color: Colors.blue,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily:  "inter",
          fontSize: 0,
          color: Colors.grey,
        ),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}