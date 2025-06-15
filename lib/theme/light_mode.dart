import 'package:flutter/material.dart';

/*
    This file defines the light mode theme for the app.
*/
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: const Color.fromARGB(255, 245, 240, 232),
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade100,
    tertiary: const Color.fromARGB(255, 34, 51, 76),
    onPrimary: Colors.grey.shade100,
    onSecondary: const Color.fromARGB(255, 34, 51, 76),
    inversePrimary: Colors.grey.shade700,
  ),
);
