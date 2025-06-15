import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';

// Screen for resetting user password
class ResetPassScreen extends StatefulWidget {
  final Worker worker; // Current logged-in worker object
  const ResetPassScreen({super.key, required this.worker});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isObscurePass = true;
  bool _isObscureConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
            letterSpacing: 5,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 25, left: 25, bottom: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Key Icon
              Icon(
                Icons.key,
                size: 150,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 10),
              // 'Reset Password' title
              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  letterSpacing: 1,
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
              const SizedBox(height: 20),
              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _passVisibility,
                  ),
                ),
                obscureText: _isObscurePass,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              // Confirm Password TextField
              TextField(
                controller: _confirmController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirmPass
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _confirmPassVisibility,
                  ),
                ),
                obscureText: _isObscureConfirmPass,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              // Reset Password button
              GestureDetector(
                onTap: _checkPassword, // Validate and trigger reset
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RESET',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Serif',
                          letterSpacing: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.lock_reset_sharp,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show loading spinner during request
  void _showLoadingDialog({Duration duration = const Duration(seconds: 3)}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(child: SpinKitFadingCube(color: Colors.white)),
        );
      },
    );
  }

  // Display result dialogs (success/failure)
  void _showDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: color)),
            ),
          ],
        );
      },
    );
  }

  // Toggle visibility for password field
  void _passVisibility() {
    setState(() {
      _isObscurePass = !_isObscurePass;
    });
  }

  // Toggle visibility for confirm password field
  void _confirmPassVisibility() {
    setState(() {
      _isObscureConfirmPass = !_isObscureConfirmPass;
    });
  }

  // Validate password inputs before resetting ( >6 char, match )
  void _checkPassword() {
    // Check if all fields are filled
    if ( _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all fields',
            style: TextStyle(fontFamily: 'Serif'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop further execution if any field is empty
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 6 characters',
            style: TextStyle(fontFamily: 'Serif'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passwords do not match',
            style: TextStyle(fontFamily: 'Serif'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _showLoadingDialog(); // Show spinner
    _resetPassword(); //Call reset function
  }

  // Send password reset request to server using POST
  void _resetPassword() async {
    final response = await http.post(
      Uri.parse("${Config.server}/reset_password.php"),
      body: {
        'email': widget.worker.email,
        'password': _passwordController.text,
      },
    );

    var jsonData = json.decode(response.body);

    if (mounted) {
      Navigator.of(context).pop(); // close spinner
    }

    // Show result based on server response
    if (jsonData['status'] == 'success') {
      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
            _showDialog('Success', 'Password reset successful', Colors.green);
          }
        });
      }
    } else {
      if (mounted) {
        _showDialog('Error', 'Failed to reset password', Colors.red);
      }
    }
  }
}
