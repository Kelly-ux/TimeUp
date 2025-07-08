// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the Login Screen (Placeholder)',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Future: Implement login/signup logic here
                print('Login/Signup button pressed (placeholder)');
              },
              child: const Text('Proceed to Login/Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
