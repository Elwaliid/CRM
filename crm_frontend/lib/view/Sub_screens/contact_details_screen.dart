// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print

import 'package:crm_frontend/view/Widgets/Type_buttons.dart';
import 'package:crm_frontend/view/Widgets/wilou_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen for adding/updating Client or Lead info
class ContactDetailsScreen extends StatefulWidget {
  const ContactDetailsScreen({super.key});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
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
                          child: WilouTextField(
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
                          child: WilouTextField(
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
                    WilouTextField(
                      label: 'Identity (Company, Job Title, etc.)',
                      controller: _identityController,
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Primary Phone Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: WilouTextField(
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
                                  child: WilouTextField(
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
                          child: WilouTextField(
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
                      WilouTextField(
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
                    WilouTextField(
                      label: 'Address',
                      controller: _addressController,
                    ),
                    const SizedBox(height: 16),

                    //////////////////////////////////////////////////////////////// Website
                    WilouTextField(
                      label: 'Website',
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),

                    ///////////////////////////////////////////////////////////// Notes / Other Info / Description
                    WilouTextField(
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
                              TypeButton(
                                label: 'Client',
                                isSelected: _selectedType == 'Client',
                                selectedColor: Colors.teal.shade700,
                                unselectedColor: const Color(0xFFE9FFFB),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFF029483),
                                onTap: () =>
                                    setState(() => _selectedType = 'Client'),
                              ),
                              TypeButton(
                                label: 'Lead',
                                isSelected: _selectedType == 'Lead',
                                selectedColor: Colors.deepOrange.shade400,
                                unselectedColor: const Color(0xFFFFD5C9),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFFAA5F48),
                                onTap: () =>
                                    setState(() => _selectedType = 'Lead'),
                              ),
                              const SizedBox(width: 6),
                              ////////////////////////////////////////////// In Progress
                              TypeButton(
                                label: 'Vendor',
                                isSelected: _selectedType == 'Vendor',
                                selectedColor: primaryColor,
                                unselectedColor: const Color(0xFFD9DDE0),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: primaryColor,
                                onTap: () =>
                                    setState(() => _selectedType = 'Vendor'),
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
