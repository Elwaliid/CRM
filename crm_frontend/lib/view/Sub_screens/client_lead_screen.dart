// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientLeadScreen extends StatefulWidget {
  const ClientLeadScreen({super.key});

  @override
  State<ClientLeadScreen> createState() => _ClientLeadScreenState();
}

class _ClientLeadScreenState extends State<ClientLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _otherInfoController = TextEditingController();

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      // Here you'd do your DB insert / update logic.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Client/Lead saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add / Edit Client',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'First Name',
                  controller: _firstNameController,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Identity (Company, Job Title, etc.)',
                  controller: _identityController,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Address',
                  controller: _addressController,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Website',
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Other Info / Description',
                  controller: _otherInfoController,
                  maxLines: 4,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveClient,
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(
                      'Save Client',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    Color? primaryColor,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      style: GoogleFonts.roboto(color: primaryColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: primaryColor?.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.blueGrey[50],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryColor ?? Colors.blueGrey.shade900,
            width: 2,
          ),
        ),
      ),
    );
  }
}
