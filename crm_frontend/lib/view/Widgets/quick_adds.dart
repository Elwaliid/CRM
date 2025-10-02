import 'package:crm_frontend/view/Widgets/Type_buttons.dart';
import 'package:crm_frontend/view/Widgets/date_time_picker.dart';
import 'package:crm_frontend/view/Widgets/wilou_textfield.dart';

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

///////////////////////////////////////// controllers
class _ClientDetailsFormContentState extends State<ClientDetailsFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _qcFirstNameController = TextEditingController();
  final _qcLastNameController = TextEditingController();
  final _qcIdentityController = TextEditingController();
  final _qcPhoneController = TextEditingController();
  final _qcEmailController = TextEditingController();
  final _qcSecondEmailController = TextEditingController();
  final _qcAddressController = TextEditingController();
  final _qcWebsiteController = TextEditingController();
  final _qcOtherInfoController = TextEditingController();
  final List<TextEditingController> _qcAdditionalPhoneControllers = [];

  bool _secondEmailVisible = true;
  String? _selectedType = 'Client';

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final allPhones = [
        _qcPhoneController.text,
        ..._qcAdditionalPhoneControllers.map((c) => c.text),
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
    if (_qcAdditionalPhoneControllers.length < 9) {
      setState(
        () => _qcAdditionalPhoneControllers.add(TextEditingController()),
      );
    }
  }

  void _removePhoneField(int index) {
    setState(() {
      _qcAdditionalPhoneControllers[index].dispose();
      _qcAdditionalPhoneControllers.removeAt(index);
    });
  }

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
                        controller: _qcFirstNameController,
                        validator: (v) =>
                            v!.isEmpty ? 'Enter first name' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    //////////////////////// Last Name
                    Expanded(
                      child: WilouTextField(
                        label: 'Last Name',
                        controller: _qcLastNameController,
                        validator: (v) => v!.isEmpty ? 'Enter last name' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                //////////////////////// Identity
                WilouTextField(
                  label: 'Identity (Company, Job Title, etc.)',
                  controller: _qcIdentityController,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    //////////////////////////// Primary Phone Number
                    Expanded(
                      child: WilouTextField(
                        label: 'Phone Number',
                        controller: _qcPhoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter phone';
                          final pattern = RegExp(r'^(05|06|07)\d{8}$');
                          if (!pattern.hasMatch(value)) {
                            return 'Phone number must start with 05, 06, or 07 and be 10 digits';
                          }
                          return null;
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
                        color: _qcAdditionalPhoneControllers.length < 9
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
                        onPressed: _qcAdditionalPhoneControllers.length < 9
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
                  children: List.generate(
                    _qcAdditionalPhoneControllers.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: WilouTextField(
                                label: '${_ordinal(index)} phone',
                                controller:
                                    _qcAdditionalPhoneControllers[index],
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
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ////////////////////////////////// Email
                    Expanded(
                      child: WilouTextField(
                        label: 'Email',
                        controller: _qcEmailController,
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
                    controller: _qcSecondEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v!.contains('@gmail.com') ? null : 'Enter valid email',
                  ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Address
                WilouTextField(
                  label: 'Address',
                  controller: _qcAddressController,
                ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Website
                WilouTextField(
                  label: 'Website',
                  controller: _qcWebsiteController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Notes
                WilouTextField(
                  label: 'Notes',
                  controller: _qcOtherInfoController,
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
                    const SizedBox(width: 6),
                    ////////////////////////////////////////////// In Progress
                    TypeButton(
                      label: 'Vendor',
                      isSelected: _selectedType == 'Vendor',
                      selectedColor: primaryColor,
                      unselectedColor: const Color(0xFFD9DDE0),
                      selectedTextColor: Colors.white,
                      unselectedTextColor: primaryColor,
                      onTap: () => setState(() => _selectedType = 'Vendor'),
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Quick Add Task Dialog
class TaskDetailsFormContent extends StatefulWidget {
  const TaskDetailsFormContent({super.key});

  @override
  State<TaskDetailsFormContent> createState() => _TaskDetailsFormContentState();
}

class _TaskDetailsFormContentState extends State<TaskDetailsFormContent> {
  ////////////////////// Form Key & Controllers
  final _formKey = GlobalKey<FormState>();
  final _qtTaskNameController = TextEditingController();
  final _qtTaskDescriptionController = TextEditingController();
  final _qtAssignedToController = TextEditingController();
  final List<TextEditingController> _qtAdditionalAssignedToControllers = [];
  final _qtDueDateController = TextEditingController();
  final _qtTimeController = TextEditingController();
  final _qtAddressController = TextEditingController();
  final _qtWebsiteController = TextEditingController();

  ////////////////////// Dummy Contacts List
  String? _selectedStatus = 'Pending';
  List<String> contacts = [
    'faisal mouh',
    'khalil kaba',
    'lisa luisa',
    'bounar l7agar',
  ];
  List<String?> _qtInvalidAssignedNames = [];

  ///////////////////////////////////////////////// Save Task
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final allAssignedTo = [
        _qtAssignedToController.text,
        ..._qtAdditionalAssignedToControllers.map((c) => c.text),
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

  ////////////////////////////////////////////// Add Assigned To Field
  void _addAssignedToField() {
    if (_qtAdditionalAssignedToControllers.length < 9) {
      setState(
        () => _qtAdditionalAssignedToControllers.add(TextEditingController()),
      );
    }
  }

  ////////////////////////////////////////////// Remove Assigned To Field
  void _removeAssignedToField(int index) {
    setState(() {
      _qtAdditionalAssignedToControllers[index].dispose();
      _qtAdditionalAssignedToControllers.removeAt(index);
    });
  }

  ////////////////////////////////////////////// Time Picker Handler
  Future<void> _pickTime() async {
    await TimePickerHelper.pickCustomTime(
      context: context,
      controller: _qtTimeController,
      onTimeSelected: (time) {
        print("Time picked: ${time.format(context)}");
      },
    );
  }

  ////////////////////////////////////////////// Date Picker Handler
  Future<void> _selectDate() async {
    final pickedDate = await DatePickerHelper.showCustomDatePicker(
      context: context,
    );
    if (pickedDate != null) {
      setState(() {
        _qtDueDateController.text = pickedDate
            .toIso8601String()
            .split('T')
            .first;
      });
    }
  }

  ////////////////////////////////////////////// Ordinal Labels for Assigned To fields
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
                ////////////////////////////////////////////// Title
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

                ////////////////////////////////////////////// Task Name
                WilouTextField(
                  label: 'Task Name',
                  controller: _qtTaskNameController,
                  validator: (v) => v!.isEmpty ? 'Enter task name' : null,
                ),
                const SizedBox(height: 12),

                ////////////////////////////////////////////// Assigned To (Primary)
                Row(
                  children: [
                    Expanded(
                      child: WilouTextField(
                        label: 'Assigned To',
                        controller: _qtAssignedToController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          if (!contacts.contains(value)) {
                            if (!_qtInvalidAssignedNames.contains(value)) {
                              setState(() {
                                _qtInvalidAssignedNames.add(value);
                              });
                            }
                            return null;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    ////////////////////////////////////////////////////////////// Add Assigned To Button
                    Container(
                      decoration: BoxDecoration(
                        color: _qtAdditionalAssignedToControllers.length < 9
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
                        onPressed: _qtAdditionalAssignedToControllers.length < 9
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
                SizedBox(height: 10),
                ////////////////////////////////////////////// Additional Assigned To fields
                Column(
                  children: List.generate(
                    _qtAdditionalAssignedToControllers.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: WilouTextField(
                                label: '${_ordinal(index)} Assigned To',
                                controller:
                                    _qtAdditionalAssignedToControllers[index],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  if (!contacts.contains(value)) {
                                    if (!_qtInvalidAssignedNames.contains(
                                      value,
                                    )) {
                                      setState(() {
                                        _qtInvalidAssignedNames.add(value);
                                      });
                                    }
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),

                            ////////////////////////////////////////////////// Remove Field Button
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
                const SizedBox(height: 1),
                ////////////////////////////////////////////// Add it from quick add client
                if (_qtInvalidAssignedNames.isNotEmpty)
                  Column(
                    children: _qtInvalidAssignedNames.map((name) {
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
                              ' Add "$name" from quick add clients.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF262C30),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 8),
                ////////////////////////////////////////////// Due Date Picker
                WilouTextField(
                  label: 'Due Date',
                  controller: _qtDueDateController,
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 12),

                ////////////////////////////////////////////// Time Picker
                WilouTextField(
                  label: 'Time',
                  controller: _qtTimeController,
                  readOnly: true,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 12),

                ////////////////////////////////////////////// Address
                WilouTextField(
                  label: 'Address',
                  controller: _qtAddressController,
                ),
                const SizedBox(height: 12),

                ////////////////////////////////////////////// Website
                WilouTextField(
                  label: 'Website',
                  controller: _qtWebsiteController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),

                ////////////////////////////////////////////// Task Description
                WilouTextField(
                  label: 'Task Description',
                  controller: _qtTaskDescriptionController,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                ////////////////////////////////////////////// Status Selection
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
                    ////////////////////////////////////////////// Completed
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
                    ////////////////////////////////////////////// Pending
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
                    ////////////////////////////////////////////// In Progress
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

                ////////////////////////////////////////////// Save Task Button
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
