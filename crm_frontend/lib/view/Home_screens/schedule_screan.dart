// ignore_for_file: sized_box_for_whitespace, unused_field

import 'package:flutter/material.dart';

class Message {
  final String sender;
  final String preview;
  final String time;
  Message({required this.sender, required this.preview, required this.time});
}

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});
  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Day View'),
            Tab(text: 'Week View'),
            Tab(text: 'Month View'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Day View Content')),
          Center(child: Text('Week View Content')),
          Center(child: Text('Month View Content')),
        ],
      ),
    );
  }
}
