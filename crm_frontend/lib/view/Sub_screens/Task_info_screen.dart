// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print
import 'package:calendar_view/calendar_view.dart';
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

  String? _selectedType = 'Pending';
  List Contacts = ['faisal mouh', 'khalil kaba', 'lisa luisa', 'bounar l7agar'];
  /////////////////////////////////////////////////////////////////////////////////// Controllers for all input fields
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  /// Dynamic list of additional assignedTo controllers
  final List<TextEditingController> _additionalassignedToControllers = [];
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

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
                            label: 'AssignedTo(Full Name)',
                            controller: _assignedToController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid name';
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
                    SizedBox(height: 8),
                    ///////////////////////////////////////////////////////////// Secondary assignedTo numbers
                    Column(
                      children: List.generate(
                        _additionalassignedToControllers.length,
                        (index) {
                          String label = '${_ordinal(index)} AssignedTo';
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
                    ///////////////////////////////////////////////////////////// Due date
                    TextField(controller: _dueDateController, label),
                    const SizedBox(height: 16),
                    ///////////////////////////////////////////////////////////// Time
                    _buildTextField(label: 'Time', controller: _timeController),
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
                    ///////////////////////////////////////////////////////////// Task Description
                    _buildTextField(
                      label: 'Task description',
                      controller: _taskDescriptionController,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 28),
                    ////////////////////////////////////////////////////////////////////////////////////////////// Status Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusButton(
                                label: 'Completed',
                                isSelected: _selectedType == 'Completed',
                                selectedColor: Colors.teal.shade700,
                                unselectedColor: const Color(0xFFE9FFFB),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFF029483),
                                onTap: () =>
                                    setState(() => _selectedType = 'Completed'),
                              ),
                              _buildStatusButton(
                                label: 'Pending',
                                isSelected: _selectedType == 'Pending',
                                selectedColor: Colors.deepOrange.shade400,
                                unselectedColor: const Color(0xFFFFD5C9),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFFAA5F48),
                                onTap: () =>
                                    setState(() => _selectedType = 'Pending'),
                              ),
                              _buildStatusButton(
                                label: 'In process',
                                isSelected: _selectedType == 'In process',
                                selectedColor: Colors.blueGrey.shade900,
                                unselectedColor: const Color(0xFFD9DDE0),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: Colors.blueGrey.shade900,
                                onTap: () => setState(
                                  () => _selectedType = 'In process',
                                ),
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

///////////////////////////////////////////// Status button
Widget _buildStatusButton({
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
        height: 42,
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

/////////////////////////////////// date table
Future<void> _selectDate() async {
  await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2050),
  );
}
