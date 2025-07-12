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
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: color),
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
                /////////////////////////////////////////////////////////////////////////  LINE Chart Section
                const LineChartSample13(), /////////////////////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////    PIE Chart Section
                const PieChartSample2(), ///////////////////////////////////////////////////////////////////////////////////////
              ],
            ),
          ),
        ),
      ),
      //////////////////////////////////////////////////////////////  Bottom Navigation Bar
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
    final chartWidth = daysInMonth * 22.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Clients Added in ${monthsNames[_currentMonthIndex]}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.contentColorBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),

        ////////////////////////////////////////// Scrollable chart with mouse support
        SizedBox(
          height: 500,
          child: ScrollConfiguration(
            behavior:
                _MouseDragScrollBehavior(), // 👈 Add custom scroll behavior
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
                          barWidth: 2,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              meta: meta,
                              child: Text('${value.toInt()}'),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              // Add extra space for the last two X values
                              int lastDay = currentMonthData.length;
                              int secondLastDay = lastDay - 1;
                              double x = value;
                              Widget label = Text('${value.toInt()}');
                              if (x == lastDay.toDouble()) {
                                // Last X value, add more space to the right
                                return Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: label,
                                );
                              } else if (x == secondLastDay.toDouble()) {
                                // Second last X value, add some space to the right
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

// 👇 This allows mouse drag scroll on desktop/web
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

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          const SizedBox(width: 80),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: const Color.fromARGB(255, 165, 199, 42),
                text: 'Leads',
              ),
              const SizedBox(height: 4),
              Indicator(
                color: const Color.fromARGB(255, 42, 50, 97),
                text: 'Clients',
              ),
              const SizedBox(height: 4),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

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
              color: AppColors.mainTextColor1,
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
              color: AppColors.mainTextColor1,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
