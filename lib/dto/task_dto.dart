import 'dart:ffi';

class TaskDto {
  final Long taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime completedDate;
  final String status;
  final bool archived;
  final Long labelId;
  final Long userId;

  TaskDto({
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completedDate,
    required this.status,
    required this.archived,
    required this.labelId,
    required this.userId,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      taskId: json['taskId'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'],
      completedDate: json['completedDate'],
      status: json['status'],
      archived: json['archived'],
      labelId: json['labelId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'completedDate': completedDate,
      'status': status,
      'archived': archived,
      'labelId': labelId,
      'userId': userId,
    };
  }
}
