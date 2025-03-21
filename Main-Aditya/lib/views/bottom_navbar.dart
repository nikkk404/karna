import 'package:cygiene_ui/cyber_tips_view.dart';
import 'package:cygiene_ui/home_view.dart';
import 'package:cygiene_ui/views/profile_pages/features_view.dart';
import 'package:cygiene_ui/views/profile_pages/blogs_view.dart';
import 'package:cygiene_ui/views/profile_pages/faqs_view.dart';
import 'package:cygiene_ui/views/profile_pages/profile_view.dart';

import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 1;
  final List<Widget> screens = [
    NewsListScreen(),
    HomeView(),
    const FeaturesPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Features',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
