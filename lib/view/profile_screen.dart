import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/components/my_profile.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';

class ProfileScreen extends StatefulWidget {
  final Worker worker;
  const ProfileScreen({super.key, required this.worker, });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
            letterSpacing: 5,
            fontFamily: 'Serif',
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        centerTitle: true,
      ),
      body: MyProfile(
        worker: widget.worker,
        editDetails: (String field) {
          editDetailsBox(field);
        },
      ),
    );
  }

  // Function to display a dialog for editing profile fields
  void editDetailsBox(String field) {
    final TextEditingController _controller = TextEditingController();

    // Pre-fill the current field value
    if (field == 'Email') {
      _controller.text = widget.worker.email;
    } else if (field == 'Phone') {
      _controller.text = widget.worker.phone;
    } else if (field == 'Address') {
      _controller.text = widget.worker.address;
    }

    // Email validation function
    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    // Phone validation function
    bool isValidPhone(String phone) {
      return (phone.length > 9 && phone.length < 12) &&
          RegExp(r'^[0-9]+$').hasMatch(phone);
    }

    // Show input dialog for editing
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter new $field',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType:
                field == 'Phone' ? TextInputType.phone : TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newValue = _controller.text;
                if (newValue.isNotEmpty) {
                  // Validate email if the field is 'Email'
                  if (field == 'Email' && !isValidEmail(newValue)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Invalid email format',
                          style: TextStyle(fontFamily: 'Serif'),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Stop further execution if email is invalid
                  }

                  // Validate phone if the field is 'Phone'
                  if (field == 'Phone' && !isValidPhone(newValue)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Phone number must be at least 10 digits, at most 11 digits and contain only numbers',
                          style: TextStyle(fontFamily: 'Serif'),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Stop further execution if phone is invalid
                  }

                  // Call the server to update the worker details (call updateWorkerDetails() method )
                  bool success = await updateWorkerDetails(
                    int.parse(widget.worker.id),
                    field.toLowerCase(),
                    newValue,
                  );

                  if (success) {
                    // Update the UI only if the server update is successful
                    setState(() {
                      if (field == 'Email') {
                        widget.worker.email = newValue;
                      } else if (field == 'Phone') {
                        widget.worker.phone = newValue;
                      } else if (field == 'Address') {
                        widget.worker.address = newValue;
                      }
                    });

                    // Update worker details in SharedPreferences
                    SharedPreferences.getInstance().then((prefs) {
                      Worker updatedWorker = widget.worker;
                      prefs.setString(
                        'worker',
                        json.encode(updatedWorker.toJson()),
                      );
                    });
                    Navigator.pop(context); // Close the dialog
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Sends update request to the server and returns success status using POST
  Future<bool> updateWorkerDetails(
    int workerId,
    String field,
    String newValue,
  ) async {
    final url = Uri.parse('${Config.server}/update_worker.php');

    // Log the request data
    print('Sending request to $url');
    print('worker_id: $workerId, field: $field, new_value: $newValue');

    final response = await http.post(
      url,
      body: {
        'worker_id': workerId.toString(),
        'field': field,
        'new_value': newValue,
      },
    );

    // Log the response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Check if the response is successful
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // Edit Success
      if (data['success']) {
        print('Worker details updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Worker details updated successfully',
              style: TextStyle(fontFamily: 'Serif'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        return true; // Update successful
      } else {
        // Edit failed
        print('Failed to update worker details.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'], // Show the error message from the server
              style: const TextStyle(fontFamily: 'Serif'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return false; // Update failed
      }
    } else {
      // Server error
      print('Error! Server returned status code ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error! Failed to connect to the server.',
            style: TextStyle(fontFamily: 'Serif'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Update failed
    }
  }
}
