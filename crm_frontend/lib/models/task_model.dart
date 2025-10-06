import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ustils/config.dart';

class Task {
  String? id;
  String title;
  String? type;
  double? revenue;
  bool isMeet;
  double? cost;
  String? phone;
  String? email;
  List<String> relatedToNames;
  List<String>? relatedToIds;
  String? dueDate;
  String? time;
  String? endTime;
  String? address;
  String? website;
  String? description;
  String status;
  bool? isPined;

  Task({
    this.id,
    required this.title,
    this.type,
    this.revenue,
    this.cost,
    this.phone,
    this.email,
    required this.isMeet,
    required this.relatedToNames,
    required this.relatedToIds,
    this.dueDate,
    this.time,
    this.endTime,
    this.address,
    this.website,
    this.description,
    this.status = 'Pending',
    this.isPined,
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
                isMeet: taskJson['isMeet'] ?? false,
                phone: taskJson['phone'] ?? '',
                email: taskJson['email'] ?? '',
                relatedToNames: List<String>.from(
                  taskJson['relatedToNames'] ?? [],
                ),
                relatedToIds: List<String>.from(taskJson['relatedToIds'] ?? []),
                dueDate: taskJson['dueDate'] ?? '',
                time: taskJson['time'] ?? '',
                endTime: taskJson['endTime'] ?? '',
                address: taskJson['address'] ?? '',
                website: taskJson['website'] ?? '',
                description: taskJson['description'] ?? '',
                status: taskJson['status'] ?? 'Pending',
                isPined: taskJson['isPined'] ?? false,
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
