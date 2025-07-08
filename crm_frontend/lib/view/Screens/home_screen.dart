// ignore_for_file: avoid_print
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AppColors {
  static const contentColorOrange = Color.fromARGB(255, 10, 43, 92);
  static const contentColorBlue = Color.fromARGB(255, 100, 124, 143);
  static const contentColorGreen = Color(0xFF4CAF50);
  static const contentColorWhite = Color(0xFFFFFFFF);
}

class AppUtils {
  void tryToLaunchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///////////////////////////////////////////////////////////////////////////////////////////// variables
  final String userName = "Wilou";
  int _selectedIndex = 0;
  late String _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Hello, $userName',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  /////////////////////////////////////////////////////////////////////////  date and time
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blueGrey[700],
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          todayDate,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          color: Colors.blueGrey[700],
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _currentTime,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ///////////////////////////////////////////////////////////////////////// Today's Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(
                      'Clients',
                      '15',
                      Icons.people,
                      Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoCard('Tasks', '8', Icons.task_alt, Colors.teal),
                    const SizedBox(width: 8),
                    _buildInfoCard(
                      'Deals',
                      '5',
                      Icons.business_center,
                      Colors.deepOrange,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  'Quick Add',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                /////////////////////////////////////////////////////////////////////////    Quick Add Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAddButton(Icons.person_add, 'Client', () => ()),
                    _buildQuickAddButton(Icons.add_task, 'Task', () => ()),
                    _buildQuickAddButton(Icons.add_business, 'Deal', () => ()),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Recent Statics',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                /////////////////////////////////////////////////////////////////////////   Chart Section
                const LineChartSample13(),
              ],
            ),
          ),
        ),
      ),
      /////////////////////////////////////////////////////////////////////////  Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[900],
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: const Color.fromARGB(255, 254, 255, 255),
        unselectedItemColor: Colors.blueGrey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Color.fromARGB(255, 253, 253, 253),
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.blueGrey,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Deals',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////// Build todays cards
  Widget _buildInfoCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color,
        child: InkWell(
          onTap: () => (),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.white),
                const SizedBox(height: 6),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////// Build quick add buttons
  Widget _buildQuickAddButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.blueGrey[900],
            alignment: Alignment.center,
          ),
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.blueGrey[900], fontSize: 14),
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

  ///////////////////////////////////////////////////////////////////////// Months Names List
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

  late List<List<int>> monthlyClientData;

  @override
  void initState() {
    super.initState();
    _generateMockClientData();
  }

  ///////////////////////////////////////////////////////////////////////// Generate Mock Client Data
  void _generateMockClientData() {
    final random = Random();
    monthlyClientData = List.generate(12, (monthIndex) {
      int daysInMonth = DateUtils.getDaysInMonth(2024, monthIndex + 1);
      return List.generate(daysInMonth, (day) => random.nextInt(10));
    });
  }

  /////////// Build Widget
  @override
  Widget build(BuildContext context) {
    final currentMonthData = monthlyClientData[_currentMonthIndex];
    return Column(
      children: [
        const SizedBox(height: 18),

        ///////////////////////////////////////////////////////////////////////// Chart Title
        Text(
          'Clients Added in ${monthsNames[_currentMonthIndex]}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.contentColorBlue,
          ),
        ),

        const SizedBox(height: 12),

        ///////////////////////////////////////////////////////////////////////// Line Chart
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 10,
              minX: 1,
              maxX: currentMonthData.length.toDouble(),
              lineBarsData: [
                LineChartBarData(
                  spots: currentMonthData.asMap().entries.map((e) {
                    return FlSpot((e.key + 1).toDouble(), e.value.toDouble());
                  }).toList(),
                  isCurved: true,
                  color: AppColors.contentColorOrange,
                  barWidth: 2,
                  dotData: const FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                ///////////////////////////////////////////////////////////////////////// Y Titles
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text('${value.toInt()}'),
                    ),
                  ),
                ),
                ///////////////////////////////////////////////////////////////////////// X Titles
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text('${value.toInt()}'),
                    ),
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////// day and number of clients data
              gridData: FlGridData(show: true),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        'Day ${spot.x.toInt()}: ${spot.y.toInt()} clients',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////////////////// Can Go Next and Previous Month
  bool get _canGoNext => _currentMonthIndex < 11;

  bool get _canGoPrevious => _currentMonthIndex > 0;

  void _nextMonth() {
    if (_canGoNext) setState(() => _currentMonthIndex++);
  }

  void _previousMonth() {
    if (_canGoPrevious) setState(() => _currentMonthIndex--);
  }
}
