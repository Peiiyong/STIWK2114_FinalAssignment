import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtms/theme/theme_provider.dart';
import 'package:wtms/view/splash_screen.dart';

void main() {
  runApp(
    // Providing ThemeProvider to enable dynamic theming across the app
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WTMS',
      home: const SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData, // Apply dynamic theme
    );
  }
}
