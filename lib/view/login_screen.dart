import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/components/my_button.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/theme/color.dart';
import 'package:wtms/view/forgotpass_screen.dart';
import 'package:wtms/view/home_screen.dart';
import 'package:wtms/view/register_screen.dart';

// Login screen widget (stateful because it manages form state and visibility
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true; // Password visibility toggle
  bool _keepSignedIn = false; // Remember login state

  @override
  void initState() {
    super.initState();
    _checkSession(); // Automatically login if session exists
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const SizedBox(height: 10),
              Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 38,
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
              const SizedBox(height: 50),
              Column(
                children: [
                  // App Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(height: 10),
                  // App Name
                  Text(
                    'WTMS',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: sprimaryColor,
                      letterSpacing: 3,
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
                  // Email TextField
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.email, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: sprimaryColor,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: _passVisibility,
                      ),
                    ),
                    obscureText: _isObscure,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Keep me signed in
                      Expanded(
                        child: CheckboxListTile(
                          side: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          title: const Text(
                            "Keep me signed in",
                            style: TextStyle(color: Colors.black),
                          ),
                          value: _keepSignedIn,
                          onChanged: (value) {
                            setState(() {
                              _keepSignedIn = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      // Forgot Password
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassScreen(),
                              ),
                            ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                  // Login Button
                  MyButton(
                    icon: Icon(Icons.login),
                    text: 'LOGIN',
                    onTap: loginWorker,
                  ),
                  const SizedBox(height: 15),
                  // Dont have an account? Create an Account!
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dont have an account?',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const RegistrationScreen(),
                              ),
                            ),
                        child: Text(
                          'Create an account!',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Toggle password visibility
  void _passVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  // Show loading animation dialog
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

  // Perform login process after click the button
  void loginWorker() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validation check
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all fields',
            style: TextStyle(fontFamily: 'Serif'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _showLoadingDialog();
    // Send login request to server using POST
    http
        .post(
          Uri.parse('${Config.server}/login_worker.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          Navigator.of(context).pop(); // close the spinning dialog

          // Check if the response is successful
          if (response.statusCode == 200) {
            var jsonData = json.decode(response.body);
            // Login success
            if (jsonData['status'] == 'success') {
              var workerData = jsonData['data'];
              Worker worker = Worker.fromJson(workerData[0]);

              // Save worker data and login status using SharedPreferences if checkbox selected
              if (_keepSignedIn) {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('isLoggedIn', true);
                  prefs.setString('worker', json.encode(worker.toJson()));
                });
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Welcome ${worker.fullName}",
                    style: TextStyle(fontFamily: 'Serif'),
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate to HomeScreen and pass the worker object
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(worker: worker),
                ),
              );
            } else {
              // Login failed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fail to login',
                    style: TextStyle(fontFamily: 'Serif'),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        })
        .catchError((error) {
          Navigator.of(context).pop(); // close the spinning dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error occurred: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  // Automatically log in if session exists using SharedPreferences
  void _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String? workerJson = prefs.getString('worker');
      if (workerJson != null) {
        Worker worker = Worker.fromJson(json.decode(workerJson));
        // Navigate to HomeScreen and pass the worker object
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(worker: worker)),
        );
      }
    }
  }
}
