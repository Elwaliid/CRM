import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Client {
  final String name;
  final String phone;
  final String email;

  Client({required this.name, required this.phone, required this.email});
}

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Client> _clients = [
    Client(
      name: 'Alice Johnson',
      phone: '123-456-7890',
      email: 'alice@example.com',
    ),
    Client(name: 'Bob Smith', phone: '987-654-3210', email: 'bob@example.com'),
    Client(
      name: 'Charlie Davis',
      phone: '555-123-4567',
      email: 'charlie@example.com',
    ),
    Client(
      name: 'Diana Prince',
      phone: '444-555-6666',
      email: 'diana@example.com',
    ),
  ];
  List<Client> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _filteredClients = _clients;
    _searchController.addListener(_filterClients);
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClients = _clients.where((client) {
        return client.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _callClient(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch phone app')));
    }
  }

  void _messageClient(String phone) async {
    final Uri url = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch messaging app')));
    }
  }

  void _addClient() {
    // TODO: Implement add client functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Add Client button pressed')));
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Clients',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search clients',
                prefixIcon: Icon(Icons.search, color: secondaryColor),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
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
                  borderSide: BorderSide(color: secondaryColor, width: 2.0),
                ),
              ),
              style: TextStyle(color: primaryColor, fontSize: 18),
            ),
            const SizedBox(height: 12),
            // Clients list
            Expanded(
              child: _filteredClients.isEmpty
                  ? Center(
                      child: Text(
                        'No clients found',
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = _filteredClients[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Phone: ${client.phone}',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Email: ${client.email}',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.call,
                                        color: primaryColor,
                                      ),
                                      onPressed: () =>
                                          _callClient(client.phone),
                                      tooltip: 'Call',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.message,
                                        color: primaryColor,
                                      ),
                                      onPressed: () =>
                                          _messageClient(client.phone),
                                      tooltip: 'Message',
                                    ),
                                  ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addClient,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Client'),
      ),
    );
  }
}
