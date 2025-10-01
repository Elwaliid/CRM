import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ustils/config.dart';

class Task {
  String? id;
  String title;
  String? type;
  double? revenue;
  double? cost;
  String? phone;
  String? email;
  List<String> relatedTo;
  String? dueDate;
  String? time;
  String? endTime;
  String? address;
  String? website;
  String? description;
  String status;

  Task({
    this.id,
    required this.title,
    this.type,
    this.revenue,
    this.cost,
    this.phone,
    this.email,
    required this.relatedTo,
    this.dueDate,
    this.time,
    this.endTime,
    this.address,
    this.website,
    this.description,
    this.status = 'Pending',
  });

  static Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(getTasksUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          List<Task> tasks = [];
          for (var taskJson in data['tasks']) {
            tasks.add(
              Task(
                id: taskJson['_id'].toString(),
                title: taskJson['title'] ?? '',
                type: taskJson['type'] ?? '',
                revenue: taskJson['revenue'] != null
                    ? double.tryParse(taskJson['revenue'].toString())
                    : null,
                cost: taskJson['cost'] != null
                    ? double.tryParse(taskJson['cost'].toString())
                    : null,
                phone: taskJson['phone'] ?? '',
                email: taskJson['email'] ?? '',
                relatedTo: List<String>.from(taskJson['relatedTo'] ?? []),
                dueDate: taskJson['dueDate'] ?? '',
                time: taskJson['time'] ?? '',
                endTime: taskJson['endTime'] ?? '',
                address: taskJson['address'] ?? '',
                website: taskJson['website'] ?? '',
                description: taskJson['description'] ?? '',
                status: taskJson['status'] ?? 'Pending',
              ),
            );
          }
          return tasks;
        } else {
          throw Exception('Failed to load tasks: status false');
        }
      } else {
        throw Exception('Failed to load tasks from backend');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }
}
