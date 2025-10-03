// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, prefer_final_fields

import 'package:crm_frontend/ustils/config.dart';
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

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailSubjectController = TextEditingController();
  final TextEditingController _emailBodyController = TextEditingController();
  final List<Task> _tasks = [];
  List<Task> _Tasks = [];
  List<Contact> _contacts = [];
  String? _selectedRelatedToName;
  String? _selectedPhoneNumber;
  String? _selectedEmail;
  List<String> _emailAddresses = [];
  List<String> _phoneNumbers = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _searchController.addListener(_filterTasks);
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await Task.getTasks();
      setState(() {
        _tasks.clear();
        _tasks.addAll(tasks);
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
    setState(() {
      _Tasks = _tasks
          .where((task) => task.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailSubjectController.dispose();
    _emailBodyController.dispose();
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
                                                  content: Text('Edit task...'),
                                                ),
                                              );
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
                                    // ///////////////////////////////////////////// Assigned to
                                    Text(
                                      'Related to: ${task.relatedToNames.join(', ')}',
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
                                        ///////////////////////////////////////////////////////// Task icons
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

  //////////////////////////////////////////////////////////// Call or Message dialog
  void _callMessageEmail(Task task, String action) {
    _selectedRelatedToName = null;
    _selectedPhoneNumber = null;
    _selectedEmail = null;
    _phoneNumbers = [];
    _emailAddresses = [];
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
                        : 'Select Contact and Phone',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  SizedBox(height: 16),
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
                  WilouDropdown(
                    label: action == 'Email' ? 'Emails' : 'Phone Numbers',
                    value: action == 'Email'
                        ? _selectedEmail
                        : _selectedPhoneNumber,
                    items: action == 'Email' ? _emailAddresses : _phoneNumbers,
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
                                _selectedEmail != null
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
                                  _emailSubjectController.clear();
                                  _emailBodyController.clear();
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
                                                  'Compose Email',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    labelText: 'To',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  controller:
                                                      TextEditingController(
                                                        text: _selectedEmail,
                                                      ),
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      _emailSubjectController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Subject',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      _emailBodyController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Body',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  maxLines: 5,
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        sendEmail(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Send'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
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
                              }
                            : null,
                        child: Text(
                          action == 'call'
                              ? 'Call'
                              : action == 'Message'
                              ? 'Message'
                              : 'Email',
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

  //////////////////////////////////////// send email function
  sendEmail(BuildContext context) async {
    String receiverMail = _selectedEmail ?? ''; // receiver's mail
    String sub = _emailSubjectController.text; // subject of mail
    String text = _emailBodyController.text; // text in mail

    try {
      final response = await http.post(
        Uri.parse(sendEmailUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"to": "$receiverMail", "subject": "$sub", "text": "$text"}',
      );

      if (response.statusCode == 200) {
        print('Email sent successfully');
        Get.snackbar(
          'Success',
          'Email Sent Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 116, 148, 117),
          colorText: Colors.white,
        );
      } else {
        print('Failed to send email: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to send email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 134, 93, 90),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error sending email: $e');
      Get.snackbar(
        'Error',
        'Error sending email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
