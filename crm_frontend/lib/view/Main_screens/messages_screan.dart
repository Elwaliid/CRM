// ignore_for_file: sized_box_for_whitespace, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message {
  final String sender;
  final String preview;
  final String time;
  Message({required this.sender, required this.preview, required this.time});
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Message> _messages = [
    Message(sender: 'Alice', preview: 'Hey, how are you?', time: '10:30 AM'),
    Message(sender: 'Bob', preview: 'Meeting at 3 PM', time: '9:15 AM'),
    Message(sender: 'Charlie', preview: 'Project update?', time: 'Yesterday'),
    Message(sender: 'Diana', preview: 'Lunch tomorrow?', time: 'Yesterday'),
    Message(sender: 'Eve', preview: 'Check this out!', time: '2 days ago'),
  ];

  List<Message> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    _filteredMessages = _messages;
    _searchController.addListener(_filterMessages);
  }

  void _filterMessages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMessages = _messages
          .where(
            (message) =>
                message.sender.toLowerCase().contains(query) ||
                message.preview.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  void _addMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Message button pressed')));
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                // Title
                Text(
                  'Messages',
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    shadows: const [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search messages',
                    prefixIcon: Icon(Icons.search, color: secondaryColor),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey.shade200,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 41, 49, 53),
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 18, color: primaryColor),
                ),
                const SizedBox(height: 20),
                // Messages list
                Expanded(
                  child: _filteredMessages.isEmpty
                      ? Center(
                          child: Text(
                            'No messages found.',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: secondaryColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredMessages.length,
                          itemBuilder: (context, index) {
                            final message = _filteredMessages[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Text(
                                      message.sender[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.sender,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          message.preview,
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: secondaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    message.time,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Add Message Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addMessage,
                    icon: const Icon(Icons.add, size: 24, color: Colors.white),
                    label: Text(
                      'Add Message',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
