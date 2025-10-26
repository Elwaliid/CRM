// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crm_frontend/models/user_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<String> userNames = [];
  List<String> userAvatars = [];
  int _currentUserIndex = 0;
  List<Map<String, dynamic>> usersHistory = [];
  bool isLoading = true;
  bool isSelectionMode = false;
  Set<String> selectedItems = {};
  /////////////////////////////////////////// Date format
  String formatTime(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);
      return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
    } catch (e) {
      return isoString; // Return original if parsing fails
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAgents();
    fetchUsersHistory();
  }

  /////////////////////////////////////////// get agents
  Future<void> fetchAgents() async {
    List<UserModel> agents = await UserModel.fetchAgents();

    List<String> names = agents
        .map((agent) => agent.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    List<String> avatars = agents
        .map((agent) => agent.avatar ?? '')
        .where((avatar) => avatar.isNotEmpty)
        .toList();
    userNames = ['All', ...names];
    userAvatars = ['All', ...avatars];
    setState(() {});
  }

  /////////////////////////////////////////// history data
  Future<void> fetchUsersHistory() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> history = await UserModel.fetchUsersHistory();
    setState(() {
      usersHistory = history;
      isLoading = false;
    });
  }

  void _onUserChanged(int index) {
    setState(() {
      _currentUserIndex = index;
      selectedAgent = userNames[index];
    });
  }

  /////////////////////////////////////////// filter,get all: history
  List<Map<String, dynamic>> getFilteredHistory() {
    if (selectedAgent == 'All') {
      return usersHistory.expand((user) {
        List<String> history = List<String>.from(user['history'] ?? []);
        List<String> historyDate = List<String>.from(user['historyDate'] ?? []);
        Uint8List? decodedAvatar =
            user['avatar'] != null && user['avatar'].isNotEmpty
            ? base64Decode(user['avatar'])
            : null;
        return List.generate(
          history.length,
          (index) => {
            'agent': user['name'] ?? 'Unknown',
            'avatar': decodedAvatar,
            'action': history[index],
            'time': historyDate.length > index ? historyDate[index] : '',
          },
        );
      }).toList();
    } else {
      return usersHistory.where((user) => user['name'] == selectedAgent).expand(
        (user) {
          List<String> history = List<String>.from(user['history'] ?? []);
          List<String> historyDate = List<String>.from(
            user['historyDate'] ?? [],
          );
          Uint8List? decodedAvatar =
              user['avatar'] != null && user['avatar'].isNotEmpty
              ? base64Decode(user['avatar'])
              : null;
          return List.generate(
            history.length,
            (index) => {
              'agent': user['name'] ?? 'Unknown',
              'avatar': decodedAvatar,
              'action': history[index],
              'time': historyDate.length > index ? historyDate[index] : '',
            },
          );
        },
      ).toList();
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(String key) {
    setState(() {
      if (selectedItems.contains(key)) {
        selectedItems.remove(key);
      } else {
        selectedItems.add(key);
      }
    });
  }

  Future<void> _deleteSelectedItems() async {
    if (selectedItems.isEmpty) return;
    // Collect items to delete
    List<Map<String, dynamic>> historyToDelete = [];
    List<Map<String, dynamic>> filteredHistory = getFilteredHistory();

    for (String key in selectedItems) {
      for (var item in filteredHistory) {
        String itemKey = '${item['action']}|${item['time']}';
        if (itemKey == key) {
          historyToDelete.add({'action': item['action'], 'time': item['time']});
          break;
        }
      }
    }

    bool success = await UserModel.deleteHistory(historyToDelete);
    if (success) {
      setState(() {
        selectedItems.clear();
        isSelectionMode = false;
      });
      fetchUsersHistory(); // Refresh the list
    }
  }

  List<TextSpan> _buildActionSpans(String action) {
    final urlRegex = RegExp(r'https?://[^\s]+');
    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final match in urlRegex.allMatches(action)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: action.substring(lastIndex, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final url = match.group(0)!;
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < action.length) {
      spans.add(TextSpan(text: action.substring(lastIndex)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    List<Map<String, dynamic>> filteredHistory = getFilteredHistory();

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
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: selectedItems.isNotEmpty ? _deleteSelectedItems : null,
            ),
          IconButton(
            icon: Icon(isSelectionMode ? Icons.cancel : Icons.select_all),
            onPressed: _toggleSelectionMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            //////////////////////// List of agents
            Container(
              margin: EdgeInsets.only(right: 90.0),
              child: SizedBox(
                height: 30,
                width: 500,
                child: ScrollConfiguration(
                  behavior: _MouseDragScrollBehavior(),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      userNames.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(userNames[index]),
                          selected: _currentUserIndex == index,
                          onSelected: (selected) {
                            if (selected) {
                              _onUserChanged(index);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            // 🧾 History List
            Expanded(
              child: ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final item = filteredHistory[index];
                  String itemKey = '${item['action']}|${item['time']}';
                  bool isSelected = selectedItems.contains(itemKey);
                  return GestureDetector(
                    onLongPress: () {
                      if (!isSelectionMode) {
                        _toggleSelectionMode();
                        _toggleItemSelection(itemKey);
                      }
                    },
                    onTap: () {
                      if (isSelectionMode) {
                        _toggleItemSelection(itemKey);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: Colors.red, width: 2)
                            : null,
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
                          if (isSelectionMode)
                            Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                _toggleItemSelection(itemKey);
                              },
                            ),
                          ///////////////////////////////// profile image
                          if (item['avatar'] != null &&
                              item['avatar'].isNotEmpty)
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipOval(
                                child: Image.memory(
                                  item['avatar'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          const SizedBox(width: 12),

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
                                      //////////////////////////// agent name
                                      TextSpan(
                                        text: item['agent'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const TextSpan(text: ' '),
                                      ////////////////////////////// history action
                                      ..._buildActionSpans(
                                        item['action'] as String,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ///////////////////////////// action date and time
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    formatTime(item['time'] as String),
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
