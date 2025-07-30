// ignore_for_file: sized_box_for_whitespace, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _SchedulesScreenState extends State<SchedulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
