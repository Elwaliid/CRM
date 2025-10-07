// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_string_interpolations, non_constant_identifier_names, avoid_print
import 'dart:convert';
import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/ustils/constants.dart';
import 'package:crm_frontend/ustils/email_utils.dart';
import 'package:crm_frontend/ustils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../models/contact_model.dart';
import '../Sub_screens/contact_details_screen.dart';

class ContactsScreen extends StatefulWidget {
  final String? userId;
  final String? token;

  const ContactsScreen({super.key, this.userId, this.token});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailSubjectController = TextEditingController();
  final TextEditingController _emailBodyController = TextEditingController();
  final List<Contact> _contacts = [];
  String? userId;
  List<Contact> _Contacts = [];
  String? selectedType = "";
  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _loadUserId();
    _searchController.addListener(_filterContact);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailSubjectController.dispose();
    _emailBodyController.dispose();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    try {
      List<Contact> contacts = await Contact.getContacts();
      setState(() {
        _contacts.clear();
        _contacts.addAll(contacts);
        _contacts.sort(
          (a, b) => (b.isPined ?? false ? 1 : 0).compareTo(
            a.isPined ?? false ? 1 : 0,
          ),
        );
        _Contacts = _contacts;
      });
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  Future<void> _loadUserId() async {
    userId = await UserUtils.loadUserId();
    setState(() {});
  }

  void _filterContact() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _Contacts = _contacts
          .where(
            (Contacts) =>
                ('${Contacts.firstname} ${Contacts.lastname}')
                    .toLowerCase()
                    .contains(query) &&
                (selectedType!.isEmpty || Contacts.type == selectedType),
          )
          .toList();
    });
  }

  void _callContact(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch phone app')));
    }
  }

  void _messageContact(String phone) async {
    final Uri url = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch messaging app')));
    }
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
                  'Contacts',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for Contacts',
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
                    ),
                    const SizedBox(width: 10),
                    ///////////////////////////////////////////////////////////// Type filter
                    Column(
                      children: [
                        /////////////////// client circle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = selectedType == "Client"
                                  ? ""
                                  : "Client";
                              _filterContact();
                            });
                          },
                          child: Container(
                            width: 17,
                            height: 17,

                            decoration: BoxDecoration(
                              color: contentColorGreen,
                              shape: BoxShape.circle,
                              border: selectedType == "Client"
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                          ),
                        ),
                        /////////////////// Lead circle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = selectedType == "Lead"
                                  ? ""
                                  : "Lead";
                              _filterContact();
                            });
                          },
                          child: Container(
                            width: 17,
                            height: 17,

                            decoration: BoxDecoration(
                              color: deepOrange,
                              shape: BoxShape.circle,
                              border: selectedType == "Lead"
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                          ),
                        ),
                        /////////////////// Vendor circle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = selectedType == "Vendor"
                                  ? ""
                                  : "Vendor";
                              _filterContact();
                            });
                          },
                          child: Container(
                            width: 17,
                            height: 17,

                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: selectedType == "Vendor"
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ////////////////////////////////////////////////////////////// Contact list scrollable
                Expanded(
                  child: _Contacts.isEmpty
                      ? Center(
                          child: Text(
                            'No Contacts added yet.',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: secondaryColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _Contacts.length,
                          itemBuilder: (context, index) {
                            final contact = _Contacts[index];
                            String displayName =
                                '${contact.firstname} ${contact.lastname}';
                            if ((displayName.length > 19) &&
                                (contact.isPined ?? false)) {
                              displayName =
                                  '${displayName.substring(0, 14)}...';
                            } else if (displayName.length > 19) {
                              displayName =
                                  '${displayName.substring(0, 16)}...';
                            }
                            ///////////////////////////////////////////// Contact gesture
                            return GestureDetector(
                              onTap: () {
                                Get.to(ContactDetailsScreen(contact: contact));
                              },
                              ///////////////////////////////////////////////////////////////////////////// Contacts cards
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
                                        /////////////////////////////////////////// Contact firstname and lastname
                                        Text(
                                          displayName,
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
                                            color: contact.type == 'Lead'
                                                ? Colors.deepOrange.shade400
                                                : contact.type == 'Client'
                                                ? Colors.teal.shade700
                                                : Colors.blueGrey.shade900,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${contact.type}',

                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        if (contact.isPined ?? false)
                                          Icon(
                                            Icons.push_pin,
                                            color: primaryColor,
                                          ),
                                        const Spacer(),
                                        //////////////////////////////////////// 3 dots
                                        PopupMenuButton<String>(
                                          color: Colors.white,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: secondaryColor,
                                          ),
                                          onSelected: (selected) {
                                            if (selected == 'Pin') {
                                              bool newPinned =
                                                  !(contact.isPined ?? false);
                                              _pined(newPinned, contact.id);
                                            } else if (selected == 'delete') {
                                              ////// delete contact
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Delete Contact',
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to delete ${contact.firstname} ${contact.lastname}?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            _Contacts.removeAt(
                                                              index,
                                                            );
                                                          });
                                                          final response =
                                                              await http.delete(
                                                                Uri.parse(
                                                                  deleteContactUrl,
                                                                ),
                                                                headers: {
                                                                  'Content-Type':
                                                                      'application/json',
                                                                },
                                                                body:
                                                                    '{"id": "${contact.id}"}',
                                                              );
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  '${contact.firstname} ${contact.lastname} deleted',
                                                                ),
                                                              ),
                                                            );
                                                            _fetchContacts();
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Failed to delete ${contact.firstname} ${contact.lastname}',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  126,
                                                                  2,
                                                                  2,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) => [
                                            ////////////////////////////// edit icon button
                                            PopupMenuItem<String>(
                                              value: 'Pin',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.push_pin,
                                                    color: primaryColor,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    contact.isPined ?? false
                                                        ? 'Unpin'
                                                        : 'Pin',
                                                  ),
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
                                    Text(
                                      'Phone: ${contact.phone}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: secondaryColor,
                                      ),
                                    ),

                                    ////////////////////////////////// Email
                                    Row(
                                      children: [
                                        Text(
                                          'Email:',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: secondaryColor,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              showEmailModalBottomSheet(
                                                context,
                                                contact.email,
                                              ),
                                          child: Text(
                                            '${contact.email}',
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
                                                  _callContact(contact.phone),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.message,
                                                color: primaryColor,
                                              ),
                                              onPressed: () => _messageContact(
                                                contact.phone,
                                              ),
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
                    onPressed: () {
                      Get.to(ContactDetailsScreen());
                    },
                    icon: Icon(Icons.add, size: 24, color: Colors.white),
                    label: Text(
                      'Add Contact',
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

  Future<void> _pined(bool isPined, String id) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('couldnt get user id'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    var logBody = {'owner': userId, 'id': id, 'isPined': isPined};

    try {
      var response = await http.post(
        Uri.parse(addOrUpdateContactUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(logBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          _fetchContacts(); // Refresh the list to update pin status
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save task. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error. Please try again later.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
