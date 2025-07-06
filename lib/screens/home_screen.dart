import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  String _userName = 'Guest'; // Default name

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _fetchAndListenForUserName();
    }
  }

  void _fetchAndListenForUserName() {
    _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data();
        if (userData != null && userData.containsKey('name')) {
          setState(() {
            _userName = userData['name'];
          });
        } else {
          // Fallback to display name if name field is missing in Firestore
          if (_currentUser!.displayName != null && _currentUser!.displayName!.isNotEmpty) {
             setState(() {
              _userName = _currentUser!.displayName!;
            });
          }
        }
      } else {
         // If user document doesn't exist, fallback to display name
         if (_currentUser!.displayName != null && _currentUser!.displayName!.isNotEmpty) {
             setState(() {
              _userName = _currentUser!.displayName!;
            });
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $_userName!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Alarms:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            // Placeholder for created alarms
            Expanded(
              child: Center(
                child: Text(
                  'Alarm list will appear here',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}