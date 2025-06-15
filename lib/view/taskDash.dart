import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/models/task.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/view/task_list_screen.dart';

class TaskDash extends StatefulWidget {
  final Worker worker;
  const TaskDash({super.key, required this.worker});

  @override
  State<TaskDash> createState() => _TaskDashState();
}

class _TaskDashState extends State<TaskDash> {
  List<Task> taskList = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse('${Config.server}/get_works.php'),
        body: {"worker_id": widget.worker.id.toString()},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        taskList.clear();
        for (var item in data) {
          Task t = Task.fromJson(item);
          taskList.add(t);
        }
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  int get totalTasks => taskList.length;
  int get completedTasks =>
      taskList.where((t) => t.status == 'completed').length;
  int get overdueTasks => taskList.where((t) => t.status == 'overdue').length;
  int get submittedTasks =>
      taskList.where((t) => t.status == 'submitted').length;
  int get pendingTasks => taskList.where((t) => t.status == 'pending').length;

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
              width: 450,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TaskListScreen(worker: widget.worker),
                    ),
                  ).then((_) => fetchTasks());
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Task Dashboard',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontFamily: 'Serif',
                              ),
                            ),

                            // icon refresh
                            IconButton(
                              icon: Icon(Icons.refresh, 
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary),
                              onPressed: fetchTasks,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 5),
                            _buildStat('Total', totalTasks, Colors.blue),
                            SizedBox(width: 30),

                            _buildStat(
                              'Completed',
                              completedTasks,
                              Colors.green,
                            ),
                            SizedBox(width: 25),
                            _buildStat(
                              'Submitted',
                              submittedTasks,
                              Colors.amber,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStat('Overdue', overdueTasks, Colors.red),
                            SizedBox(width: 30),
                            _buildStat('Pending', pendingTasks, Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Serif',
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color, fontFamily: 'Serif'),
        ),
      ],
    );
  }
}
