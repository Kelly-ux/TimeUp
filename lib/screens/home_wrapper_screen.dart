import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_screen.dart';
import 'discover_screen.dart';
import 'chat_screen.dart';

class HomeWrapperScreen extends StatefulWidget {
  const HomeWrapperScreen({super.key});

  @override
  // Fix: Changed _HomeWrapperScreenState to HomeWrapperScreenState
  HomeWrapperScreenState createState() => HomeWrapperScreenState();
}


class HomeWrapperScreenState extends State<HomeWrapperScreen> {
  int _selectedIndex = 0; // Tracks the currently selected tab index

  // List of screens corresponding to each tab in the BottomNavigationBar
  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const AddScreen(),
    const DiscoverScreen(),
    const ChatScreen(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the selected screen from the _screens list.
      // IndexedStack keeps the state of each screen when switching tabs,
      // which is more efficient than rebuilding them every time.
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
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
        currentIndex: _selectedIndex, // The currently selected item
        selectedItemColor: Theme.of(context).colorScheme.primary, // Vibrant accent color
        unselectedItemColor: Colors.grey, // Default color for unselected items
        onTap: _onItemTapped, // Callback when a tab is tapped
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        backgroundColor: Theme.of(context).cardColor, // Background color for the bar
        elevation: 10, // Shadow effect
      ),
    );
  }
}
