import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
  MySettingsTile is a custom widget used to display a setting option in the settings screen. 
  It includes an icon, title, and optionally, a switch for toggling a setting.
  The widget can also respond to taps, allowing actions to be performed when the user interacts with it.
*/
class MySettingsTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool hasSwitch;
  final bool switchValue;
  final Function(bool)? onToggle;
  final VoidCallback? onTap; 

  const MySettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.hasSwitch = false, // Defaults to false, meaning no switch is displayed
    this.switchValue =
        false, // Defaults to false, meaning the switch is off by default
    this.onToggle, // Optional, will only be used if hasSwitch is true
    this.onTap, // Optional, used if a tap action is required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon representing the setting field
              Icon(
                icon.icon,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 30,
              ),
              // Display the title of the setting field (e.g., Dark Mode, Reset Password)
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontFamily: 'Serif',
                  fontSize: 18,
                ),
              ),
              // If the switch is enabled, display the CupertinoSwitch
              if (hasSwitch)
                CupertinoSwitch(
                  value: switchValue,
                  onChanged: onToggle,
                ),
              // If no switch and onTap is provided, show right arrow
              if (!hasSwitch && onTap != null)
                GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 24,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
