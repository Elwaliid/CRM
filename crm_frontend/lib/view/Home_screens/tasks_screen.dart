// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, prefer_final_fields

import 'dart:convert';

import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/ustils/email_utils.dart';
import 'package:crm_frontend/ustils/user_utils.dart';
import 'package:crm_frontend/view/Sub_screens/Task_Details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../models/task_model.dart';
import '../../models/contact_model.dart';
import '../Widgets/wilou_dropdown.dart';
import '../Widgets/wilou_searchable_dropdown.dart';
import '../Widgets/wilou_textfield.dart';

class TasksScreen extends StatefulWidget {
  final String? userId;
  final String? token;
  const TasksScreen({super.key, this.userId, this.token});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailSubjectController = TextEditingController();
  final TextEditingController _emailBodyController = TextEditingController();

  final TextEditingController _filterDueDateController =
      TextEditingController();
  final List<Task> _tasks = [];
  List<Task> _Tasks = [];
  List<Contact> _contacts = [];
  String? _selectedRelatedToName;
  String? _selectedPhoneNumber;
  String? _selectedEmail;
  String? _meeting_web_Url;
  String? id;
  bool meeting = false;
  List<String> _emailAddresses = [];
  List<String> _phoneNumbers = [];
  String? _selectedStatus;

  String? userId;
  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchTasks();
    _searchController.addListener(_filterTasks);
  }

  Future<void> _loadUserId() async {
    userId = await UserUtils.loadUserId();
    setState(() {});
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await Task.getTasks();
      setState(() {
        _tasks.clear();
        _tasks.addAll(tasks);
        _tasks.sort(
          (a, b) => (b.isPined ?? false ? 1 : 0).compareTo(
            a.isPined ?? false ? 1 : 0,
          ),
        );
        _Tasks = _tasks;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    try {
      List<Contact> contacts = await Contact.getContacts();
      setState(() {
        _contacts.clear();
        _contacts.addAll(contacts);
      });
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    final dueDateQuery = _filterDueDateController.text.toLowerCase();
    setState(() {
      _Tasks = _tasks.where((task) {
        bool matches = true;
        if (query.isNotEmpty) {
          matches &= task.title.toLowerCase().contains(query);
        }
        if (dueDateQuery.isNotEmpty) {
          matches &=
              task.dueDate?.toLowerCase().contains(dueDateQuery) ?? false;
        }
        if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
          matches &= task.status == _selectedStatus;
        }
        return matches;
      }).toList();
      _Tasks.sort(
        (a, b) =>
            (b.isPined ?? false ? 1 : 0).compareTo(a.isPined ?? false ? 1 : 0),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailSubjectController.dispose();
    _emailBodyController.dispose();
    _filterDueDateController.dispose();
    super.dispose();
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: _showFilterDialog,
                      icon: Icon(Icons.filter),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ////////////////////////////////////////////////////////////// task list scrollable
                Expanded(
                  child: _Tasks.isEmpty
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
                          itemCount: _Tasks.length,
                          itemBuilder: (context, index) {
                            final task = _Tasks[index];
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
                                        task.title.length <= 19
                                            ? Text(
                                                task.title,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor,
                                                ),
                                              )
                                            : ((task.title.length > 19) &&
                                                  (task.isPined ?? false))
                                            ? Row(
                                                children: [
                                                  Text(
                                                    task.title.substring(0, 13),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "...",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    task.title.substring(0, 15),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "...",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                ],
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
                                        if (task.isPined ?? false)
                                          Icon(
                                            Icons.push_pin,
                                            color: primaryColor,
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
                                            if (selected == 'Pin') {
                                              bool newPinned =
                                                  !(task.isPined ?? false);
                                              _pined(newPinned, task.id!);
                                            } else if (selected == 'delete') {
                                              ////// delete contact
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Delete Task'),
                                                    content: Text(
                                                      'Are you sure you want to delete ${task.title} ?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            _Tasks.removeAt(
                                                              index,
                                                            );
                                                          });
                                                          final response =
                                                              await http.delete(
                                                                Uri.parse(
                                                                  deleteTaskUrl,
                                                                ),
                                                                headers: {
                                                                  'Content-Type':
                                                                      'application/json',
                                                                },
                                                                body:
                                                                    '{"id": "${task.id}"}',
                                                              );
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  '${task.title}  deleted',
                                                                ),
                                                              ),
                                                            );
                                                            _fetchTasks();
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Failed to delete ${task.title} ',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  126,
                                                                  2,
                                                                  2,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) => [
                                            ////////////////////////////// edit icon button
                                            PopupMenuItem<String>(
                                              value: 'Pin',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.push_pin,
                                                    color: primaryColor,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    task.isPined ?? false
                                                        ? 'Unpin'
                                                        : 'Pin',
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ////////////////////////////// delete icon button
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: const Color.fromARGB(
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
                                    // ///////////////////////////////////////////// Related to
                                    Text(
                                      'Related to: ${task.relatedToNames.join(', ')}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                    ),

                                    /////////////////////////////////////////// Description and Task icons
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
                                        //////////////////////////////////////////
                                        ////////////////////////// call and message
                                        if (task.type == 'Call/Message')
                                          Row(
                                            children: [
                                              IconButton(
                                                color: primaryColor,
                                                onPressed: () =>
                                                    _callMessageEmail(
                                                      task,
                                                      'call',
                                                    ),
                                                icon: Icon(Icons.call),
                                              ),
                                              SizedBox(width: 2),
                                              IconButton(
                                                color: primaryColor,
                                                onPressed: () =>
                                                    _callMessageEmail(
                                                      task,
                                                      'Message',
                                                    ),
                                                icon: Icon(Icons.message),
                                              ),
                                            ],
                                          ),

                                        ///////////////////////////////////////////// Email
                                        if (task.type == 'Email')
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () => _callMessageEmail(
                                              task,
                                              'Email',
                                            ),
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
                                            //////////
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
                                        ///////////////////////////////////////////// Meeting/Site Visit
                                        if (task.type == 'Meeting/Site Visit' &&
                                            task.isMeet == false)
                                          IconButton(
                                            color: primaryColor,
                                            onPressed: () => _callMessageEmail(
                                              task,
                                              'Meeting/Site Visit',
                                            ),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WilouTextField(
                label: 'Search for tasks',
                controller: _searchController,
                icon: Icons.search,
              ),
              SizedBox(height: 16),
              WilouTextField(
                label: 'Due date',
                controller: _filterDueDateController,
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 16),
              WilouDropdown(
                label: 'Status',
                value: _selectedStatus,
                items: ['Pending', 'Completed', 'In Process'],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                icon: Icons.info,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _filterTasks();
                Navigator.of(context).pop();
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  //////////////////////////////////////////////////////////// Call or Message dialog
  void _callMessageEmail(Task task, String action) {
    _selectedRelatedToName = null;
    _selectedPhoneNumber = null;
    _selectedEmail = null;
    _phoneNumbers = [];
    _emailAddresses = [];
    if (action == 'Meeting/Site Visit') {
      _meeting_web_Url = task.website;
      meeting = task.isMeet;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    action == 'Email'
                        ? 'Select Contact and Email'
                        : action == 'Meeting/Site Visit' && meeting
                        ? 'Meeting URL'
                        : action == 'Meeting/Site Visit' && !meeting
                        ? 'Visit Website'
                        : 'Select Contact and Phone',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  if (action != 'Meeting/Site Visit')
                    WilouSearchableDropdown(
                      label: 'Related To(Contact)',
                      value: _selectedRelatedToName,
                      items: task.relatedToNames,
                      onChanged: (value) {
                        setState(() {
                          _selectedRelatedToName = value;
                          _selectedPhoneNumber = null;
                          _selectedEmail = null;
                          if (value != null) {
                            int index = task.relatedToNames.indexOf(value);
                            if (index != -1 &&
                                task.relatedToIds != null &&
                                index < task.relatedToIds!.length) {
                              String id = task.relatedToIds![index];
                              Contact? contact = _contacts.firstWhere(
                                (c) => c.id == id,
                                orElse: () => Contact(
                                  id: '',
                                  firstname: '',
                                  lastname: '',
                                  phone: '',
                                  phones: [],
                                  email: '',
                                  identity: '',
                                  secondEmail: '',
                                  address: '',
                                  notes: '',
                                  type: '',
                                  website: '',
                                ),
                              );
                              if (contact.id.isNotEmpty) {
                                _emailAddresses = [
                                  contact.email,
                                  contact.secondEmail,
                                ].where((e) => e.isNotEmpty).toList();
                                _phoneNumbers = contact.phones;
                              } else {
                                _emailAddresses = [];
                                _phoneNumbers = [];
                              }
                            }
                          } else {
                            _emailAddresses = [];
                            _phoneNumbers = [];
                          }
                        });
                      },
                      icon: Icons.person,
                    ),
                  SizedBox(height: 16),
                  if (action == 'Meeting/Site Visit')
                    InkWell(
                      onTap: _meeting_web_Url != null
                          ? () => launchUrl(Uri.parse(_meeting_web_Url!))
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.blueGrey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.web, color: Colors.blueGrey.shade900),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Website: ${_meeting_web_Url ?? 'No website available'}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: _meeting_web_Url != null
                                      ? Colors.blue
                                      : Colors.blueGrey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    WilouDropdown(
                      label: action == 'Email' ? 'Emails' : 'Phone Numbers',
                      value: action == 'Email'
                          ? _selectedEmail
                          : _selectedPhoneNumber,
                      items: action == 'Email'
                          ? _emailAddresses
                          : _phoneNumbers,
                      onChanged: (value) {
                        setState(() {
                          action == 'Email'
                              ? _selectedEmail = value
                              : _selectedPhoneNumber = value;
                        });
                      },
                      icon: action == 'Email' ? Icons.email : Icons.phone,
                    ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _selectedPhoneNumber != null ||
                                _selectedEmail != null ||
                                (action == 'Meeting/Site Visit' &&
                                    _meeting_web_Url != null)
                            ? () async {
                                if (action == 'call' &&
                                    _selectedPhoneNumber != null) {
                                  await launchUrl(
                                    Uri.parse('tel:$_selectedPhoneNumber'),
                                  );
                                  Navigator.pop(context);
                                } else if (action == 'message' &&
                                    _selectedPhoneNumber != null) {
                                  await launchUrl(
                                    Uri.parse('sms:$_selectedPhoneNumber'),
                                  );
                                  Navigator.pop(context);
                                } else if (action == 'Email' &&
                                    _selectedEmail != null) {
                                  Navigator.pop(context);
                                  showEmailModalBottomSheet(
                                    context,
                                    _selectedEmail!,
                                  );
                                } else {
                                  launchUrl(Uri.parse(_meeting_web_Url!));
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                        child: Text(
                          action == 'call'
                              ? 'Call'
                              : action == 'Message'
                              ? 'Message'
                              : action == 'Email'
                              ? 'Email'
                              : 'Visit Website',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          action == '';
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pined(bool isPined, String id) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('couldnt get user id'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    var logBody = {'owner': userId, 'id': id, 'isPined': isPined};

    try {
      var response = await http.post(
        Uri.parse(addOrUpdateTaskUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(logBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          _fetchTasks(); // Refresh the list to update pin status
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save task. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error. Please try again later.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
