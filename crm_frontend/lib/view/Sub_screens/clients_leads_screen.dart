// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen for adding/updating Client or Lead info
class ClientsLeadsScreen extends StatefulWidget {
  const ClientsLeadsScreen({super.key});

  @override
  State<ClientsLeadsScreen> createState() => _ClientsLeadsScreenState();
}

class _ClientsLeadsScreenState extends State<ClientsLeadsScreen> {
  /// Form key to validate form fields
  final _formKey = GlobalKey<FormState>();

  ///////////////////////////////////////////////////////////////////////////////////
  /// Controllers for all input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _otherInfoController = TextEditingController();

  /// Dynamic list of additional phone controllers
  final List<TextEditingController> _additionalPhoneControllers = [];

  /// Save button logic
  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Client/Lead saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  /// Add new phone number field
  void _addPhoneField() {
    if (_additionalPhoneControllers.length < 9) {
      setState(() {
        _additionalPhoneControllers.add(TextEditingController());
      });
    }
  }

  /// Remove a specific phone number field
  void _removePhoneField(int index) {
    setState(() {
      _additionalPhoneControllers[index].dispose();
      _additionalPhoneControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueGrey.shade900;
    final Color secondaryColor = Colors.blueGrey.shade700;

    return Scaffold(
      body: Container(
        ////////////////////////////////////////////////////////////////////////
        /// Background Image (same as login.jpg to keep branding consistent)
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /////////////////////////////////////////////////////////////
                    /// Title
                    Center(
                      child: Text(
                        'Add / Update Client',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
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
                      ),
                    ),

                    const SizedBox(height: 24),

                    /////////////////////////////////////////////////////////////
                    /// First Name
                    _buildTextField(
                      label: 'First Name',
                      controller: _firstNameController,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    /////////////////////////////////////////////////////////////
                    /// Last Name
                    _buildTextField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    /////////////////////////////////////////////////////////////
                    /// Identity (Company, Job Title, etc.)
                    _buildTextField(
                      label: 'Identity (Company, Job Title, etc.)',
                      controller: _identityController,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    /////////////////////////////////////////////////////////////
                    /// Primary Phone Number
                    Row(
                      children: [
                        _buildTextField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          primaryColor: primaryColor,
                        ),
                        ///////////////////////////////////////////////////////////// Add Phone Number Button
                        if (_additionalPhoneControllers.length < 9) ...[
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _addPhoneField,
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              splashRadius: 24,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    /////////////////////////////////////////////////////////////
                    /// Dynamic Additional Phone Numbers
                    Column(
                      children: List.generate(
                        _additionalPhoneControllers.length,
                        (index) {
                          String label = '${_ordinal(index + 2)} phone number';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: label,
                                    controller:
                                        _additionalPhoneControllers[index],
                                    keyboardType: TextInputType.phone,
                                    primaryColor: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _removePhoneField(index),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    /*_addPhoneField Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _showAdditionalPhoneField
                                      ? Icons.remove
                                      : Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ), */
                    ///////////////////////////////////////////////////////////// Email
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Address
                    _buildTextField(
                      label: 'Address',
                      controller: _addressController,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    //////////////////////////////////////////////////////////////// Website
                    _buildTextField(
                      label: 'Website',
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Notes / Other Info / Description
                    _buildTextField(
                      label: 'Notes',
                      controller: _otherInfoController,
                      maxLines: 4,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 28),

                    ///////////////////////////////////////////////////////////// Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveClient,
                        icon: Icon(Icons.save, size: 24, color: Colors.white),
                        label: Text(
                          'Save Client',
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
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// Reusable Input Field
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
      style: GoogleFonts.roboto(fontSize: 16, color: primaryColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: primaryColor?.withOpacity(0.85),
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
            color: const Color.fromARGB(255, 41, 49, 53),
            width: 2.0,
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// Ordinal Number Generator (for labels like Second, Third, etc.)
  String _ordinal(int number) {
    const labels = [
      'First',
      'Second',
      'Third',
      'Fourth',
      'Fifth',
      'Sixth',
      'Seventh',
      'Eighth',
      'Ninth',
      'Tenth',
    ];
    return labels[number - 1];
  }
}
