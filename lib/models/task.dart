class Task {
  int? id;
  String? title;
  String? description;
  int? assignedTo;
  String? dateAssigned;
  String? dueDate;
  String? status;

  Task({
    this.id,
    this.title,
    this.description,
    this.assignedTo,
    this.dateAssigned,
    this.dueDate,
    this.status,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['work_id'];
    title = json['title'];
    description = json['description'];
    assignedTo = json['assigned_to'];
    dateAssigned = json['date_assigned'];
    dueDate = json['due_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['assigned_to'] = this.assignedTo;
    data['date_assigned'] = this.dateAssigned;
    data['due_date'] = this.dueDate;
    data['status'] = this.status;
    return data;
  }
}
