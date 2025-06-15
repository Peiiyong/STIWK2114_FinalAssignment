import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/components/my_drawer_tile.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/theme/light_mode.dart';
import 'package:wtms/theme/theme_provider.dart';
import 'package:wtms/view/login_screen.dart';
import 'package:wtms/view/settings_screen.dart';


/*
    MyDrawer is a side navigation drawer used throughout the app.
    It displays navigation options like Profile, Settings, and Logout.
*/
class MyDrawer extends StatelessWidget {
  /*
      The worker object is used to pass the logged-in user's data (e.g., password) 
      to other screens like SettingsScreen where user-specific information is needed.
  */
  final Worker worker; // Holds the current worker's data
  const MyDrawer({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          // Divider line
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),

          // home list tile
          MyDrawerTile(
            text: 'H O M E',
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          // settings list tile
          MyDrawerTile(
            text: 'S E T T I N G S',
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(worker: worker),
                ),
              );
            },
          ),
          const Spacer(),
          // logout list tile
          MyDrawerTile(
            text: 'L O G O U T',
            icon: Icons.logout,
            onTap: () async {
              // Clear user data and redirect to login screen
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              // 强制切换回 light mode
              final themeProvider = Provider.of<ThemeProvider>(
                context,
                listen: false,
              );
              themeProvider.themeData = lightMode;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
