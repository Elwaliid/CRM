import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

void showEmailModalBottomSheet(
  BuildContext context,
  String email,
  String owner,
) {
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Compose Email', style: GoogleFonts.poppins(fontSize: 18)),
                SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: email),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: bodyController,
                  decoration: InputDecoration(
                    labelText: 'Body',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');
                        if (token != null) {
                          sendEmail(
                            context,
                            owner,
                            email,
                            subjectController.text,
                            bodyController.text,
                            token,
                          );
                          Navigator.pop(context);
                        } else {
                          Get.snackbar(
                            'Error',
                            'No authentication token found',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Text('Send'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void sendEmail(
  BuildContext context,
  String owner,
  String email,
  String subject,
  String body,
  String token,
) async {
  String receiverMail = email;
  String sub = subject;
  String text = body;
  try {
    final response = await http.post(
      Uri.parse(sendEmailUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: '{"to": "$receiverMail", "subject": "$sub", "text": "$text"}',
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
      Get.snackbar(
        'Success',
        'Email Sent Successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 116, 148, 117),
        colorText: Colors.white,
      );
    } else {
      print('Failed to send email: ${response.body}');
      Get.snackbar(
        'Error',
        'Failed to send email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 134, 93, 90),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print('Error sending email: $e');
    Get.snackbar(
      'Error',
      'Error sending email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
