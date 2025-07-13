// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userName = "Wilou dilaw";
  final String email = "wilou@gmail.com";
  final String phone = "05 34 56 78 90";

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      shadows: const [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile info card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with edit icon and background image
                      Stack(
                        children: [
                          // Background image below avatar
                          Container(
                            width: double.infinity,
                            height: 240, // height to cover avatar + 10px below
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(9),
                                bottomRight: Radius.circular(9),
                              ),
                              image: DecorationImage(
                                image: AssetImage('lib/images/a2.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Avatar with edit icon positioned in center
                        ],
                      ),
                      // Positioned edit icon at bottom left of the image
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.edit,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      /////////////LINE SEPARATOR////////////
                      Center(
                        child: Container(
                          height: 2,
                          width: 430,
                          color: primaryColor,
                        ),
                      ),
                      // Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          userName,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Menu items list
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person, color: primaryColor),
                              title: Text(
                                'My Profile',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('My Profile tapped'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.settings,
                                color: primaryColor,
                              ),
                              title: Text(
                                'Settings',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Settings tapped'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.history, color: primaryColor),
                              title: Text(
                                'History',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('History tapped'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.group, color: primaryColor),
                              title: Text(
                                'Agents',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Agents tapped'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.info, color: primaryColor),
                              title: Text(
                                'About',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('About tapped')),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.logout, color: primaryColor),
                              title: Text(
                                'Logout',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logout tapped'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
