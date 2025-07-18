// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen for adding/updating Client or Lead info
class TaskInfoScreen extends StatefulWidget {
  const TaskInfoScreen({super.key});

  @override
  State<TaskInfoScreen> createState() => _TaskInfoScreenState();
}

class _TaskInfoScreenState extends State<TaskInfoScreen> {
  /// Form key to validate form fields
  final _formKey = GlobalKey<FormState>();
  bool _secondemail = true;
  String? _selectedType = 'Pending';

  /////////////////////////////////////////////////////////////////////////////////// Controllers for all input fields
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  /// Dynamic list of additional assignedTo controllers
  final List<TextEditingController> _additionalassignedToControllers = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _secondEmailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _otherInfoController = TextEditingController();

  /// Save button logic
  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      // 👇 Gather all assignedTo numbers into a list
      final allassignedTos = [
        _assignedToController.text,
        ..._additionalassignedToControllers.map((c) => c.text),
      ];

      // 🧭 Example: print or send this to backend
      print('✅ Saving client with assignedTos: $allassignedTos');

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

  /// Add new assignedTo number field
  void _addassignedToField() {
    if (_additionalassignedToControllers.length < 9) {
      setState(() {
        _additionalassignedToControllers.add(TextEditingController());
      });
    }
  }

  /// Remove a specific assignedTo number field
  void _removeassignedToField(int index) {
    setState(() {
      _additionalassignedToControllers[index].dispose();
      _additionalassignedToControllers.removeAt(index);
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
                          'Task details',
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

                    ///////////////////////////////////////////////////////////// Task Title
                    _buildTextField(
                      label: 'Task Title',
                      controller: _taskNameController,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter First Name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    ///////////////////////////////////////////////////////////// Primary assignedTo Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'assignedTo full name persone',
                            controller: _assignedToController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter assignedTo full name';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        //////////////////////////////////// add icon button of assignedTo number
                        Container(
                          decoration: BoxDecoration(
                            color: _additionalassignedToControllers.length < 9
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
                            onPressed:
                                _additionalassignedToControllers.length < 9
                                ? _addassignedToField
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
                    ///////////////////////////////////////////////////////////// Secondary assignedTo numbers
                    Column(
                      children: List.generate(
                        _additionalassignedToControllers.length,
                        (index) {
                          String label = '${_ordinal(index)} assignedTo person';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: label,
                                    controller:
                                        _additionalassignedToControllers[index],

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter $label';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                /////////////////////// Delete button
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
                                    onPressed: () =>
                                        _removeassignedToField(index),
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
                      ],
                    ),
                    const SizedBox(height: 16),

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

                    ////////////////////////////////////////////////////////////////////////////////////////////// Status
                    Row(
                      children: [
                        Text(
                          'Status:',
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
                        const SizedBox(width: 10),

                        //////////////////////////////////////////////////////////// Pending Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedType = 'Completed';
                              });
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 38,
                              decoration: BoxDecoration(
                                color: _selectedType == 'Completed'
                                    ? Colors.teal.shade700
                                    : const Color.fromARGB(255, 233, 255, 251),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.teal.shade700,
                                  width: _selectedType == 'Completed' ? 2.5 : 1,
                                ),
                                boxShadow: _selectedType == 'Completed'
                                    ? [
                                        BoxShadow(
                                          color: Colors.teal.shade900
                                              .withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: _selectedType == 'Completed'
                                      ? Colors.white
                                      : const Color.fromARGB(255, 2, 148, 131),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        //////////////////////////////////////////////////////////// Pending Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedType = 'Pending';
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 38,
                              decoration: BoxDecoration(
                                color: _selectedType == 'Pending'
                                    ? Colors.deepOrange.shade400
                                    : const Color.fromARGB(255, 255, 213, 201),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.deepOrange.shade400,
                                  width: _selectedType == 'Pending' ? 2.5 : 1,
                                ),
                                boxShadow: _selectedType == 'Pending'
                                    ? [
                                        BoxShadow(
                                          color: Colors.deepOrange.shade900
                                              .withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                  color: _selectedType == 'Pending'
                                      ? Colors.white
                                      : const Color.fromARGB(255, 170, 95, 72),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        //////////////////////////////////////////////////////////// In process Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedType = 'In process';
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 38,
                              decoration: BoxDecoration(
                                color: _selectedType == 'In process'
                                    ? Colors.blueGrey.shade900
                                    : const Color.fromARGB(255, 208, 220, 226),

                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.blueGrey.shade900,
                                  width: _selectedType == 'In process'
                                      ? 2.5
                                      : 1,
                                ),
                                boxShadow: _selectedType == 'In process'
                                    ? [
                                        BoxShadow(
                                          color: Colors.blueGrey.shade900
                                              .withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'In process',
                                style: TextStyle(
                                  color: _selectedType == 'In process'
                                      ? Colors.white
                                      : Colors.blueGrey.shade900,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
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
