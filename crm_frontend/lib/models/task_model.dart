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
}
