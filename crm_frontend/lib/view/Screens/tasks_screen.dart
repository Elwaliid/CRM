// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final String status; // e.g. "Pending", "Completed"

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Task> _tasks = [
    Task(
      title: 'Prepare presentation',
      description: 'Prepare slides for the upcoming client meeting.',
      dueDate: DateTime.now().add(Duration(days: 2)),
      status: 'Pending',
    ),
    Task(
      title: 'Send invoices',
      description: 'Send invoices to clients for last month\'s work.',
      dueDate: DateTime.now().add(Duration(days: 1)),
      status: 'Completed',
    ),
    Task(
      title: 'Update CRM',
      description: 'Update client information in the CRM system.',
      dueDate: DateTime.now().add(Duration(days: 3)),
      status: 'Pending',
    ),
  ];

  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = _tasks;
    _searchController.addListener(_filterTasks);
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _tasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addTask() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Add Task button pressed')));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade600;
      case 'Pending':
      default:
        return Colors.orange.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('lib/images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                // Title
                Text(
                  'Tasks',
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for tasks',
                    prefixIcon: Icon(Icons.search, color: secondaryColor),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey.shade200,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 41, 49, 53),
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 18, color: primaryColor),
                ),
                const SizedBox(height: 20),
                // Task list scrollable
                Expanded(
                  child: _filteredTasks.isEmpty
                      ? Center(
                          child: Text(
                            'No tasks added yet.',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: secondaryColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Task title and status badge
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(task.status),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          task.status,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Task description
                                  Text(
                                    task.description,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Due date
                                  Text(
                                    'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: secondaryColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Add Task Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add, size: 24, color: Colors.white),
                    label: Text(
                      'Add Task',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
