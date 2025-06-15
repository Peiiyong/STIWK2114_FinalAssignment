import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
/*
      MyProfileTile is a reusable widget used to display individual 
      profile fields (e.g., Email, Phone, Address) with an edit option via Slidable.
*/
class MyProfileTile extends StatelessWidget {
  final String title;
  final String text;
  final Icon icon;
  final void Function(String field) editDetails;

  const MyProfileTile({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    required this.editDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                editDetails(title); // Trigger the edit function when the edit button is tapped
              },
              backgroundColor: Colors.grey.shade800,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon.icon, color: Colors.white), // Icon representing the profile field
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, // Display the title of the profile field, (e.g., Email, Phone, Address)
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text, // Display the worker's info (e.g., xxx@example.com, 0123456789, UUM(Sintok))
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
