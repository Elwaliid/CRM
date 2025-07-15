// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_string_interpolations, non_constant_identifier_names, avoid_print
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../Sub_screens/clients_leads_screen.dart';

class Client {
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String type;
  Client({
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.type,
  });
}

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Client> _clients = [
    Client(
      firstname: 'Mouh',
      lastname: 'Latcha',
      phone: '06 61 23 45 67',
      email: 'mouh.latcha@gmail.com',
      type: 'Client',
    ),
    Client(
      firstname: 'Ibrahim',
      lastname: 'Karbousa',
      phone: '05 50 12 34 56',
      email: 'ibrahim.karbousa@gmail.com',
      type: 'Lead',
    ),
    Client(
      firstname: 'Wilou',
      lastname: 'Boubaidja',
      phone: '07 70 98 76 54',
      email: 'walidboubaidja@gmail.com',
      type: 'Lead',
    ),
    Client(
      firstname: 'Sid Ahmed',
      lastname: 'Doudana',
      phone: '06 99 11 22 33',
      email: 'sid.doudana@gmail.com',
      type: 'Client',
    ),
    Client(
      firstname: 'Cheb',
      lastname: 'Batata',
      phone: '05 44 55 66 77',
      email: 'cheb.batata@gmail.com',
      type: 'Lead',
    ),
    Client(
      firstname: 'Fatiha',
      lastname: 'Mkara',
      phone: '07 77 88 99 00',
      email: 'fatiha.mkara@gmail.com',
      type: 'Lead',
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
      _filteredClients = _clients
          .where(
            (client) => ('${client.firstname} ${client.lastname}')
                .toLowerCase()
                .contains(query),
          )
          .toList();
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Add Client button pressed')));
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
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
                ///////////////////////////////////////////////////////////////////////////// Title
                Text(
                  'Clients',
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    shadows: [
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
                ///////////////////////////////////////////////////////////////////////////// Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for clients',
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
                ////////////////////////////////////////////////////////////// client list scrollable
                Expanded(
                  child: _filteredClients.isEmpty
                      ? Center(
                          child: Text(
                            'No clients added yet.',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: secondaryColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredClients.length,
                          itemBuilder: (context, index) {
                            final client = _filteredClients[index];
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            return GestureDetector(
                              onTap: () {
                                Get.to(ClientsLeadsScreen());
                                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              },
                              ///////////////////////////////////////////////////////////////////////////// Clients and Leads cards
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 12,
                                  bottom: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        /////////////////////////////////////////// client/lead firstname and lastname
                                        Text(
                                          '${client.firstname} ${client.lastname}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        //////////////////////////////////////////////// TYPE-----
                                        Container(
                                          width: 120,
                                          height: 23,
                                          decoration: BoxDecoration(
                                            color: client.type == 'Lead'
                                                ? Colors.deepOrange.shade400
                                                : Colors.teal.shade700,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${client.type}',

                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        //////////////////////////////////////// 3 dots and Conditions
                                        PopupMenuButton<String>(
                                          color: Colors.white,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: secondaryColor,
                                          ),
                                          onSelected: (selected) {
                                            if (selected == 'edit') {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Edit client: ${client.firstname} ${client.lastname}',
                                                  ),
                                                ),
                                              );
                                            } else if (selected == 'delete') {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Delete client: ${client.firstname} ${client.lastname}',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) => [
                                            ////////////////////////////// edit icon button
                                            PopupMenuItem<String>(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: primaryColor,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            ////////////////////////////// delete icon button
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      126,
                                                      2,
                                                      2,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('Delete'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    ///////////////////////////// phone
                                    Column(
                                      children: [
                                        Text(
                                          'Phone: ${client.phone}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ////////////////////////////////// Email
                                        TextButton(
                                          onPressed: () =>
                                              SendEmail(client.email),
                                          child: Text(
                                            'Email: ${client.email}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ),

                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.call,
                                                color: primaryColor,
                                              ),
                                              onPressed: () =>
                                                  _callClient(client.phone),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.message,
                                                color: primaryColor,
                                              ),
                                              onPressed: () =>
                                                  _messageClient(client.phone),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                /////////////////////////////////////////////////////////////////////////////////// Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addClient,
                    icon: Icon(Icons.add, size: 24, color: Colors.white),
                    label: Text(
                      'Add Client',
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

void SendEmail(String email) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query:
        'subject=Hello from the CRM App&body=I want to get in touch with you',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    print('❌ Could not launch email client');
  }
}
