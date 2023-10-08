class TaskDto {
  final int? taskId;
  final String title;
  final String description;
  final String? dueDate;
  final String? completedDate;
  final String? status;
  final bool? archived;
  final int labelId;
  final int userId;

  TaskDto({
    this.taskId,
    required this.title,
    required this.description,
    this.dueDate,
    this.completedDate,
    this.status,
    this.archived,
    required this.labelId,
    required this.userId,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      taskId: json['taskId'] as int?,
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] as String?,
      completedDate: json['completedDate'] as String?,
      status: json['status'] as String?,
      archived: json['archived'] as bool?,
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
