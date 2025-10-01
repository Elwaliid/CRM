// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_null_comparison

import 'package:crm_frontend/view/Sub_screens/Task_Details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _searchController.addListener(_filterTasks);
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await Task.fetchTasks();
      setState(() {
        _tasks.clear();
        _tasks.addAll(tasks);
        _filteredTasks = _tasks;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _tasks
          .where((task) => task.title.toLowerCase().contains(query))
          .toList();
    });
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
                                Get.to(TaskDetailsScreen(task: task));
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
                                        //////////////////////////////////////// 3 Dots menu
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
                                    /////////////////////////////////////////////// Due Date
                                    Text(
                                      'Due: ${task.dueDate}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    // ///////////////////////////////////////////// Assigned to
                                    Text(
                                      'Assigned to: ${task.relatedTo.join(', ')}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    /////////////////////////////////////////// Description
                                    Row(
                                      children: [
                                        Text(
                                          'Description: ${task.description}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: primaryColor,
                                          ),
                                        ),
                                        Spacer(),
                                        // Task type icons
                                        ////////////////////////// call and message
                                        if (task.type == 'Call')
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () {},
                                            icon: Icon(Icons.call),
                                          ),
                                        if (task.type == 'Call')
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () {},
                                            icon: Icon(Icons.message),
                                          ),
                                        ///////////////////////////////////////////// Email
                                        if (task.type == 'Email')
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () {},
                                            icon: Icon(Icons.email),
                                          ),
                                        ///////////////////////////////////////////// Deal
                                        if (task.type == 'Deal')
                                          PopupMenuButton<String>(
                                            color: Colors.white,
                                            icon: Icon(
                                              Icons.business,
                                              color: secondaryColor,
                                            ),

                                            itemBuilder: (BuildContext context) => [
                                              PopupMenuItem<String>(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 12),
                                                    Text(
                                                      'Revenue: ${task.revenue}',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            GoogleFonts.roboto(
                                                              color:
                                                                  primaryColor,
                                                            ).fontStyle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      'DZD',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            GoogleFonts.roboto(
                                                              color:
                                                                  primaryColor,
                                                            ).fontStyle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons.trending_up,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            75,
                                                            138,
                                                            91,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 12),
                                                    Text(
                                                      'Cost: ${task.cost}',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            GoogleFonts.roboto(
                                                              color:
                                                                  primaryColor,
                                                            ).fontStyle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      'DZD',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            GoogleFonts.roboto(
                                                              color:
                                                                  primaryColor,
                                                            ).fontStyle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons.trending_down,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            126,
                                                            2,
                                                            2,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ///////////////////////////////////////////// meeting
                                        if (task.type == 'Meeting')
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () {},
                                            icon: Icon(Icons.group),
                                          ),
                                        ///////////////////////////////////////////// None
                                        if (task.type == '')
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () {},
                                            icon: Icon(Icons.task_alt),
                                          ),
                                      ],
                                    ),
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
                    onPressed: () {
                      Get.to(TaskDetailsScreen());
                    },
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
