// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen for adding/updating Client or Lead info
class ClientInfoScreen extends StatefulWidget {
  const ClientInfoScreen({super.key});

  @override
  State<ClientInfoScreen> createState() => _ClientInfoScreenState();
}

class _ClientInfoScreenState extends State<ClientInfoScreen> {
  /// Form key to validate form fields
  final _formKey = GlobalKey<FormState>();
  bool _secondemail = true;
  String? _selectedType = 'Client';

  /////////////////////////////////////////////////////////////////////////////////// Controllers for all input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  /// Dynamic list of additional phone controllers
  final List<TextEditingController> _additionalPhoneControllers = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _secondEmailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _otherInfoController = TextEditingController();

  /// Save button logic
  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      // 👇 Gather all phone numbers into a list
      final allPhones = [
        _phoneController.text,
        ..._additionalPhoneControllers.map((c) => c.text),
      ];

      // 🧭 Example: print or send this to backend
      print('✅ Saving client with phones: $allPhones');

      // Show confirmation to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Client/Lead saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Close screen
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
        width: double.infinity,
        height: double.infinity,
        //////////////////////////////////////////////////////////////////////// Background Image
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
                    ///////////////////////////////////////////////////////////// Title
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
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
                    ),

                    const SizedBox(height: 100),

                    ///////////////////////////////////////////////////////////// First Name and Last Name in a Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'First Name',
                            controller: _firstNameController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter First Name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: 'Last Name',
                            controller: _lastNameController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Identity (Company, Job Title, etc.)
                    _buildTextField(
                      label: 'Identity (Company, Job Title, etc.)',
                      controller: _identityController,
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Primary Phone Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Phone Number';
                              }
                              final pattern = RegExp(r'^(05|06|07)\d{8}$');
                              if (!pattern.hasMatch(value)) {
                                return 'Phone number must start with 05, 06, or 07 and be 10 digits';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        //////////////////////////////////// add icon button of phone number
                        Container(
                          decoration: BoxDecoration(
                            color: _additionalPhoneControllers.length < 9
                                ? primaryColor
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _additionalPhoneControllers.length < 9
                                ? _addPhoneField
                                : null,
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Secondary Phone numbers
                    Column(
                      children: List.generate(
                        _additionalPhoneControllers.length,
                        (index) {
                          String label = '${_ordinal(index)} phone number';
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

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter $label';
                                      }
                                      final pattern = RegExp(
                                        r'^(05|06|07)\d{8}$',
                                      );
                                      if (!pattern.hasMatch(value)) {
                                        return 'Phone number must start with 05, 06, or 07 and be 10 digits';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  /////////////////////// Delete button
                                  child: IconButton(
                                    onPressed: () => _removePhoneField(index),
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    splashRadius: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    ///////////////////////////////////////////////////////////// Email
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,

                            validator: (value) {
                              if (value == null ||
                                  !value.contains('@gmail.com')) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        //////////////////////////////////////// Add email button
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _secondemail = !_secondemail;
                              });
                            },
                            icon: Icon(
                              _secondemail ? Icons.add : Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ///////////////////////////////////////////////////////////// Second email
                    if (!_secondemail) ...[
                      _buildTextField(
                        label: 'Second Email',
                        controller: _secondEmailController,
                        keyboardType: TextInputType.emailAddress,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Second Email';
                          }
                          if (!value.contains('@gmail.com')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    ///////////////////////////////////////////////////////////// Address
                    _buildTextField(
                      label: 'Address',
                      controller: _addressController,
                    ),
                    const SizedBox(height: 16),

                    //////////////////////////////////////////////////////////////// Website
                    _buildTextField(
                      label: 'Website',
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Notes / Other Info / Description
                    _buildTextField(
                      label: 'Notes',
                      controller: _otherInfoController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 28),
                    ////////////////////////////////////////////////////////////////////////////////////////////// Type Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Type:',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTypeButton(
                                label: 'Client',
                                isSelected: _selectedType == 'Client',
                                selectedColor: Colors.teal.shade700,
                                unselectedColor: const Color(0xFFE9FFFB),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFF029483),
                                onTap: () =>
                                    setState(() => _selectedType = 'Client'),
                              ),
                              _buildTypeButton(
                                label: 'Lead',
                                isSelected: _selectedType == 'Lead',
                                selectedColor: Colors.deepOrange.shade400,
                                unselectedColor: const Color(0xFFFFD5C9),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFFAA5F48),
                                onTap: () =>
                                    setState(() => _selectedType = 'Lead'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

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

  ///////////////////////////////////////////////////////////// TextFields widget

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    Color? textColor = const Color.fromARGB(255, 38, 44, 48),
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      style: GoogleFonts.roboto(fontSize: 16, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: textColor?.withOpacity(0.85),
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
  String _ordinal(int number) {
    const labels = [
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
    return labels[number];
  }
}

///////////////////////////////////////////// Type button
Widget _buildTypeButton({
  required String label,
  required bool isSelected,
  required Color selectedColor,
  required Color unselectedColor,
  required Color selectedTextColor,
  required Color unselectedTextColor,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selectedColor, width: isSelected ? 2.5 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.25),
                    blurRadius: 7,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedTextColor : unselectedTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
