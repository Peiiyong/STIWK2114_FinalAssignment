import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/components/my_drawer.dart';
import 'package:wtms/models/task.dart';
import 'package:wtms/models/worker.dart';
import 'package:wtms/service/config.dart';
import 'package:wtms/view/taskDash.dart';
import 'package:wtms/view/task_list_screen.dart';
import 'package:wtms/view/historyDash.dart';
import 'package:wtms/view/profileDash.dart';

// Home screen showing the worker's profile and allowing edit options
class HomeScreen extends StatefulWidget {
  final Worker worker;
  const HomeScreen({super.key, required this.worker});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> taskList = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    fetchTasks();
    _pages = [
      TaskDash(worker: widget.worker),
      Historydash(worker: widget.worker),
      Profiledash(worker: widget.worker),
    ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          'W T M S',
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

      // Drawer is a side menu that can be opened by swiping from the left or tapping the menu icon
      drawer: MyDrawer(worker: widget.worker),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onPrimary.withOpacity(0.6),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
