import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/theme/color.dart';
import 'package:wtms/view/home_screen.dart';
import 'package:wtms/view/login_screen.dart';

// Splash screen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // Delay for 7 seconds before checking login status
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 7), () {
      _checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App logo
            Container(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 250,
              ),
            ),
            // App name
            Text(
              'WTMS',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: sprimaryColor,
                letterSpacing: 7,
                fontFamily: 'Serif',
                shadows: [
                  Shadow(
                    color: Colors.grey,
                    offset: Offset(3, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // App description
            Text(
              'Worker Task Management System ',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                letterSpacing: 5,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 30),
            // Loading spinner
            SpinKitSpinningLines(
              color: Colors.blue[900] ?? Colors.blue,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
  // Check if user is already logged in using SharedPreferences
  Future<void> _checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        String? workerJson = prefs.getString('worker');
        if (workerJson != null) {
          // got data -> home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HomeScreen(
                    worker: Worker.fromJson(json.decode(workerJson)),
                  ),
            ),
          );
        } else {
          // No worker data found, redirect to login screen
          _navigateToLoginScreen();
        }
      } else {
        // User is not logged in, redirect to login screen
        _navigateToLoginScreen();
      }
    } catch (e) {
      print("Error checking login status...");
      _navigateToLoginScreen();
    }
  }

  // Navigate to login screen
  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
