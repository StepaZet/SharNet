import 'package:client/pages/main_pages/main_buoys_page.dart';
import 'package:client/pages/main_pages/main_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'main_pages/main_more_page.dart';
import 'main_pages/main_sharks_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MapPage(),
    const SharksPage(),
    const BuoysPage(),
    const MorePage(),
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