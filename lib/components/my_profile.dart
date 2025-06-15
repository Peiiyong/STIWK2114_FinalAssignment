import 'package:flutter/material.dart';
import 'package:wtms/components/my_profile_tile.dart';
import 'package:wtms/models/worker.dart';

/*
  MyProfile is a widget that displays the profile of a worker, including their
  name, worker ID, and details such as email, phone, and address. 

  It uses the MyProfileTile widget to display each detail and allows the user to 
  edit them by triggering the editDetails function.
*/

class MyProfile extends StatelessWidget {
  final Worker worker; // The worker object containing the profile information
  final void Function(String field) editDetails; // The function to handle editing profile details

  const MyProfile({super.key, required this.worker, required this.editDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
          child: Column(
            children: [
              // Profile icon
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 20),
              // Display worker name with capital letter
              Text(
                worker.fullName.toUpperCase(), 
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  letterSpacing: 3,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 5),
              // Display worker ID
              Text(
                'Worker ID: ${worker.id}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Serif',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Email 
        MyProfileTile(
          title: 'Email',
          text: worker.email,
          icon: const Icon(Icons.email),
          editDetails: editDetails,
        ),
        // Phone
        MyProfileTile(
          title: 'Phone',
          text: worker.phone,
          icon: const Icon(Icons.phone),
          editDetails: editDetails,
        ),
        // Address
        MyProfileTile(
          title: 'Address',
          text: worker.address,
          icon: const Icon(Icons.location_on),
          editDetails: editDetails,
        ),
      ],
    );
  }
}
