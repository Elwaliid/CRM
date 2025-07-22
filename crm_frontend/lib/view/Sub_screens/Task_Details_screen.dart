// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print
import 'package:day_night_time_picker/day_night_time_picker.dart';
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
  /// Form key to validate form fields
  final _formKey = GlobalKey<FormState>();
  String? _invalidAssignedName;
  List<String?> _invalidAssignedToNames = [];

  String? _selectedType = 'Pending';
  /////////////////////////////////////////////////////////////Contacts
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

        okStyle: TextStyle(color: Color.fromARGB(255, 62, 80, 88)),
        cancelStyle: TextStyle(color: const Color.fromARGB(255, 62, 80, 88)),
      ),
    );
  }

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

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
                    _buildTextField(
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
                          child: _buildTextField(
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

                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// add to Contacts message and button
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
                                  child: _buildTextField(
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
                    /////////////////////////////// ///////////////////////// ////////////////////////
                    Column(
                      children: _invalidAssignedToNames.map((name) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 1.0),
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
                    _buildTextField(
                      label: 'Due date',
                      controller: _dueDateController,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 16),
                    ///////////////////////////////////////////////////////////// Time
                    _buildTextField(
                      label: 'Time',
                      controller: _timeController,
                      readOnly: true,
                      onTap: _pickTime,
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
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
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
            border: Border.all(
              color: selectedColor,
              width: isSelected ? 2.5 : 1,
            ),
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
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Dialog add contact
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

  /////////////////////////////Type button widget
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
            border: Border.all(
              color: selectedColor,
              width: isSelected ? 2.5 : 1,
            ),
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
                Row(
                  children: [
                    //////////////////////// First Name
                    Expanded(
                      child: _buildTextField(
                        label: 'First Name',
                        controller: _firstNameController,
                        validator: (v) =>
                            v!.isEmpty ? 'Enter first name' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    //////////////////////// Last Name
                    Expanded(
                      child: _buildTextField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        validator: (v) => v!.isEmpty ? 'Enter last name' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                //////////////////////// Identity
                _buildTextField(
                  label: 'Identity (Company, Job Title, etc.)',
                  controller: _identityController,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    //////////////////////////// Primary Phone Number
                    Expanded(
                      child: _buildTextField(
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
                            child: _buildTextField(
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
                      child: _buildTextField(
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
                  _buildTextField(
                    label: 'Second Email',
                    controller: _secondEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v!.contains('@gmail.com') ? null : 'Enter valid email',
                  ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Address
                _buildTextField(
                  label: 'Address',
                  controller: _addressController,
                ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Website
                _buildTextField(
                  label: 'Website',
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                ///////////////////////////////////////////////////////////// Notes
                _buildTextField(
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
                    _buildTypeButton(
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
                    _buildTypeButton(
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
