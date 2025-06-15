import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/theme/dark_mode.dart';
import 'package:wtms/theme/light_mode.dart';


// A provider class to manage and toggle between light and dark themes.
class ThemeProvider extends ChangeNotifier {
  // Initially set to light mode
  ThemeData _themeData = lightMode;

  // Getter to retrieve the current theme
  ThemeData get themeData => _themeData;

  // Check if the current theme is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // Constructor to load the saved theme preference when the app starts
  ThemeProvider() {
    _loadTheme();
  }

  // Setter to update the theme and save the preference
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme(); // Save the selected theme to SharedPreferences
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Toggle between light mode and dark mode
  void toggleTheme() {
    _themeData = (_themeData == lightMode) ? darkMode : lightMode;
    _saveTheme(); // Save the updated theme to SharedPreferences
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Save the current theme preference to SharedPreferences
  void _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData == darkMode);
  }

  // Load the saved theme preference from SharedPreferences
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark =
        prefs.getBool('isDarkMode') ??
        false; // Default to light mode if no preference is saved
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }
}
