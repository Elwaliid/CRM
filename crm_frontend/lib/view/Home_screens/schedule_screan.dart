// ignore_for_file: deprecated_member_use

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:crm_frontend/ustils/constants.dart' as constants;
import 'package:google_fonts/google_fonts.dart';
import '../../models/task_model.dart';
import 'package:intl/intl.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EventController _eventController = EventController();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      _tasks = await Task.getTasks();
      _addTasksToEvents();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  void _addTasksToEvents() {
    for (var task in _tasks) {
      if (task.dueDate != null && task.dueDate!.isNotEmpty) {
        try {
          DateTime date = DateFormat('yyyy-MM-dd').parse(task.dueDate!);

          DateTime startTime;
          if (task.time != null && task.time!.isNotEmpty) {
            DateTime timePart = DateFormat('HH:mm').parse(task.time!);
            startTime = DateTime(
              date.year,
              date.month,
              date.day,
              timePart.hour,
              timePart.minute,
            );
          } else {
            startTime = DateTime(date.year, date.month, date.day, 9, 0);
          }

          DateTime endTime;
          if (task.endTime != null && task.endTime!.isNotEmpty) {
            DateTime timePart = DateFormat('HH:mm').parse(task.endTime!);
            endTime = DateTime(
              date.year,
              date.month,
              date.day,
              timePart.hour,
              timePart.minute,
            );
          } else {
            endTime = startTime.add(const Duration(hours: 1));
          }
          if (endTime.difference(startTime) < const Duration(hours: 1)) {
            endTime = startTime.add(const Duration(hours: 1));
          }
          CalendarEventData event = CalendarEventData(
            date: date,
            startTime: startTime,
            endTime: endTime,
            title: task.title,
            description: task.description,
            color: constants.primaryColor, // use theme color
          );
          _eventController.add(event);
        } catch (e) {
          print('Error parsing task ${task.title}: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            /// prettier TabBar
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: constants.secondaryColor,
                indicator: BoxDecoration(
                  color: constants.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                tabs: [
                  Tab(text: 'Day View'),
                  Tab(text: 'Week View'),
                  Tab(text: 'Month View'),
                ],
              ),
            ),

            Expanded(
              child:
                  /// inside TabBarView
                  TabBarView(
                    controller: _tabController,
                    children: [
                      /// ---- Day View ----
                      DayView(
                        eventTileBuilder: (date, events, boundary, start, end) {
                          final event = events.isNotEmpty ? events[0] : null;
                          if (event == null) return const SizedBox();
                          return _buildEventTile(context, event);
                        },
                      ),

                      /// ---- Week View ----
                      WeekView(
                        eventTileBuilder: (date, events, boundary, start, end) {
                          final event = events.isNotEmpty ? events[0] : null;
                          if (event == null) return const SizedBox();
                          return _buildEventTile(context, event);
                        },
                      ),

                      /// ---- Month View ----
                      MonthView(),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, CalendarEventData event) {
    return GestureDetector(
      onTap: () => _showEventDetails(context, event),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: event.color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, CalendarEventData event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Time: ${DateFormat.Hm().format(event.startTime ?? DateTime.now())} - ${DateFormat.Hm().format(event.endTime ?? DateTime.now())}",
            ),
            if (event.description != null && event.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(event.description!),
            ],
          ],
        ),
      ),
    );
  }
}
