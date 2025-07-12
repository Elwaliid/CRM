// ignore_for_file: avoid_print, unused_element, unnecessary_import, use_super_parameters, deprecated_member_use
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
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
  static const contentColorGreen = Color(0xFF4CAF50);
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
          style: TextStyle(
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
  ///////////////////////////////////////////////////////////////////////////////////////////// variables
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
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
                        const SizedBox(width: 8),
                        Text(
                          todayDate,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          color: Colors.blueGrey[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentTime,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey[800],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(
                      'Clients',
                      '15',
                      Icons.people,
                      Colors.blueGrey[800]!,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoCard(
                      'Tasks',
                      '8',
                      Icons.task_alt,
                      Colors.teal[700]!,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoCard(
                      'Deals',
                      '5',
                      Icons.business_center,
                      Colors.deepOrange[400]!,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Quick Add',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                /////////////////////////////////////////////////////////////////////////    Quick Add Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAddButton(Icons.person_add, 'Client', () => ()),
                    _buildQuickAddButton(Icons.add_task, 'Task', () => ()),
                    _buildQuickAddButton(Icons.add_business, 'Deal', () => ()),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Recent Statistics',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                /////////////////////////////////////////////////////////////////////////  LINE Chart Section
                SizedBox(
                  height: 450,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 450,
                        maxHeight: 450,
                      ),
                      child: const LineChartSample13(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                /////////////////////////////////////////////////////////////////////////    PIE Chart Section
                SizedBox(
                  height: 300,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 300, maxHeight: 300),
                    child: const PieChartSample2(),
                  ),
                ),
              ],
            ),
          ),
        ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 150,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: color,
          shadowColor: Colors.blueGrey.withOpacity(0.3),
          child: InkWell(
            onTap: () => (),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 36, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.blueGrey[900],
              alignment: Alignment.center,
              shadowColor: Colors.transparent,
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey[900],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              'Clients Added in ${monthsNames[_currentMonthIndex]}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 450,
          child: ScrollConfiguration(
            behavior: _MouseDragScrollBehavior(),
            child: Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartWidth,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 10,
                      minX: 1,
                      maxX: daysInMonth.toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: currentMonthData.asMap().entries.map((e) {
                            return FlSpot(
                              (e.key + 1).toDouble(),
                              e.value.toDouble(),
                            );
                          }).toList(),
                          isCurved: true,
                          color: AppColors.contentColorOrange,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.contentColorOrange.withOpacity(
                              0.1,
                            ),
                          ),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 15, // 💥 reduce space here
                            getTitlesWidget: (value, meta) => Padding(
                              padding: const EdgeInsets.only(
                                top: 9.0,
                              ), // 👈 Adjust this number
                              child: Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 7,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              int lastDay = currentMonthData.length;
                              int secondLastDay = lastDay - 1;
                              double x = value;
                              Widget label = Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontSize: 12,
                                ),
                              );
                              if (x == lastDay.toDouble()) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: label,
                                );
                              } else if (x == secondLastDay.toDouble()) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: label,
                                );
                              }
                              return label;
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.blueGrey.withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.blueGrey.withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                'Day ${spot.x.toInt()}: ${spot.y.toInt()} clients',
                                const TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.blueGrey,
                                  fontSize: 15,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      clipData: FlClipData.all(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool get _canGoNext => _currentMonthIndex < 11;
  bool get _canGoPrevious => _currentMonthIndex > 0;

  void _nextMonth() {
    if (_canGoNext) setState(() => _currentMonthIndex++);
  }

  void _previousMonth() {
    if (_canGoPrevious) setState(() => _currentMonthIndex--);
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
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 22.0 : 16.0;
      final double radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 204, 255, 20),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 109, 131, 255),
            value: 60,
            title: '60%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Pie chart of Leads and Clients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // light padding
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Indicator(
                        color: const Color.fromARGB(255, 204, 255, 20),
                        text: 'Leads',
                        textColor: Colors.blueGrey[800]!,
                      ),
                      const SizedBox(height: 12),
                      Indicator(
                        color: const Color.fromARGB(255, 109, 131, 255),
                        text: 'Clients',
                        textColor: Colors.blueGrey[800]!,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
