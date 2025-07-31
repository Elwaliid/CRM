import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:crm_frontend/constants.dart' as constants;
import 'package:google_fonts/google_fonts.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EventController _eventController =
      EventController(); // ✅ Create the controller

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventController.dispose(); // ✅ Don't forget to dispose it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController, // ✅ Provide the controller
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: constants.primaryColor,
              unselectedLabelColor: constants.secondaryColor,
              indicatorColor: constants.primaryColor,
              tabs: [
                Tab(
                  child: Text(
                    'Day View',
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Week View',
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Month View',
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                ),
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
      ),
    );
  }
}
