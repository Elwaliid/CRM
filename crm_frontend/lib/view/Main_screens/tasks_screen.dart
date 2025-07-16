// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:crm_frontend/view/Sub_screens/add_update_Task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class Task {
  final String title;
  final String description;
  final String dueDate;
  final String assignedTo;
  final String status;
  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.assignedTo,
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
      title: 'Follow Up Call',
      description: 'Call client to confirm meeting',
      dueDate: '2025-07-14',
      assignedTo: 'Mouh',
      status: 'In Process',
    ),
    Task(
      title: 'Prepare Proposal',
      description: 'Create proposal for new lead',
      dueDate: '2025-07-15',
      assignedTo: 'Ibrahim',
      status: 'Completed',
    ),
    Task(
      title: 'Update CRM',
      description: 'Enter notes from last call',
      dueDate: '2025-07-16',
      assignedTo: 'Khalti',
      status: 'Pending',
    ),
    Task(
      title: 'Schedule Meeting',
      description: 'Book meeting with Sid Ahmed',
      dueDate: '2025-07-17',
      assignedTo: 'Sid Ahmed',
      status: 'Pending',
    ),
    Task(
      title: 'Send Email',
      description: 'Follow-up email to Cheb',
      dueDate: '2025-07-18',
      assignedTo: 'Cheb',
      status: 'In Process',
    ),
    Task(
      title: 'Review Notes',
      description: 'Review notes before call',
      dueDate: '2025-07-19',
      assignedTo: 'Fatiha',
      status: 'Completed',
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
      _filteredTasks = _tasks
          .where((task) => task.title.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addTask() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Add Task button pressed')));
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                ///////////////////////////////////////////////////////////////////////////// Title
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
                ///////////////////////////////////////////////////////////////////////////// Search Bar
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
                ////////////////////////////////////////////////////////////// task list scrollable
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
                            ///////////////////////////////////////////////////////////////////////////// Task card

                            return GestureDetector(
                              onTap: () {
                                Get.to(AddUpdateTaskScreen());
                                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 12,
                                  bottom: 0,
                                ),
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
                                    Row(
                                      children: [
                                        /////////////////////////////////////////// Task title
                                        Text(
                                          task.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ///////////////////////////////////// Status
                                        Container(
                                          width: 120,
                                          height: 23,
                                          decoration: BoxDecoration(
                                            color: task.status == 'Pending'
                                                ? Colors.deepOrange.shade400
                                                : task.status == 'Completed'
                                                ? Colors.teal.shade700
                                                : task.status == 'In Process'
                                                ? Colors.blueGrey.shade900
                                                : Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            task.status,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        PopupMenuButton<String>(
                                          color: Colors.white,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: secondaryColor,
                                          ),
                                          onSelected: (selected) {
                                            if (selected == 'edit') {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Edit task: ${task.title}',
                                                  ),
                                                ),
                                              );
                                            } else if (selected == 'delete') {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Delete task: ${task.title}',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              [
                                                PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: primaryColor,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              126,
                                                              2,
                                                              2,
                                                            ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Due: ${task.dueDate}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Assigned to: ${task.assignedTo}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Description: ${task.description}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                /////////////////////////////////////////////////////////////////////////////////// Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: Icon(Icons.add, size: 24, color: Colors.white),
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
