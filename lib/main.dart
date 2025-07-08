// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:js/js_util.dart' as js_util; // Import for JS interop utilities
import 'dart:convert'; // For jsonDecode

// Import your screens
// Removed: import 'package:group_alarm_app/splashscreen.dart'; // No longer needed
import 'package:group_alarm_app/screens/auth/login_screen.dart';
import 'package:group_alarm_app/screens/home_wrapper_screen.dart';


// Function to safely get a global JavaScript variable
T? getGlobalVariable<T>(String name) {
  if (js_util.hasProperty(js_util.globalThis, name)) {
    return js_util.getProperty(js_util.globalThis, name) as T?;
  }
  return null;
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Safely access global variables provided by the Firebase Studio environment
  // These are JavaScript globals, not Dart external variables.
  final String? firebaseConfigString = getGlobalVariable<String>('__firebase_config');
  final String? initialAuthToken = getGlobalVariable<String>('__initial_auth_token');

  // Initialize Firebase
  // Use a default config if running outside Firebase Studio (e.g., local development)
  // In Firebase Studio, firebaseConfigString will be provided.
  FirebaseOptions firebaseOptions;
  if (firebaseConfigString != null && firebaseConfigString.isNotEmpty) {
    final Map<String, dynamic> configMap = jsonDecode(firebaseConfigString);
    firebaseOptions = FirebaseOptions(
      apiKey: configMap['apiKey'] ?? '',
      appId: configMap['appId'] ?? '',
      messagingSenderId: configMap['messagingSenderId'] ?? '',
      projectId: configMap['projectId'] ?? '',
      authDomain: configMap['authDomain'],
      databaseURL: configMap['databaseURL'],
      storageBucket: configMap['storageBucket'],
      measurementId: configMap['measurementId'],
    );
  } else {
    // Fallback for local development if not running in Firebase Studio
    // You would replace these with your actual Firebase project details if testing locally
    // without the Firebase Studio environment.
    firebaseOptions = const FirebaseOptions(
      apiKey: 'YOUR_API_KEY', // Replace with your actual API Key
      appId: 'YOUR_APP_ID',   // Replace with your actual App ID
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID', // Replace
      projectId: 'YOUR_PROJECT_ID', // Replace
    );
  }

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  // Authenticate with the initial token if provided
  if (initialAuthToken != null && initialAuthToken.isNotEmpty) {
    try {
      await FirebaseAuth.instance.signInWithCustomToken(initialAuthToken);
      print('Signed in with custom token.');
    } catch (e) {
      print('Error signing in with custom token: $e');
      // Fallback to anonymous sign-in if custom token fails or is not provided
      await FirebaseAuth.instance.signInAnonymously();
      print('Signed in anonymously.');
    }
  } else {
    // Sign in anonymously if no initial token is provided (e.g., first run in new session)
    await FirebaseAuth.instance.signInAnonymously();
    print('Signed in anonymously (no initial token).');
  }

  // Remove the native splash screen after Firebase is initialized and auth checked
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Alarm App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      // Use StreamBuilder to react to authentication state changes
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking auth state, show a simple loading indicator
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            // User is logged in, navigate to the HomeWrapperScreen
            return const HomeWrapperScreen();
          }
          // User is not logged in, navigate to LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}
