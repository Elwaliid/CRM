// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print
import 'package:crm_frontend/view/Widgets/Type_buttons.dart';
import 'package:crm_frontend/view/Widgets/date_time_picker.dart';
import 'package:crm_frontend/view/Widgets/quick_adds.dart';
import 'package:crm_frontend/view/Widgets/wilou_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen for adding/updating Client or Lead info
class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _invalidAssignedName;
  List<String?> _invalidAssignedToNames = [];
  String? _selectedType = 'Pending';
  List Contacts = ['faisal mouh', 'khalil kaba', 'lisa luisa', 'bounar l7agar'];

  /////////////////////////////////////////////////////////////////////////////////// Controllers for all input fields
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  final List<TextEditingController> _additionalassignedToControllers = [];
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
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

  /// Save button logic
  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      // 👇 Gather all assignedTo numbers into a list

      // 🧭 Example: print or send this to backend

      // Show confirmation to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Updates saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
                    WilouTextField(
                      label: 'Task Title',
                      controller: _taskNameController,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Task Title';
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
                          child: WilouTextField(
                            label: 'AssignedTo(Full Name)',
                            controller: _assignedToController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              // Validation only, do not call setState here
                              if (!Contacts.contains(value)) {
                                setState(() {
                                  _invalidAssignedName = value;
                                });
                                // Return null to avoid default error text display
                                return null;
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

                    ///////////////////////////////////////////////////////// add to Contacts message and button
                    if (_invalidAssignedName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Text(
                              '"$_invalidAssignedName" not found in contacts.',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),

                            Text(
                              ' Add "${_invalidAssignedName!}" to your contacts?',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 38, 44, 48),
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
                                    child: SizedBox(
                                      width: 600,
                                      height: 700,
                                      child: ClientDetailsFormContent(),
                                    ),
                                  ),
                                );
                              },

                              label: const Text(
                                'Yes',
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
                                  child: WilouTextField(
                                    label: label,
                                    controller:
                                        _additionalassignedToControllers[index],

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter $label';
                                      }
                                      if (!Contacts.contains(value)) {
                                        if (!_invalidAssignedToNames.contains(
                                          value,
                                        )) {
                                          setState(() {
                                            _invalidAssignedToNames.add(value);
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
                    ///////////// ///////////// ////////// Secondary assignedTo add to Contacts message and button
                    Column(
                      children: _invalidAssignedToNames.map((name) {
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
                                ' Add "$name" to your contacts?',
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
                    ///////////////////////////////////////////////////////////// Time
                    WilouTextField(
                      label: 'Time',
                      controller: _timeController,
                      readOnly: true,
                      onTap: _pickTime,
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
