import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/models/submission.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/view/history_screen.dart';

class Historydash extends StatefulWidget {
  final Worker worker;
  const Historydash({super.key, required this.worker});

  @override
  State<Historydash> createState() => _HistorydashState();
}

class _HistorydashState extends State<Historydash> {
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
    try {
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
    } catch (e) {
      print('Error fetching submissions: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  int get totalSubmissions => submissionList.length;

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
                          (context) => HistoryScreen(worker: widget.worker),
                    ),
                  ).then((_) => fetchSubmissions());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 100,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Submission',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontFamily: 'Serif',
                                  ),
                                ),
                                const SizedBox(width: 50,),
                                IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  onPressed: fetchSubmissions,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _buildStat(
                              'Total Submissions',
                              totalSubmissions,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Recent Submissions:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    submissionList.isEmpty
                        ? Text(
                          'No submissions yet.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontFamily: 'Serif',
                          ),
                        )
                        : SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: submissionList.length,
                            itemBuilder: (context, index) {
                              final submission = submissionList[index];
                              return Card(
                                color: Theme.of(context).colorScheme.background,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.assignment_turned_in,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    'Work ID: ${submission.workId ?? '-'}',
                                    style: TextStyle(
                                      fontFamily: 'Serif',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    submission.submissionText != null
                                        ? (submission.submissionText!.length >
                                                30
                                            ? submission.submissionText!
                                                    .substring(0, 30) +
                                                '...'
                                            : submission.submissionText!)
                                        : '',
                                    style: TextStyle(fontFamily: 'Serif'),
                                  ),
                                  trailing: Text(
                                    submission.submittedAt != null
                                        ? submission.submittedAt!
                                            .split(' ')
                                            .first
                                        : '-',
                                    style: TextStyle(fontFamily: 'Serif'),
                                  ),
                                ),
                              );
                            },
                          ),
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
