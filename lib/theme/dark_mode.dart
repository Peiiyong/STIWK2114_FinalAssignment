import 'package:flutter/material.dart';
/*
    This file defines the dark mode theme for the app.
*/
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 34, 51, 76),
    primary: const Color.fromARGB(255, 122, 122, 122),
    secondary: const Color.fromARGB(255, 54, 73, 102),
    tertiary: const Color.fromARGB(255, 4, 24, 68),
    onPrimary: Colors.grey.shade100,    
    onSecondary: const Color.fromARGB(255, 54, 73, 102),
    inversePrimary: Colors.grey.shade300,
  ),
);