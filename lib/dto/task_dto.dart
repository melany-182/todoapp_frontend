class TaskDto {
  final int taskId;
  final String title;
  final String description;
  final DateTime? dueDate;
  final DateTime? completedDate;
  final String status;
  final bool archived;
  final int labelId;
  final int userId;

  TaskDto({
    required this.taskId,
    required this.title,
    required this.description,
    this.dueDate,
    this.completedDate,
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
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
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
