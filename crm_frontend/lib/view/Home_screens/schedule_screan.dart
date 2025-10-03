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
  final EventController _eventController =
      EventController(); // ✅ Create the controller
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
    _eventController.dispose(); // ✅ Don't forget to dispose it
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      _tasks = await Task.getTasks();
      _addTasksToEvents();
    } catch (e) {
      // Handle error, perhaps show a snackbar
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
            startTime = DateTime(
              date.year,
              date.month,
              date.day,
              9,
              0,
            ); // Default to 9 AM
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
            endTime = startTime.add(
              Duration(hours: 1),
            ); // Default to 1 hour later
          }
          CalendarEventData event = CalendarEventData(
            date: date,
            startTime: startTime,
            endTime: endTime,
            title: task.title,
            description: task.description,
            color: constants.primaryColor, // use theme colors
          );
          _eventController.add(event);
        } catch (e) {
          print('Error parsing task ${task.title}: $e');
        }
      }
    }
  }

  //
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
              labelColor: Colors.white,
              unselectedLabelColor: constants.secondaryColor,
              indicator: BoxDecoration(
                color: constants.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              tabs: [
                Tab(text: "Day View"),
                Tab(text: "Week View"),
                Tab(text: "Month View"),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  DayView(
                    eventTileBuilder: (date, events, boundry, start, end) {
                      final event = events.first;

                      return Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: event.color.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
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
                            const SizedBox(height: 2),
                            Text(
                              "${DateFormat.Hm().format(event.startTime ?? DateTime.now())} - ${DateFormat.Hm().format(event.endTime ?? DateTime.now().add(Duration(hours: 1)))}",
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            if (event.description != null &&
                                event.description!.isNotEmpty)
                              Text(
                                event.description!,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const WeekView(),
                  const MonthView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
