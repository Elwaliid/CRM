// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print, prefer_final_fields, non_constant_identifier_names, use_build_context_synchronously
import 'dart:convert';

import 'package:crm_frontend/models/task_model.dart';
import 'package:crm_frontend/ustils/config.dart';
import 'package:crm_frontend/ustils/constants.dart';
import 'package:crm_frontend/view/Widgets/Type_buttons.dart';
import 'package:crm_frontend/view/Widgets/date_time_picker.dart';
import 'package:crm_frontend/view/Widgets/quick_adds.dart';
import 'package:crm_frontend/view/Widgets/wilou_dropdown.dart';
import 'package:crm_frontend/view/Widgets/wilou_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

/// Screen for adding/updating Client or Lead info
class TaskDetailsScreen extends StatefulWidget {
  final Task? task;

  const TaskDetailsScreen({super.key, this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _invalidRelatedTo;
  String? _selectedTaskType;
  Set<String> _invalidRelatedToNames = {};
  String? _selectedType = 'Pending';
  List Contacts = ['faisal mouh', 'khalil kaba', 'lisa luisa', 'bounar l7agar'];
  bool phone = false;
  bool email = false;
  bool isViewMode = false;
  /////////////////////////////////////////////////////////////////////////////////// Controllers for all input fields
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _RelatedToController = TextEditingController();
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final List<TextEditingController> _additionalRelatedToControllers = [];
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _endtimeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  /////////////////////////////////////////////// Dynamic time picker
  Future<void> _pickTime() async {
    await TimePickerHelper.pickCustomTime(
      context: context,
      controller: _timeController,
      onTimeSelected: (time) {
        print("Time picked: ${time.format(context)}");
      },
    );
  }

  Future<void> _pickTime1() async {
    await TimePickerHelper.pickCustomTime(
      context: context,
      controller: _endtimeController,
      onTimeSelected: (time) {
        print("Time picked: ${time.format(context)}");
      },
    );
  }

  ////////////////////// select Date
  Future<void> _selectDate() async {
    final pickedDate = await DatePickerHelper.showCustomDatePicker(
      context: context,
    );
    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  /// Add new RelatedTo number field
  void _addRelatedToField() {
    if (_additionalRelatedToControllers.length < 9) {
      setState(() {
        _additionalRelatedToControllers.add(TextEditingController());
      });
    }
  }

  /// Remove a specific RelatedTo number field
  void _removeRelatedToField(int index) {
    setState(() {
      String text = _additionalRelatedToControllers[index].text;
      _additionalRelatedToControllers[index].dispose();
      _additionalRelatedToControllers.removeAt(index);
      _invalidRelatedToNames.remove(text);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      isViewMode = true;
      _taskNameController.text = widget.task!.title;
      _selectedTaskType = widget.task!.type;
      _revenueController.text = widget.task!.revenue?.toString() ?? '';
      _costController.text = widget.task!.cost?.toString() ?? '';
      _phoneController.text = widget.task!.phone ?? '';
      _EmailController.text = widget.task!.email ?? '';
      // Add additional relatedTo
      if (widget.task!.relatedTo.isNotEmpty) {
        _RelatedToController.text = widget.task!.relatedTo[0];
        for (int i = 1; i < widget.task!.relatedTo.length; i++) {
          _additionalRelatedToControllers.add(
            TextEditingController(text: widget.task!.relatedTo[i]),
          );
        }
      }
      _dueDateController.text = widget.task!.dueDate ?? '';
      _timeController.text = widget.task!.time ?? '';
      _endtimeController.text = widget.task!.endTime ?? '';
      _addressController.text = widget.task!.address ?? '';
      _websiteController.text = widget.task!.website ?? '';
      _taskDescriptionController.text = widget.task!.description ?? '';
      _selectedType = widget.task!.status;
    }
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
                          isViewMode ? 'view/Update Task' : 'Add Task',
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
                    Row(
                      children: [
                        Expanded(
                          child: WilouTextField(
                            label: 'Task Title',
                            controller: _taskNameController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Task Title';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        /////////////////////////////////////////////////////////// Task Type
                        Expanded(
                          child: WilouDropdown(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Task Title';
                              }
                              return null;
                            },
                            label: 'Task Type',
                            value: _selectedTaskType,
                            items: const [
                              'Meeting',
                              'Call/Message',
                              'Email',
                              'Deal',
                              'Other',
                            ],
                            icon:
                                _selectedTaskType == null ||
                                    _selectedTaskType == 'Other'
                                ? Icons.arrow_drop_down
                                : _selectedTaskType == 'Meeting'
                                ? Icons.groups
                                : _selectedTaskType == 'Call/Message'
                                ? Icons.call
                                : _selectedTaskType == 'Email'
                                ? Icons.email
                                : Icons.business,
                            onChanged: (value) {
                              setState(() {
                                _selectedTaskType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._buildConditionalFields(),
                    const SizedBox(height: 12),

                    ///////////////////////////////////////////////////////////// Primary RelatedTo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: WilouTextField(
                            label: 'RelatedTo(Full Name)',
                            controller: _RelatedToController,
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  !Contacts.contains(value)) {
                                setState(() {
                                  _invalidRelatedTo = value;
                                });
                              } else {
                                setState(() {
                                  _invalidRelatedTo = null;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        //////////////////////////////////// add icon button of RelatedTo
                        Container(
                          decoration: BoxDecoration(
                            color: _additionalRelatedToControllers.length < 9
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
                                _additionalRelatedToControllers.length < 9
                                ? _addRelatedToField
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

                    ///////////////////////////////////////////////////////// add to Contacts message and button
                    if (_invalidRelatedTo != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Text(
                              '"add a new contact?',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),

                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SizedBox(
                                      width: 600,
                                      height: 700,
                                      child: ClientDetailsFormContent(),
                                    ),
                                  ),
                                );
                              },

                              label: const Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 12, // 🔽 Smaller text
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade900,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                minimumSize: Size(0, 26),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                elevation: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 8),

                    ///////////////////////////////////////////////////////////// Secondary RelatedTo numbers
                    Column(
                      children: List.generate(
                        _additionalRelatedToControllers.length,
                        (index) {
                          String label = '${_ordinal(index)} RelatedTo';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: WilouTextField(
                                    label: label,
                                    controller:
                                        _additionalRelatedToControllers[index],

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter $label';
                                      }
                                      if (!Contacts.contains(value)) {
                                        if (!_invalidRelatedToNames.contains(
                                          value,
                                        )) {
                                          setState(() {
                                            _invalidRelatedToNames.add(value);
                                          });
                                        }
                                        return null; // Let the UI handle the error display
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
                                        _removeRelatedToField(index),
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
                    ///////////// ///////////// ////////// Secondary RelatedTo add to Contacts message and button
                    Column(
                      children: _invalidRelatedToNames.map((name) {
                        return Padding(
                          padding: const EdgeInsets.only(top: .0),
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
                                ' Add "$name"?',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF262C30),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const SizedBox(
                                        width: 600,
                                        height: 700,
                                        child: ClientDetailsFormContent(),
                                      ),
                                    ),
                                  );
                                },
                                label: const Text(
                                  'Yes',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade900,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(0, 26),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  elevation: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),

                    ///////////////////////////////////////////////////////////// Due date
                    WilouTextField(
                      label: 'Due date',
                      controller: _dueDateController,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 16),
                    ///////////////////////////////////////////////////////////// Time & End Time
                    Row(
                      children: [
                        Expanded(
                          child: WilouTextField(
                            label: 'Time',
                            controller: _timeController,
                            readOnly: true,
                            onTap: _pickTime,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: WilouTextField(
                            label: 'End time',
                            controller: _endtimeController,
                            readOnly: true,
                            onTap: _pickTime1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                    ///////////////////////////////////////////////////////////// Task Description
                    WilouTextField(
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
                              TypeButton(
                                label: 'Completed',
                                isSelected: _selectedType == 'Completed',
                                selectedColor: Colors.teal.shade700,
                                unselectedColor: const Color(0xFFE9FFFB),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFF029483),
                                onTap: () =>
                                    setState(() => _selectedType = 'Completed'),
                              ),
                              TypeButton(
                                label: 'Pending',
                                isSelected: _selectedType == 'Pending',
                                selectedColor: Colors.deepOrange.shade400,
                                unselectedColor: const Color(0xFFFFD5C9),
                                selectedTextColor: Colors.white,
                                unselectedTextColor: const Color(0xFFAA5F48),
                                onTap: () =>
                                    setState(() => _selectedType = 'Pending'),
                              ),
                              TypeButton(
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
                        onPressed: _addUpdateTask,
                        icon: Icon(Icons.save, size: 24, color: Colors.white),
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
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////// Conditional fields based on Task Type
  List<Widget> _buildConditionalFields() {
    List<Widget> widgets = [];
    if (_selectedTaskType == 'Deal') {
      widgets.add(
        Row(
          children: [
            Expanded(
              child: WilouTextField(
                label: 'Revenue',
                icon: Icons.trending_up,
                controller: _revenueController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                '&',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ),
            Expanded(
              child: WilouTextField(
                label: 'Cost',
                icon: Icons.trending_down,
                controller: _costController,
              ),
            ),
          ],
        ),
      );
    }
    if (_selectedTaskType == 'Call/Message') {
      widgets.add(
        Row(
          children: [
            Text(
              ' Number of a persone not in contacts?',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  phone = !phone;
                });
              },
              label: phone
                  ? Text(
                      'No',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                minimumSize: Size(0, 26),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                elevation: 0.5,
              ),
            ),
          ],
        ),
      );
      if (phone == true) {
        widgets.add(
          WilouTextField(
            label: 'Phone number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
        );
      }
    }

    if (_selectedTaskType == 'Email') {
      widgets.add(
        Row(
          children: [
            SizedBox(width: 12),
            Text(
              ' Email of a persone not in contacts?',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  email = !email;
                });
              },
              label: email
                  ? Text(
                      'No',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                minimumSize: Size(0, 26),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                elevation: 0.5,
              ),
            ),
          ],
        ),
      );
      if (email == true) {
        widgets.add(
          WilouTextField(
            label: 'Email',
            controller: _EmailController,
            keyboardType: TextInputType.emailAddress,
          ),
        );
      }
    }

    // Now, insert SizedBox between them
    List<Widget> result = [];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(const SizedBox(height: 12));
      }
    }
    return result;
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

  ///////////////////////////////////////////////////////////// Add or Update Task
  Future<void> _addUpdateTask() async {
    if (_formKey.currentState!.validate()) {
      var relatedToList = [
        _RelatedToController.text.trim(),
        ..._additionalRelatedToControllers
            .map((c) => c.text.trim())
            .where((related) => related.isNotEmpty),
      ];

      var logBody = {
        'title': _taskNameController.text.trim(),
        'type': _selectedTaskType,
        'revenue': _revenueController.text.isNotEmpty
            ? double.tryParse(_revenueController.text.trim())
            : null,
        'cost': _costController.text.isNotEmpty
            ? double.tryParse(_costController.text.trim())
            : null,
        'phone': _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        'email': _EmailController.text.trim().isNotEmpty
            ? _EmailController.text.trim()
            : null,
        'relatedTo': relatedToList,
        'dueDate': _dueDateController.text.trim(),
        'time': _timeController.text.trim(),
        'endTime': _endtimeController.text.trim(),
        'address': _addressController.text.trim(),
        'website': _websiteController.text.trim(),
        'description': _taskDescriptionController.text.trim(),
        'status': _selectedType ?? 'Pending',
      };
      if (isViewMode && widget.task != null) {
        logBody['id'] = widget.task!.id;
      }
      try {
        var response = await http.post(
          Uri.parse(addOrUpdateTaskUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(logBody),
        );
        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseData['message']),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            isViewMode = false;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseData['message']),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save task. Please try again.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error. Please try again later.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
