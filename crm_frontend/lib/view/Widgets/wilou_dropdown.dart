import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class WilouDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  const WilouDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 38, 44, 48);

    return Material(
      elevation: 3,
      shadowColor: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(12),

      child: DropdownButtonFormField<String>(
        value: value,
        borderRadius: BorderRadius.circular(12),

        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,

            child: Text(
              value,
              style: GoogleFonts.roboto(fontSize: 16, color: primaryColor),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        style: GoogleFonts.roboto(fontSize: 16, color: primaryColor),
        dropdownColor: const Color.fromARGB(255, 248, 248, 248),
        icon: const SizedBox(), // Hide default icon
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: primaryColor.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.blueGrey[50],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 41, 49, 53),
              width: 2.0,
            ),
          ),

          suffixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        ),
      ),
    );
  }
}
