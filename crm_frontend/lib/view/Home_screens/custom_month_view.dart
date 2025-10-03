import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

typedef EventTileBuilder =
    Widget Function(BuildContext context, CalendarEventData event);

typedef ShowEventDetails =
    void Function(BuildContext context, CalendarEventData event);

class _CustomMonthView extends StatelessWidget {
  final EventController eventController;
  final EventTileBuilder buildEventTile;
  final ShowEventDetails showEventDetails;

  const _CustomMonthView({
    Key? key,
    required this.eventController,
    required this.buildEventTile,
    required this.showEventDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For simplicity, show a grid of days with events as tiles.
    // This is a simplified custom month view.
    final events = eventController.events;

    // Group events by date (year, month, day)
    Map<DateTime, List<CalendarEventData>> eventsByDate = {};
    for (var event in events) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      eventsByDate.putIfAbsent(date, () => []).add(event);
    }

    // Get current month and year
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        final date = DateTime(now.year, now.month, day);
        final dayEvents = eventsByDate[date] ?? [];

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  day.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dayEvents.length,
                  itemBuilder: (context, eventIndex) {
                    final event = dayEvents[eventIndex];
                    return GestureDetector(
                      onTap: () => showEventDetails(context, event),
                      child: buildEventTile(context, event),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
