// lib/screens/home_wrapper_screen.dart

import 'package:flutter/material.dart';
import 'package:group_alarm_app/screens/home_screen.dart';
import 'package:group_alarm_app/screens/add_screen.dart';
import 'package:group_alarm_app/screens/discover_screen.dart';
import 'package:group_alarm_app/screens/chat_screen.dart';

class HomeWrapperScreen extends StatefulWidget {
  const HomeWrapperScreen({super.key});

  @override
  State<HomeWrapperScreen> createState() => _HomeWrapperScreenState();
}

class _HomeWrapperScreenState extends State<HomeWrapperScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    AddScreen(),
    DiscoverScreen(),
    ChatScreen(),
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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore), // Or Icons.explore
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary, // Vibrant accent
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures labels are always visible
      ),
    );
  }
}
