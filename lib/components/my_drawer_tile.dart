import 'package:flutter/material.dart';
/* 
    MyDrawerTile is a reusable custom widget used inside the MyDrawer class.
    It displays a text label and an icon, and performs an action when tapped.
*/
class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        title: Text(
          text, // Display the provided drawer text
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        leading: Icon(
          icon, // Display the provided drawer icon
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: onTap, // Calls the onTap function when user taps the button
      ),
    );
  }
}
