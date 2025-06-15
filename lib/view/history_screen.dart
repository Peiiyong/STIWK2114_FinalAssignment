import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/components/my_button3.dart';
import 'package:wtms/models/submission.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';

class HistoryScreen extends StatefulWidget {
  final Worker worker;
  const HistoryScreen({super.key, required this.worker});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Submission> submissionList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
      Uri.parse('${Config.server}/get_submission.php'),
      body: {"worker_id": widget.worker.id.toString()},
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      if (decoded['status'] == 'success') {
        submissionList.clear();
        for (var item in decoded['data']) {
          submissionList.add(Submission.fromJson(item));
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          'HISTORY',
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
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchSubmissions();
            },
            tooltip: 'Refresh',
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : submissionList.isEmpty
                ? Center(
                  child: Text(
                    'No submissions found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontFamily: 'Serif',
                    ),
                  ),
                )
                : ListView.builder(
                  itemCount: submissionList.length,
                  itemBuilder: (context, index) {
                    final submission = submissionList[index];
                    bool isExpanded = false;

                    return StatefulBuilder(
                      builder:
                          (context, setInnerState) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: Theme.of(context).colorScheme.tertiary,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.history,
                                        size: 48,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              submission.taskTitle ??
                                                  'Task Title',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onPrimary,
                                                fontFamily: 'Serif',
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                // icon
                                                Icon(
                                                  Icons.assignment,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary
                                                      .withOpacity(0.7),
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  ' Submission ID: ${submission.id ?? '-'}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                    fontFamily: 'Serif',
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                // icon date
                                                Icon(
                                                  Icons.date_range,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary
                                                      .withOpacity(0.7),
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  ' Submitted on: ${submission.submittedAt?.split(' ').first ?? '-'}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                    fontFamily: 'Serif',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                        onPressed: () {
                                          setInnerState(() {
                                            isExpanded = !isExpanded;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 10),
                                    Divider(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    Row(
                                      children: [
                                        // icon
                                        Icon(
                                          Icons.type_specimen,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withOpacity(0.7),
                                        ),
                                        // text
                                        Text(
                                          ' Submission Text:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.85),
                                            fontFamily: 'Serif',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      submission.submissionText ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                            .withOpacity(0.85),
                                        fontFamily: 'Serif',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // edit button
                                    MyButton3(
                                      text: 'Edit',
                                      onTap: () {
                                        showEditDialog(context, submission, (
                                          newText,
                                        ) {
                                          setState(() {
                                            submission.submissionText = newText;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                    );
                  },
                ),
      ),
    );
  }

  void showEditDialog(
    BuildContext context,
    Submission submission,
    Function(String) onSave,
  ) {
    final TextEditingController _controller = TextEditingController(
      text: submission.submissionText ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Submission'),
          content: TextField(
            controller: _controller,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Edit your submission',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog before saving
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Update'),
                        content: const Text(
                          'Are you sure you want to overwrite your submission?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close confirmation
                              Navigator.pop(context); // Close edit dialog
                              editSubmission(submission.id!, _controller.text);
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editSubmission(int submissionId, String newText) async {
    final response = await http.post(
      Uri.parse('${Config.server}/edit_submission.php'),
      body: {'submission_id': submissionId.toString(), 'updated_text': newText},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submission updated!'),
          backgroundColor: Colors.green,
        ),
      );
      // Optionally refresh your list here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Update failed.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
