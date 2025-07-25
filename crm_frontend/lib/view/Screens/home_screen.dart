import 'dart:ui';

import 'package:crm_frontend/view/Main_screens/dashboard_screen.dart';
import 'package:crm_frontend/view/Main_screens/messages_screan.dart';
import 'package:crm_frontend/view/Main_screens/profile_screen.dart';
import 'package:crm_frontend/view/Main_screens/tasks_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../Main_screens/contacts_screen.dart'; // Import ClientsScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  final List<String> screenTitles = [
    'Home',
    'Clients',
    'Tasks',
    'Messages',
    'Profile',
  ];
  final List<Widget> screens = [
    const DashboardScreen(),
    const ContactsScreen(),
    const TasksScreen(),
    const MessagesScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
