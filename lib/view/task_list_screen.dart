import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:wtms/components/my_button3.dart';
import 'package:wtms/models/submission.dart';
import 'package:wtms/models/task.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/view/submitCompletion_screen.dart';

class TaskListScreen extends StatefulWidget {
  final Worker worker;
  const TaskListScreen({super.key, required this.worker});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> taskList = <Task>[];
  List<Task> filteredTaskList = <Task>[]; 
  String? filterStatus = null;
  List<Submission> submissionList = <Submission>[]; 

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void applyFilter(String? status) {
    setState(() {
      filterStatus = status;
      if (status == null) {
        filteredTaskList = List.from(taskList);
      } else {
        filteredTaskList = taskList.where((t) => t.status == status).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          'TASK LIST',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
            letterSpacing: 5,
            fontFamily: 'Serif',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              fetchTasks();
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onSelected: (value) {
              applyFilter(value == 'all' ? null : value);
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'all', child: Text('All')),
                  PopupMenuItem(value: 'completed', child: Text('Completed')),
                  PopupMenuItem(value: 'submitted', child: Text('Submitted')),
                  PopupMenuItem(value: 'pending', child: Text('Pending')),
                  PopupMenuItem(value: 'overdue', child: Text('Overdue')),
                ],
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: filteredTaskList.isEmpty
            ? Center(
                child: Text(
                  'No tasks found.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Serif',
                  ),
                ),
              )
            : ListView.builder(
                itemCount: filteredTaskList.length,
                itemBuilder: (context, index) {
                  final task = filteredTaskList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.task,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title ?? '',                                        
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).colorScheme.onPrimary,
                                          fontFamily: 'Serif',
                                          //letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Task ID: ${task.id ?? '-'}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Theme.of(context).colorScheme.primary,
                                          fontFamily: 'Serif',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.upload,
                                        color:
                                            Theme.of(context).colorScheme.onPrimary,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => SubmitCompletionScreen(
                                                  task: task,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                task.description ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary.withOpacity(0.85),
                                  fontFamily: 'Serif',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Assigned: ${task.dateAssigned ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontFamily: 'Serif',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.event,
                                    size: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Due: ${task.dueDate ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontFamily: 'Serif',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    size: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).colorScheme.primary,
                                          fontFamily: 'Serif',
                                        ),
                                      ),
                                      Icon(
                                        _getStatusIcon(task.status),
                                        color: _getStatusColor(task.status),
                                      ),
                                      Container(
                                        child: Text(
                                          ' ${task.status?.toUpperCase() ?? '-'}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusColor(task.status),
                                            fontFamily: 'Serif',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              MyButton3(
                                text: 'View',
                                onTap: () => _showSubmission(task),
                                icon: Icon(Icons.visibility),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> fetchTasks() async {
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
      applyFilter(filterStatus); 
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> _showSubmission(Task task) async {
    try {
      var response = await http.post(
        Uri.parse('${Config.server}/get_allsubmit.php'),
        body: {"work_id": task.id.toString()},
      );
      //print('Body: ${response.body}');

      var decoded = jsonDecode(response.body);
      if (decoded['status'] == 'success') {
        var data = decoded['data'];
        submissionList.clear();
        for (var item in data) {
          Submission s = Submission.fromJson(item);
          submissionList.add(s);
        }
        setState(() {});

        if (submissionList.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('All Submissions'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: submissionList.length,
                    itemBuilder: (context, index) {
                      final submission = submissionList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.perm_identity),
                                    Text(
                                      ' Submission ID: ${submission.id ?? '-'}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    Text(
                                      ' ${submission.submittedAt != null ? submission.submittedAt!.split(' ').first : '-'}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.mark_email_read),
                                    Text(
                                      ' Submission Text:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  submission.submissionText ??
                                      'No submission text',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else {
          print("No submission found for this task.");
        }
      } else {
        print("Error fetching submission: ${response.body}");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('No Submission Found'),
              content: Text('No submission found for this task.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error fetching submission: $e');
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'submitted':
        return Colors.amber;
      case 'overdue':
        return Colors.red;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'submitted':
        return Icons.assignment_turned_in;
      case 'overdue':
        return Icons.warning;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }
}
