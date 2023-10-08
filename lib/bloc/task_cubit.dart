import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/bloc/task_state.dart';
import 'package:todoapp_frontend/dto/response_dto.dart';
import 'package:todoapp_frontend/dto/task_dto.dart';
import 'package:todoapp_frontend/service/task_service.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState());

  Future<void> getAllTasks() async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      final result = await TaskService.getAllTasks(token!);
      emit(state.copyWith(
        status: PageStatus.success,
        data: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> createTask(TaskDto newTask) async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      ResponseDto response = await TaskService.createTask(newTask, token!);
      debugPrint("response (aquí, add task cubit): ${response.toJson()}");
      emit(state.copyWith(
        status: PageStatus.success,
        data: await TaskService.getAllTasks(
            token), // actualización de la lista de tareas // esto es importante
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateTaskStatusById(int taskId) async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      ResponseDto response =
          await TaskService.updateTaskStatusById(taskId, token!);
      debugPrint("response (aquí, update task cubit): ${response.toJson()}");
      emit(state.copyWith(
        status: PageStatus.success,
        data: await TaskService.getAllTasks(
            token), // actualización de la lista de tareas // esto es importante
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
