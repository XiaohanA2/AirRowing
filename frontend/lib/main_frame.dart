import 'package:air_rowing/modules/home/profile/profile_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/club/myClub/myClub_page.dart';
import 'modules/home/profile/profile_page.dart';
import 'modules/training/training_page.dart';
import 'modules/club/club_page.dart';
import 'modules/community/community_page.dart';

class MainFrame extends StatefulWidget {
  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ProfilePage(),
    TrainingPage(),
    ClubPage(),
    CommunityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: HomeButtonNavigationBar(context)
    );
  }

  Widget HomeButtonNavigationBar(BuildContext context) {

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Club',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Community',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
