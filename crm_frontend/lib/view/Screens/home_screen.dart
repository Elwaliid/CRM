// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:crm_frontend/view/Home_screens/dashboard_screen.dart';
import 'package:crm_frontend/view/Home_screens/schedule_screan.dart';
import 'package:crm_frontend/view/Home_screens/profile_screen.dart';
import 'package:crm_frontend/view/Home_screens/tasks_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../Home_screens/contacts_screen.dart'; // Import ClientsScreen

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({@required this.token, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String email;
  @override
  void initState() {
    super.initState();
    // You can use widget.token here if needed

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    print(email);
  }

  final List<String> screenTitles = [
    'Dashboard',
    'Clients',
    'Tasks',
    'Schedules',
    'Profile',
  ];
  final List<Widget> screens = [
    const DashboardScreen(),
    const ContactsScreen(),
    const TasksScreen(),
    const SchedulesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: screens[_selectedIndex],

      //////////////////////////////////////////////////////////////  Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[900],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueGrey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
