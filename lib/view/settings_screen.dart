import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtms/components/my_settings_tile.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/theme/theme_provider.dart';
import 'package:wtms/view/resetpass_screen.dart';


// A screen that allows the user to configure application settings
class SettingsScreen extends StatefulWidget {
  final Worker worker; // Current logged-in worker object
  const SettingsScreen({super.key, required this.worker});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: Column(
        children: [
          // Dark Mode toggle tile
          MySettingsTile(
            icon: Icon(Icons.dark_mode),
            title: 'Dark Mode',
            hasSwitch: true,
            switchValue:
                Provider.of<ThemeProvider>(
                  context,
                ).isDarkMode, // Get current theme mode
            onToggle: (value) {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(); // Toggle theme mode when switch is changed
            },
          ),

          // Reset Password tile
          MySettingsTile(
            icon: Icon(Icons.lock_reset),
            title: 'Reset Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPassScreen(worker: widget.worker),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
