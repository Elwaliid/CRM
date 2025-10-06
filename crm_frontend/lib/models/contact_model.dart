import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ustils/config.dart';

class Contact {
  final String id;
  final String firstname;
  final String lastname;
  final String phone;
  final List<String> phones;
  final String email;
  final String identity;
  final String secondEmail;
  final String address;
  final String notes;
  final String type;
  final String website;
  final bool? isPined;
  Contact({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.phones,
    required this.email,
    required this.identity,
    required this.secondEmail,
    required this.address,
    required this.notes,
    required this.type,
    required this.website,
    this.isPined,
  });

  static Future<List<Contact>> getContacts() async {
    try {
      final response = await http.get(Uri.parse(getContactsUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          List<Contact> contacts = [];
          for (var contactJson in data['contacts']) {
            // Parse name string into firstname and lastname
            String fullName = contactJson['name'] ?? '';
            List<String> nameParts = fullName.split(' ');
            String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
            String lastName = nameParts.length > 1
                ? nameParts.sublist(1).join(' ')
                : '';
            // Get phone from phones array if available
            String phone = '';
            if (contactJson['phones'] != null &&
                contactJson['phones'] is List &&
                contactJson['phones'].isNotEmpty) {
              phone = contactJson['phones'][0];
            }

            contacts.add(
              Contact(
                id: contactJson['_id'].toString(),
                firstname: firstName,
                lastname: lastName,
                phone: phone,
                phones: List<String>.from(contactJson['phones'] ?? []),
                identity: contactJson['identity'] ?? '',
                email: contactJson['email'] ?? '',
                secondEmail: contactJson['secondEmail'] ?? '',
                address: contactJson['address'] ?? '',
                notes: contactJson['notes'] ?? '',
                type: contactJson['type'] ?? '',
                website: contactJson['website'] ?? '',
              ),
            );
          }
          return contacts;
        } else {
          throw Exception('Failed to load contacts: status false');
        }
      } else {
        throw Exception('Failed to load contacts from backend');
      }
    } catch (e) {
      throw Exception('Error fetching contacts: $e');
    }
  }
}
