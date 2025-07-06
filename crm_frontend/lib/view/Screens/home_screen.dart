import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "User"; // Placeholder for user's name
  final List<String> recentActivities = [
    'Added new client: John Doe',
    'Completed task: Follow up with Acme Corp',
    'Closed deal: Beta Project',
    'Scheduled meeting with marketing team',
  ];

  int _selectedIndex = 0;

  void _onCardTap(String cardType) {
    // TODO: Navigate to detailed list for the cardType
    print('Tapped on $cardType card');
  }

  void _onQuickAdd(String itemType) {
    // TODO: Implement quick add functionality
    print('Quick add $itemType');
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Navigate to the selected page
      print('Navigated to index $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('lib/images/login.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                  Text(
                    todayDate,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        'Clients Today',
                        '15',
                        Icons.people,
                        Colors.blueGrey,
                        () => _onCardTap('Clients'),
                      ),
                      _buildInfoCard(
                        'Tasks Today',
                        '8',
                        Icons.task_alt,
                        Colors.teal,
                        () => _onCardTap('Tasks'),
                      ),
                      _buildInfoCard(
                        'Deals Today',
                        '5',
                        Icons.business_center,
                        Colors.deepOrange,
                        () => _onCardTap('Deals'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quick Add',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAddButton(
                        Icons.person_add,
                        'Client',
                        () => _onQuickAdd('Client'),
                      ),
                      _buildQuickAddButton(
                        Icons.add_task,
                        'Task',
                        () => _onQuickAdd('Task'),
                      ),
                      _buildQuickAddButton(
                        Icons.add_business,
                        'Deal',
                        () => _onQuickAdd('Deal'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recent Activities',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: recentActivities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.blueGrey[700],
                          ),
                          title: Text(
                            recentActivities[index],
                            style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blueGrey[900],
        unselectedItemColor: Colors.blueGrey[400],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new item action
        },
        backgroundColor: Colors.blueGrey[900],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String count,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: color,
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAddButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.blueGrey[900],
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
