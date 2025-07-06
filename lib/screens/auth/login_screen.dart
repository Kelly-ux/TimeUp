import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Changed to package import
import '../home_wrapper_screen.dart';
import '../../components/segmented_button.dart' as custom_segmented_button; // Added 'as' prefix

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState(); // Removed underscore
}

class LoginScreenState extends State<LoginScreen> { // Removed underscore
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedModeIndex = 0; // 0 for Guest, 1 for Student

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_selectedModeIndex == 1) {
          // Student Mode
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          if (!mounted) return; // Mounted check after await
          await _storeOrUpdateUserData(userCredential.user!);
        } else {
          // Guest Mode
          UserCredential userCredential;
          if (_auth.currentUser != null && _auth.currentUser!.isAnonymous) {
            userCredential = await _auth.signInAnonymously();
          } else {
            userCredential = await _auth.signInAnonymously();
          }
          if (!mounted) return; // Mounted check after await
          await _storeOrUpdateUserData(userCredential.user!);
        }

 if (!mounted) {
 return; // Mounted check before navigation
 }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWrapperScreen()), // Correctly using as a widget
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return; // Mounted check before using context
        // Handle Firebase Auth errors (e.g., wrong password, user not found)
 if (!mounted) {
 return;
 } ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed: ${e.message}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } catch (e) {
        if (!mounted) return; // Mounted check before using context
 if (!mounted) {
 return;
 }
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (!mounted) return; // Mounted check after await
        await _storeOrUpdateUserData(userCredential.user!);

 if (!mounted) {
 return; // Mounted check before navigation
 }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWrapperScreen()), // Changed to HomeWrapperScreen for consistency
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return; // Mounted check before using context
        // Handle Firebase Auth errors (e.g., email already in use)
 if (!mounted) {
 return;
 } ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign Up Failed: ${e.message}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } catch (e) {
        if (!mounted) return; // Mounted check before using context
 if (!mounted) {
 return;
 }
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _storeOrUpdateUserData(User user) async {
    Map<String, dynamic> userData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(), // Storing email for both modes
      'isGuest': _selectedModeIndex == 0,
      'lastLogin': FieldValue.serverTimestamp(),
    };

    if (_selectedModeIndex == 1) {
      // Add student specific data
      userData['department'] = _departmentController.text.trim();
      userData['level'] = _levelController.text.trim();
    }

    await _firestore.collection('users').doc(user.uid).set(userData, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Using the aliased custom SegmentedButton
                custom_segmented_button.SegmentedButton(
                  segments: const ['Guest', 'Student'],
                  selectedIndex: _selectedModeIndex,
                  onSegmentSelected: (index) {
                    setState(() {
                      _selectedModeIndex = index;
                      // Clear fields when switching modes (optional)
                      _nameController.clear();
                      _phoneController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _departmentController.clear();
                      _levelController.clear();
                    });
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Basic phone number validation (you might want a more robust one)
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address (Gmail)'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    // Basic email validation for Gmail format
                    if (!RegExp(r'^[^@]+@gmail\.com$').hasMatch(value)) {
                      return 'Please enter a valid Gmail address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                if (_selectedModeIndex == 1) ...[
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _departmentController,
                    decoration: const InputDecoration(labelText: 'Department'),
                    validator: (value) {
                      if (_selectedModeIndex == 1 && (value == null || value.isEmpty)) {
                        return 'Please enter your department';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Level'),
                    validator: (value) {
                      if (_selectedModeIndex == 1 && (value == null || value.isEmpty)) {
                        return 'Please enter your level';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Login'),
                        ),
                      ),
                const SizedBox(height: 15),
                if (_selectedModeIndex == 1)
                  TextButton(
                    onPressed: _signUp,
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
