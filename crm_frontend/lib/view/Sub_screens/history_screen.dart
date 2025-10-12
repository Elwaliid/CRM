import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _MouseDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.trackpad,
  };
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedAgent = 'All';
  @override
  void initState() {
    super.initState();

    _fetchUsers();
  }

  final List<Map<String, String>> historyData = [
    {
      'agent': 'Samir',
      'action': 'created a client named Waheb',
      'time': '2025-10-10 14:30',
    },
    {
      'agent': 'Sami',
      'action': 'set task "Pay Hamed 500\$" status to Completed',
      'time': '2025-10-10 15:45',
    },
    {
      'agent': 'Samir',
      'action': 'deleted client named Karim',
      'time': '2025-10-10 16:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredHistory = selectedAgent == 'All'
        ? historyData
        : historyData.where((e) => e['agent'] == selectedAgent).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'History',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ScrollConfiguration(
                  behavior: _MouseDragScrollBehavior(),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      userNames.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(userNames[index].substring(0, 3)),
                          selected: _currentUserIndex == index,
                          onSelected: (selected) {
                            if (selected) {
                              _onUserhanged(index);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🧾 History List
            Expanded(
              child: ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final item = filteredHistory[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Agent Avatar
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey[100],
                          child: Text(
                            item['agent']![0],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: item['agent']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const TextSpan(text: ' '),
                                    TextSpan(text: item['action']!),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  item['time']!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
