import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';

///////////////////////////// date picker helper /////////////////////////////
class DatePickerHelper {
  static Future<DateTime?> showCustomDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(2025),
      lastDate: lastDate ?? DateTime(2075),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueGrey.shade900,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
            dialogBackgroundColor: Colors.white,
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    return pickedDate;
  }
}

/////////////////////////////////////////// time picker helper ///////////////////////////////////////
class TimePickerHelper {
  static Future<void> pickCustomTime({
    required BuildContext context,
    required TextEditingController controller,
    required void Function(TimeOfDay) onTimeSelected,
  }) async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
        sunrise: Time(hour: 5, minute: 20),
        sunset: Time(hour: 19, minute: 55),
        duskSpanInMinutes: 120,
        is24HrFormat: true,
        accentColor: const Color.fromARGB(255, 62, 80, 88),
        okStyle: TextStyle(color: Colors.blueGrey.shade900),
        cancelStyle: TextStyle(color: Colors.blueGrey.shade900),
        onChange: (Time newTime) {
          final timeOfDay = TimeOfDay(
            hour: newTime.hour,
            minute: newTime.minute,
          );
          controller.text = timeOfDay.format(context);
          onTimeSelected(timeOfDay); // extra callback if needed
        },
      ),
    );
  }
}
