import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white, // optional aesthetic
      body: Column(
        children: [
          // optional spacing for status bar area
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: 'Day View'),
              Tab(text: 'Week View'),
              Tab(text: 'Month View'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[DayView(), WeekView(), MonthView()],
            ),
          ),
        ],
      ),
    );
  }
}
