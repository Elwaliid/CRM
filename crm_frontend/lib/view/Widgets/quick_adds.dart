import 'package:crm_frontend/view/Widgets/Type_buttons.dart';
import 'package:crm_frontend/view/Widgets/wiloutextfield.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/////////////////////////////////////////////////////////////////////////////////////////// Dialog add contact
class ClientDetailsFormContent extends StatefulWidget {
  const ClientDetailsFormContent({super.key});

  @override
  State<ClientDetailsFormContent> createState() =>
      _ClientDetailsFormContentState();
}

class _ClientDetailsFormContentState extends State<ClientDetailsFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _identityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _secondEmailController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _otherInfoController = TextEditingController();
  final List<TextEditingController> _additionalPhoneControllers = [];

  bool _secondEmailVisible = true;
  String? _selectedType = 'Client';

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final allPhones = [
        _phoneController.text,
        ..._additionalPhoneControllers.map((c) => c.text),
      ];

      print('Saving client with phones: $allPhones');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Client saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  void _addPhoneField() {
    if (_additionalPhoneControllers.length < 9) {
      setState(() => _additionalPhoneControllers.add(TextEditingController()));
    }
  }

  void _removePhoneField(int index) {
    setState(() {
      _additionalPhoneControllers[index].dispose();
      _additionalPhoneControllers.removeAt(index);
    });
  }

  /////////////////////////// text field widget
  Widget WilouTextField({
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

  /////////////////////////////Type button widget

  /////////////////////////// ordinal
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //////////////////////////////// Quick Add title
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: Text(
                      'Quick Add',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
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
                Row(
                  children: [
                    //////////////////////// First Name
                    Expanded(
                      child: WilouTextField(
                        label: 'First Name',
                        controller: _firstNameController,
                        validator: (v) =>
                            v!.isEmpty ? 'Enter first name' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    //////////////////////// Last Name
                    Expanded(
                      child: WilouTextField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        validator: (v) => v!.isEmpty ? 'Enter last name' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                //////////////////////// Identity
                WilouTextField(
                  label: 'Identity (Company, Job Title, etc.)',
                  controller: _identityController,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    //////////////////////////// Primary Phone Number
                    Expanded(
                      child: WilouTextField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter phone';
                          final pattern = RegExp(r'^(05|06|07)\d{8}\$');
                          return pattern.hasMatch(value)
                              ? null
                              : 'Invalid phone format';
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    //////////////////////////////////////////////////////////////// Add Phone Button
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
                        icon: Icon(Icons.add, color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ////////////////////////////////////////////////// Secondary Phone Numbers
                Column(
                  children: List.generate(_additionalPhoneControllers.length, (
                    index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: WilouTextField(
                              label: '${_ordinal(index)} phone',
                              controller: _additionalPhoneControllers[index],
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                final pattern = RegExp(r'^(05|06|07)\d{8}\$');
                                return pattern.hasMatch(value)
                                    ? null
                                    : 'Invalid format';
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
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
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ////////////////////////////////// Email
                    Expanded(
                      child: WilouTextField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v!.contains('@gmail.com')
                            ? null
                            : 'Enter valid email',
                      ),
                    ),
                    SizedBox(width: 8),
                    /////////////////////////////////// add EMAIL button
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
                            _secondEmailVisible = !_secondEmailVisible;
                          });
                        },
                        icon: Icon(
                          _secondEmailVisible ? Icons.add : Icons.remove,
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
                ///////////////////////////////////////////////////////////// Second Email
                if (!_secondEmailVisible)
                  WilouTextField(
                    label: 'Second Email',
                    controller: _secondEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v!.contains('@gmail.com') ? null : 'Enter valid email',
                  ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Address
                WilouTextField(
                  label: 'Address',
                  controller: _addressController,
                ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Website
                WilouTextField(
                  label: 'Website',
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Notes
                WilouTextField(
                  label: 'Notes',
                  controller: _otherInfoController,
                  maxLines: 4,
                ),
                const SizedBox(height: 28),
                ////////////////////////////////////////////////////////////////////////////////////////////// Type Section
                Row(
                  children: [
                    Text(
                      'Type:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ////////////////////////////// CLient
                    TypeButton(
                      label: 'Client',
                      isSelected: _selectedType == 'Client',
                      selectedColor: Colors.teal.shade700,
                      unselectedColor: const Color(0xFFE9FFFB),
                      selectedTextColor: Colors.white,
                      unselectedTextColor: const Color(0xFF029483),
                      onTap: () => setState(() => _selectedType = 'Client'),
                    ),
                    const SizedBox(width: 6),
                    ///////////////////////////////////// Lead
                    TypeButton(
                      label: 'Lead',
                      isSelected: _selectedType == 'Lead',
                      selectedColor: Colors.deepOrange.shade400,
                      unselectedColor: const Color(0xFFFFD5C9),
                      selectedTextColor: Colors.white,
                      unselectedTextColor: const Color(0xFFAA5F48),
                      onTap: () => setState(() => _selectedType = 'Lead'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                //////////////////////////////////////////////////////////////////////////////////////////////// Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveClient,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Client'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Quick add task

class TaskDetailsFormContent extends StatefulWidget {
  const TaskDetailsFormContent({super.key});

  @override
  State<TaskDetailsFormContent> createState() => _TaskDetailsFormContentState();
}

class _TaskDetailsFormContentState extends State<TaskDetailsFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  final List<TextEditingController> _additionalAssignedToControllers = [];
  final _dueDateController = TextEditingController();
  final _timeController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _selectedStatus = 'Pending';
  List<String> contacts = [
    'faisal mouh',
    'khalil kaba',
    'lisa luisa',
    'bounar l7agar',
  ];
  List<String?> _invalidAssignedNames = [];

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Gather all assigned names
      final allAssignedTo = [
        _assignedToController.text,
        ..._additionalAssignedToControllers.map((c) => c.text),
      ];

      print('Saving task with assigned to: $allAssignedTo');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Task saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  void _addAssignedToField() {
    if (_additionalAssignedToControllers.length < 9) {
      setState(
        () => _additionalAssignedToControllers.add(TextEditingController()),
      );
    }
  }

  void _removeAssignedToField(int index) {
    setState(() {
      _additionalAssignedToControllers[index].dispose();
      _additionalAssignedToControllers.removeAt(index);
    });
  }

  /////////////////////////////////////////////// Dynamic time picker
  Future<void> _pickTime() async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
        sunrise: Time(hour: 5, minute: 20), // optional
        sunset: Time(hour: 19, minute: 55), // optional
        duskSpanInMinutes: 120,
        onChange: (Time newTime) {
          setState(() {
            final timeOfDay = TimeOfDay(
              hour: newTime.hour,
              minute: newTime.minute,
            );
            _timeController.text = timeOfDay.format(context);
          });
        },
        is24HrFormat: true,

        accentColor: const Color.fromARGB(255, 62, 80, 88),

        okStyle: TextStyle(color: Colors.blueGrey.shade900),
        cancelStyle: TextStyle(color: Colors.blueGrey.shade900),
      ),
    );
  }

  /////////////////////////////////// date picker
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2075),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueGrey.shade900, // Header background
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black87, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(
                  255,
                  0,
                  0,
                  0,
                ), // Button text color
              ),
            ),
            dialogBackgroundColor: const Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // Background color
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: Text(
                      'Add New Task',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
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

                // Task Name
                WilouTextField(
                  label: 'Task Name',
                  controller: _taskNameController,
                  validator: (v) => v!.isEmpty ? 'Enter task name' : null,
                ),
                const SizedBox(height: 12),

                // Assigned To
                Row(
                  children: [
                    Expanded(
                      child: WilouTextField(
                        label: 'Assigned To',
                        controller: _assignedToController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          if (!contacts.contains(value)) {
                            if (!_invalidAssignedNames.contains(value)) {
                              setState(() {
                                _invalidAssignedNames.add(value);
                              });
                            }
                            return null;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Add Assigned To button
                    Container(
                      decoration: BoxDecoration(
                        color: _additionalAssignedToControllers.length < 9
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
                        onPressed: _additionalAssignedToControllers.length < 9
                            ? _addAssignedToField
                            : null,
                        icon: Icon(Icons.add, color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),

                // Invalid assigned names messages
                if (_invalidAssignedNames.isNotEmpty)
                  Column(
                    children: _invalidAssignedNames.map((name) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              '"$name" not found in contacts.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              ' Add "$name" to contacts?',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF262C30),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // You can implement adding to contacts here
                              },
                              label: const Text(
                                'Yes',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                minimumSize: const Size(0, 26),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),

                // Additional Assigned To fields
                Column(
                  children: List.generate(
                    _additionalAssignedToControllers.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: WilouTextField(
                                label: '${_ordinal(index)} Assigned To',
                                controller:
                                    _additionalAssignedToControllers[index],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  if (!contacts.contains(value)) {
                                    if (!_invalidAssignedNames.contains(
                                      value,
                                    )) {
                                      setState(() {
                                        _invalidAssignedNames.add(value);
                                      });
                                    }
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Remove button
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
                                onPressed: () => _removeAssignedToField(index),
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

                // Due Date
                WilouTextField(
                  label: 'Due Date',
                  controller: _dueDateController,
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 12),

                // Time
                WilouTextField(
                  label: 'Time',
                  controller: _timeController,
                  readOnly: true,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 12),

                // Address
                WilouTextField(
                  label: 'Address',
                  controller: _addressController,
                ),
                const SizedBox(height: 12),

                // Website
                WilouTextField(
                  label: 'Website',
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),

                // Task Description
                WilouTextField(
                  label: 'Task Description',
                  controller: _taskDescriptionController,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // Status Selection
                Row(
                  children: [
                    Text(
                      'Status:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TypeButton(
                      label: 'Completed',
                      isSelected: _selectedStatus == 'Completed',
                      selectedColor: Colors.teal.shade700,
                      unselectedColor: const Color(0xFFE9FFFB),
                      selectedTextColor: Colors.white,
                      unselectedTextColor: const Color(0xFF029483),
                      onTap: () =>
                          setState(() => _selectedStatus = 'Completed'),
                    ),
                    const SizedBox(width: 6),
                    TypeButton(
                      label: 'Pending',
                      isSelected: _selectedStatus == 'Pending',
                      selectedColor: Colors.deepOrange.shade400,
                      unselectedColor: const Color(0xFFFFD5C9),
                      selectedTextColor: Colors.white,
                      unselectedTextColor: const Color(0xFFAA5F48),
                      onTap: () => setState(() => _selectedStatus = 'Pending'),
                    ),
                    const SizedBox(width: 6),
                    TypeButton(
                      label: 'In Progress',
                      isSelected: _selectedStatus == 'In Progress',
                      selectedColor: primaryColor,
                      unselectedColor: const Color(0xFFD9DDE0),
                      selectedTextColor: Colors.white,
                      unselectedTextColor: primaryColor,
                      onTap: () =>
                          setState(() => _selectedStatus = 'In Progress'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save, size: 24, color: Colors.white),
                    label: Text(
                      'Save Task',
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
