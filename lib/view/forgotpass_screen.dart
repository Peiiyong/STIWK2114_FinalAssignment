import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/components/my_button.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/theme/color.dart';
import 'package:wtms/view/login_screen.dart';

// Forgot Password screen widget
class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _showResetFields = false;
  bool _emailValidated = false;

  bool _isObscurePass = true;
  bool _isObscureConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 25, left: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: sprimaryColor,
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
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  // Key Icon
                  Icon(Icons.key, size: 150, color: sprimaryColor),
                  const SizedBox(height: 10),

                  // If email is not validated, show email field and button
                  if (!_emailValidated) ...{
                    // Email TextField
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: sprimaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    // Validate button
                    MyButton(
                      text: 'VALIDATE',
                      onTap: _emailValidate, // call method to validate email
                      icon: Icon(Icons.check_circle, color: Colors.white),
                    ),
                  },

                  // If email is validated, show password fields and reset button
                  if (_showResetFields) ...[
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
                            color: sprimaryColor,
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _passVisibility,
                        ),
                      ),
                      obscureText: _isObscurePass,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 10),
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
                            color: sprimaryColor,
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
                    // Reset button
                    MyButton(
                      text: 'RESET',
                      onTap:
                          _checkPassword, // call method to validate the password
                      icon: Icon(Icons.lock_reset_sharp, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show loading spinner for async processes
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

  // Validate email by checking with the server using POST
  void _emailValidate() async {
    final response = await http.post(
      Uri.parse("${Config.server}/forgot_password.php"),
      body: {'email': _emailController.text},
    );

    var jsonData = json.decode(response.body);
    _showLoadingDialog();

    // Show result based on server response
    if (jsonData['status'] == 'success') {
      // If email is found, show reset fields and set emailValidated to true
      setState(() {
        _showResetFields = true;
        _emailValidated = true;
      });
      Navigator.of(context).pop();
      _showDialog('Success', 'Email found', Colors.green);
    } else {
      // If email is not found, show error message
      Navigator.of(context).pop();
      _showDialog('Failure', 'Email not found', Colors.red);
    }
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

    // Check if password length is at least 6 characters
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
      return; // Stop further execution if password is too short
    }

    // Check if password and confirm password match
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
      return; // Stop further execution if passwords do not match
    }

    // Show loading spinner and proceed with password reset
    _showLoadingDialog();
    _resetPassword(); // Call _resetPassword() method if all validations pass
  }

  // Send reset password request to the server using POST
  void _resetPassword() async {
    final response = await http.post(
      Uri.parse("${Config.server}/reset_password.php"),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    var jsonData = json.decode(response.body);

    if (mounted) {
      Navigator.of(context).pop();
    }

    // Show result based on server response
    if (jsonData['status'] == 'success') {
      // Reset password was successful
      if (mounted) {
        _showDialog('Success', 'Password reset successful', Colors.green);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ),
            );
          }
        });
      }
    } else {
      // Reset password failed
      if (mounted) {
        _showDialog('Error', 'Failed to reset password', Colors.red);
      }
    }
  }
}
