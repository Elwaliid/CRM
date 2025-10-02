// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class WilouSearchableDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final String? Function(String?)? validator;

  const WilouSearchableDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
    this.validator,
  }) : super(key: key);

  @override
  _WilouSearchableDropdownState createState() =>
      _WilouSearchableDropdownState();
}

class _WilouSearchableDropdownState extends State<WilouSearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(covariant WilouSearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  void _showSearchDialog(BuildContext context) {
    _searchController.clear();
    _filteredItems = widget.items;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search ${widget.label}',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filterItems();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              widget.onChanged(item);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 38, 44, 48);

    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: widget.value),
      validator: widget.validator,
      onTap: () => _showSearchDialog(context),
      style: GoogleFonts.roboto(fontSize: 16, color: primaryColor),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: GoogleFonts.poppins(
          color: primaryColor.withOpacity(0.85),
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
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 41, 49, 53),
            width: 2.0,
          ),
        ),
        suffixIcon: Icon(widget.icon, color: primaryColor),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
