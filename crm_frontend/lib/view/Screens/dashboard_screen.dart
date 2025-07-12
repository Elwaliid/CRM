// ignore_for_file: avoid_print, unused_element, unnecessary_import, use_super_parameters, deprecated_member_use
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/////////////////////////////////////////////// Colors
class AppColors {
  static const contentColorOrange = Color.fromARGB(255, 10, 43, 92);
  static const contentColorBlue = Color.fromARGB(255, 100, 124, 143);
  static final contentColorGreen = Colors.teal.shade700;
  static final content = Colors.blueGrey.shade900;
  static const contentColorWhite = Color(0xFFFFFFFF);

  static const contentColorYellow = Color(0xFFFFC107); // Amber Yellow
  static const contentColorPurple = Color(0xFF9C27B0); // Purple
  static const mainTextColor1 = Color(0xFF212121); // Dark Grey for main text
}

//////////////////////////////////////////////////////////////////////// // Indicator class
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.size = 16,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class AppUtils {
  void tryToLaunchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userName = "Wilou";
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Hello, $userName',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
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
                  const SizedBox(height: 4),

                  ////////////////////////////////////////////////////////// Date
                  Text(
                    todayDate,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

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
                        '15',
                        Icons.people,
                        primaryColor,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        'Tasks',
                        '8',
                        Icons.task_alt,
                        AppColors.contentColorGreen,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        'Deals',
                        '5',
                        Icons.business_center,
                        Colors.deepOrange.shade400,
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
                      _buildQuickAddButton(Icons.person_add, 'Client', () {}),
                      _buildQuickAddButton(Icons.add_task, 'Task', () {}),
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
                    child: const PieChartSample2(),
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
  late List<List<int>> monthlyClientData;

  @override
  void initState() {
    super.initState();
    _generateMockClientData();
  }

  void _generateMockClientData() {
    final random = Random();
    monthlyClientData = List.generate(12, (monthIndex) {
      int daysInMonth = DateUtils.getDaysInMonth(2024, monthIndex + 1);
      return List.generate(daysInMonth, (day) => random.nextInt(10));
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ScrollConfiguration(
            behavior: _MouseDragScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                child: LineChart(
                  _generateLineChartData(currentMonthData, daysInMonth),
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
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 30,
          ),
        ),
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
          color: AppColors.contentColorOrange,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.contentColorOrange.withOpacity(0.1),
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
                '$day: $clients clients',
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
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: AppColors.content,
        value: 40,
        title: '40%',
        radius: touchedIndex == 0 ? 60 : 50,
        titleStyle: GoogleFonts.roboto(
          fontSize: touchedIndex == 0 ? 22 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade50,
        ),
      ),
      PieChartSectionData(
        color: AppColors.contentColorGreen,
        value: 60,
        title: '60%',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Leads vs Clients',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.3,
          child: Container(
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
        ),
      ],
    );
  }
}
