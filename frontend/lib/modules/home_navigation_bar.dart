/**
 * @description: home_navigation_bar
 * @author: yangyiqun
 * @date: 3/24/24
 */

import 'package:flutter/material.dart';

Widget homeButtonNavigationBar(BuildContext context, int selectedIndex, Function(int) onTap) {
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
    currentIndex: selectedIndex,
    unselectedItemColor: Colors.blueGrey,
    selectedItemColor: Colors.blue,
    onTap: onTap,
  );
}
