import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_alarm_app/screens/auth/login_screen.dart'; // FIX: Corrected to full package path
import 'dart:convert'; // Required for jsonDecode

// Declare external variables provided by the Firebase Studio environment
// These variables are injected into the runtime by the Firebase Studio environment.
external String? __firebase_config;
external String? __app_id;
external String? __initial_auth_token;

void main() async {
  // Ensure Flutter binding is initialized before any Flutter-specific calls
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if a default Firebase app is already initialized.
    // This prevents re-initialization errors if the environment implicitly sets it up.
    if (Firebase.apps.isEmpty) {
      FirebaseOptions? options;
      // Attempt to parse firebaseConfig from the global variable __firebase_config
      if (__firebase_config != null && __firebase_config!.isNotEmpty) { // Null check and assertion
        try {
          final Map<String, dynamic> configMap = jsonDecode(__firebase_config!) as Map<String, dynamic>; // Null assertion
          // Construct FirebaseOptions using the provided global variables and parsed config
          options = FirebaseOptions(
            appId: __app_id ?? configMap['appId'] ?? 'default-app-id', // Prioritize __app_id
            apiKey: configMap['apiKey'] ?? '',
            projectId: configMap['projectId'] ?? '',
            messagingSenderId: configMap['messagingSenderId'] ?? '',
            storageBucket: configMap['storageBucket'] ?? '',
            iosClientId: configMap['iosClientId'] ?? '',
            androidClientId: configMap['androidClientId'] ?? '',
            measurementId: configMap['measurementId'] ?? '',
          );
          print('Attempting Firebase initialization with provided options.');
        } catch (e) {
          // Log error if config parsing fails, and proceed without specific options
          print('Error parsing __firebase_config: $e. Initializing Firebase without specific options.');
        }
      }

      // Initialize Firebase. If 'options' are valid, use them; otherwise, use default.
      if (options != null) {
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp(); // Fallback to default initialization
      }
    } else {
      print('Firebase app already initialized by the environment.');
    }

    // Authenticate user after Firebase is confirmed to be initialized
    final auth = FirebaseAuth.instance;
    // __initial_auth_token is provided by the Canvas environment for authentication
    final String? initialAuthToken = __initial_auth_token;

    if (initialAuthToken != null && initialAuthToken.isNotEmpty) {
      await auth.signInWithCustomToken(initialAuthToken);
      print('User signed in with custom token.');
    } else {
      await auth.signInAnonymously();
      print('User signed in anonymously.');
    }

  } catch (e) {
    // Catch any errors during Firebase initialization or authentication
    print('Firebase initialization or authentication failed: $e');
    // In a production app, you might want to show an error screen to the user
    // or log this error more prominently.
  }

  // Run the Flutter application
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, // Vibrant accent color
          primary: Colors.blueAccent,
          secondary: Colors.lightBlueAccent,
          tertiary: Colors.cyan,
          error: Colors.redAccent,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}
