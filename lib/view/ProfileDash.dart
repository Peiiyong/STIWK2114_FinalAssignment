import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/view/profile_screen.dart';

class Profiledash extends StatefulWidget {
  final Worker worker;
  const Profiledash({super.key, required this.worker});

  @override
  State<Profiledash> createState() => _ProfiledashState();
}

class _ProfiledashState extends State<Profiledash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 第一行：头像、名字、刷新和编辑按钮
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 头像
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 姓名和ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.worker.fullName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontFamily: 'Serif',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Worker ID: ${widget.worker.id}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'Serif',
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            fetchProfile();
                          });
                        },
                      ),
                      // 编辑按钮
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProfileScreen(worker: widget.worker),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 详细信息
                  _ProfileInfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: widget.worker.email,
                  ),
                  _ProfileInfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: widget.worker.phone,
                  ),
                  _ProfileInfoRow(
                    icon: Icons.location_on,
                    label: 'Address',
                    value: widget.worker.address,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> fetchProfile() async {
    var response = await http.post(
      Uri.parse('${Config.server}/get_profile.php'),
      body: {"worker_id": widget.worker.id.toString()},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Assuming the response contains the worker profile as a JSON object
      setState(() {
        widget.worker.email = data['email'];
        widget.worker.phone = data['phone'];
        widget.worker.address = data['address'];
        // Add other fields as needed
      });
      print("Profile updated from server.");
    } else {
      print("Error fetching profile: ${response.statusCode}");
    }
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Serif',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'Serif',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
