import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/dto/task_dto.dart';

class TaskState {
  final PageStatus status;
  final List<TaskDto> data;
  final String? errorMessage;

  const TaskState({
    this.status = PageStatus.initial,
    this.data = const [],
    this.errorMessage,
  });

  TaskState copyWith({
    PageStatus? status,
    List<TaskDto>? data,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Object?> get props => [
        status,
        data,
        errorMessage,
      ];
}
