import 'package:calendar_view/calendar_view.dart';
import 'package:crm_frontend/view/Widgets/date_time_picker.dart';
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
                children: <Widget>[
                  DayView(),
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

class CustomDayView extends StatefulWidget {
  const CustomDayView({super.key});

  @override
  State<CustomDayView> createState() => _CustomDayViewState();
}

class CustomDayViewState extends StatefulWidget {
  const CustomDayViewState({super.key});
  @override
  _CustomDayViewState createState() => _CustomDayViewState();
}

class _CustomDayViewState extends State<CustomDayView> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await DatePickerHelper.showCustomDatePicker(
              context: context,
              initialDate: _selectedDay,
            );
            if (picked != null)
              setState(() {
                _selectedDay = picked;
              });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Center(
              child: Text(
                '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: DayView(
            initialDay: _selectedDay,
            controller: CalendarControllerProvider.of(context).controller,
          ),
        ),
      ],
    );
  }
}

class CustomWeekView extends StatefulWidget {
  const CustomWeekView({super.key});

  @override
  State<CustomWeekView> createState() => _CustomWeekViewState();
}

class _CustomWeekViewState extends State<CustomWeekView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await DatePickerHelper.showCustomDatePicker(
              context: context,
              initialDate: _selectedDate,
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Center(
              child: Text(
                '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: WeekView(
            initialDay: _selectedDate,
            controller: CalendarControllerProvider.of(context).controller,
          ),
        ),
      ],
    );
  }
}

class CustomMonthView extends StatefulWidget {
  const CustomMonthView({super.key});

  @override
  State<CustomMonthView> createState() => _CustomMonthViewState();
}

class _CustomMonthViewState extends State<CustomMonthView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await DatePickerHelper.showCustomDatePicker(
              context: context,
              initialDate: _selectedDate,
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Center(
              child: Text(
                '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: MonthView(
            initialMonth: _selectedDate,
            controller: CalendarControllerProvider.of(context).controller,
          ),
        ),
      ],
    );
  }
}
