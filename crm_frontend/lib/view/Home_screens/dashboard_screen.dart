// ignore_for_file: avoid_print, unused_element, unnecessary_import, use_super_parameters, deprecated_member_use, unused_local_variable, prefer_final_fields
import 'dart:ui';
import 'dart:convert';
import 'package:crm_frontend/ustils/config.dart';
import 'package:http/http.dart' as http;

import 'package:crm_frontend/ustils/constants.dart' as constants;
import 'package:crm_frontend/view/Widgets/quick_adds.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  final String? userId;
  final String? token;

  const DashboardScreen({super.key, this.userId, this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'User';
  late String _currentTime;
  int clientsCount = 0;
  int tasksCount = 0;
  int dealsCount = 0;
  int CompletedTasks = 0;
  int PendingTasks = 0;
  @override
  void initState() {
    super.initState();
    _todayclientsCount();
    _todaytasksCount();
    _todaydealsCount();
    _completedtasksCount();
    _pendingtasksCount();
    if (widget.userId != null) {
      _fetchUserName(widget.userId!);
    }
    _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
  }

  Future<void> _fetchUserName(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/user'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            userName = data['user']['name'] ?? 'User';
            userName = userName.split(' ').first;
          });
        }
      } else {
        print('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> _todayclientsCount() async {
    try {
      final response = await http.get(Uri.parse(getClientsCountUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            clientsCount = data['count'] ?? 0;
          });
        }
      } else {
        print('Failed to fetch clients count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clients count: $e');
    }
  }

  Future<void> _todaytasksCount() async {
    try {
      final response = await http.get(Uri.parse(getTasksCountUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            tasksCount = data['tasksCount'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error fetching tasks count: $e');
    }
  }

  Future<void> _todaydealsCount() async {
    try {
      final response = await http.get(Uri.parse(getTasksCountUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            dealsCount = data['dealsCount'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error fetching tasks count: $e');
    }
  }

  Future<void> _completedtasksCount() async {
    try {
      final response = await http.get(Uri.parse(getTasksCountUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            CompletedTasks = data['completedTasks'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error fetching tasks count: $e');
    }
  }

  Future<void> _pendingtasksCount() async {
    try {
      final response = await http.get(Uri.parse(getTasksCountUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            PendingTasks = data['PendingTasks'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error fetching tasks count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'lib/images/login.jpg', // ✅ your background image path here
                fit: BoxFit.cover,
              ),
            ),
            // Foreground Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ////////////////////////////////////////////////////////// Title
                  Center(
                    child: Text(
                      'Hello, $userName',
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ////////////////////////////////////////////////////////// Date
                      Text(
                        todayDate,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: secondaryColor,
                        ),
                      ),

                      ////////////////////////////////////////////////////////// Time
                      Text(
                        _currentTime,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ////////////////////////////////////////////////////////// Centered "Today's Overview"
                  Center(
                    child: Text(
                      "Today's Overview",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ////////////////////////////////////////////////////////// Cards Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        'Clients',
                        '$clientsCount',

                        Icons.people,
                        primaryColor,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        'Tasks',
                        '$tasksCount',
                        Icons.task_alt,
                        constants.contentColorGreen,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        'Deals',
                        '$dealsCount',
                        Icons.business_center,
                        constants.deepOrange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  ////////////////////////////////////////////////////////// Quick Add
                  Text(
                    'Quick Add',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAddButton(Icons.person_add, 'Client', () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const SizedBox(
                              width: 500,
                              height: 600,
                              child: ClientDetailsFormContent(),
                            ),
                          ),
                        );
                      }),
                      _buildQuickAddButton(Icons.add_task, 'Task', () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const SizedBox(
                              width: 500,
                              height: 600,
                              child: TaskDetailsFormContent(),
                            ),
                          ),
                        );
                      }),
                      _buildQuickAddButton(Icons.add_business, 'Deal', () {}),
                    ],
                  ),
                  const SizedBox(height: 30),

                  ////////////////////////////////////////////////////////// Recent Stats
                  Text(
                    'Recent Statistics',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ////////////////////////////////////////////////////////// Line Chart
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const LineChartSample13(),
                  ),
                  const SizedBox(height: 24),

                  ////////////////////////////////////////////////////////// Pie Chart
                  PieChartSample2(
                    completed: CompletedTasks,
                    pending: PendingTasks,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////// Info Card
  Widget _buildInfoCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                count,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////// Quick Add Button
  Widget _buildQuickAddButton(IconData icon, String label, VoidCallback onTap) {
    final Color primaryColor = Colors.blueGrey.shade900;
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: primaryColor,
            elevation: 6,
          ),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            color: primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////// Line Chart class

class LineChartSample13 extends StatefulWidget {
  const LineChartSample13({super.key});

  @override
  State<LineChartSample13> createState() => _LineChartSample13State();
}

class _LineChartSample13State extends State<LineChartSample13> {
  int _currentMonthIndex = DateTime.now().month - 1;
  final List<String> monthsNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  List<List<int>> monthlyClientData = List.generate(12, (_) => []);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getClientscountData();
  }

  void _getClientscountData() async {
    await _fetchMonthData(_currentMonthIndex);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchMonthData(int monthIndex) async {
    if (monthlyClientData[monthIndex].isNotEmpty) return;
    try {
      final year = DateTime.now().year;
      final response = await http.get(
        Uri.parse(
          '$getClientsCountByMonthUrl?year=$year&month=${monthIndex + 1}',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            monthlyClientData[monthIndex] = List<int>.from(data['counts']);
          });
        }
      }
    } catch (e) {
      print('Error fetching month data: $e');
    }
  }

  void _onMonthChanged(int newIndex) async {
    if (newIndex == _currentMonthIndex) return;
    setState(() {
      _currentMonthIndex = newIndex;
      isLoading = true;
    });
    await _fetchMonthData(newIndex);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthData = monthlyClientData[_currentMonthIndex];
    final daysInMonth = currentMonthData.length;
    final chartWidth = daysInMonth * 17.0;
    final primaryColor = Colors.blueGrey.shade900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Clients Added in ${monthsNames[_currentMonthIndex]}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ScrollConfiguration(
              behavior: _MouseDragScrollBehavior(),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  monthsNames.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(monthsNames[index].substring(0, 3)),
                      selected: _currentMonthIndex == index,
                      onSelected: (selected) {
                        if (selected) {
                          _onMonthChanged(index);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 300,
                child: ScrollConfiguration(
                  behavior: _MouseDragScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: chartWidth,
                      child: ClipRect(
                        // Clip the chart widget to prevent overflow
                        child: LineChart(
                          _generateLineChartData(currentMonthData, daysInMonth),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  LineChartData _generateLineChartData(List<int> data, int days) {
    return LineChartData(
      minY: 0,
      maxY: 10,
      minX: 1,
      maxX: days.toDouble(),
      clipData:
          FlClipData.all(), // Clip chart to prevent drawing outside bounds
      gridData: FlGridData(show: true),
      //////////////////// Titles
      titlesData: FlTitlesData(
        ////////////////////// left titles
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 30,
          ),
        ),
        ////////////////////// bottom titles
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 7,
            reservedSize: 30,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => const SizedBox(width: 50),
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => const SizedBox(width: 100),
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data
              .asMap()
              .entries
              .map((e) => FlSpot((e.key + 1).toDouble(), e.value.toDouble()))
              .toList(),
          isCurved: true,
          color: constants.primaryColor,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 3,
                  color: constants.secondaryColor,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((barSpot) {
              final day = barSpot.x.toInt();
              final clients = barSpot.y.toInt();
              final DateTime date = DateTime(
                DateTime.now().year,
                _currentMonthIndex + 1,
                day,
              );

              return LineTooltipItem(
                'day $day: $clients clients',
                const TextStyle(
                  color: Color.fromARGB(255, 243, 242, 242),
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

class _MouseDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.trackpad,
  };
}

/////////////////////////////////////////////////////////////////////////////////////// PIE CHART
class PieChartSample2 extends StatefulWidget {
  final int completed;
  final int pending;

  const PieChartSample2({
    super.key,
    required this.completed,
    required this.pending,
  });

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    final total = widget.completed + widget.pending;
    final completedPercent = total > 0 ? (widget.completed / total) * 100 : 0;
    final pendingPercent = total > 0 ? (widget.pending / total) * 100 : 0;

    return [
      PieChartSectionData(
        color: constants.contentColorGreen,
        value: widget.completed.toDouble(),
        title: '${completedPercent.toStringAsFixed(1)}%',
        radius: touchedIndex == 0 ? 60 : 50,
        titleStyle: GoogleFonts.roboto(
          fontSize: touchedIndex == 0 ? 22 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade50,
        ),
      ),
      PieChartSectionData(
        color: constants.primaryColor,
        value: widget.pending.toDouble(),
        title: '${pendingPercent.toStringAsFixed(1)}%',
        radius: touchedIndex == 1 ? 60 : 50,
        titleStyle: GoogleFonts.roboto(
          fontSize: touchedIndex == 1 ? 22 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade50,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color backgroundColor = Colors.white.withOpacity(0.9);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /////////////////////////////////////////// Title
          Text(
            'Tasks statistics',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),

          /////////////////////////////////////////// Chart
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response?.touchedSection == null) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex =
                            response!.touchedSection!.touchedSectionIndex;
                      }
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 1,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),

          /////////////////////////////////////////// Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendBox(constants.contentColorGreen, 'Completed'),
              const SizedBox(width: 16),
              _buildLegendBox(constants.primaryColor, 'Pending'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade900,
          ),
        ),
      ],
    );
  }
}
