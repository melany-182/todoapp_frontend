import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp_frontend/dto/response_dto.dart';
import 'package:todoapp_frontend/dto/task_dto.dart';
import 'package:todoapp_frontend/service/ip/ip.dart' as ip;
import 'package:http/http.dart' as http;

class TaskService {
  static String backendUrlBase = ip.urlBackend;

  static Future<List<TaskDto>> getAllTasks(String token) async {
    List<TaskDto> result;
    var uri = Uri.parse("$backendUrlBase/api/v1/tasks");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var responseDto = ResponseDto.fromJson(jsonDecode(response.body));
      debugPrint("backend response (GET TASKS): ${responseDto.toJson()}");
      if (responseDto.code.toString() == 'TODO-0000') {
        // && responseDto.response != null)
        result = (responseDto.response as List)
            .map((e) => TaskDto.fromJson(e))
            .toList();
        // debugPrint("result: $result");
      } else {
        debugPrint('vino por aquí');
        throw Exception(responseDto.errorMessage);
      }
    } else {
      throw Exception(
          "Error desconocido al intentar obtener los datos de las tareas.");
    }
    return result;
  }

  static Future<ResponseDto> createTask(TaskDto newTask, String token) async {
    ResponseDto result;
    var uri = Uri.parse("$backendUrlBase/api/v1/tasks");
    var body = json.encode(newTask.toJson());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      var responseDto = ResponseDto.fromJson(jsonDecode(response.body));
      debugPrint("backend response (CREATE TASK): ${responseDto.toJson()}");
      if (responseDto.code.toString() == 'TODO-0000') {
        // si la tarea se guardó correctamente
        result = responseDto;
      } else {
        throw Exception(responseDto.errorMessage);
      }
    } else {
      throw Exception('Error desconocido al intentar guardar la tarea.');
    }
    return result;
  }

  static Future<ResponseDto> updateTaskStatusById(
      int taskId, TaskDto newTask, String token) async {
    ResponseDto result;
    var uri = Uri.parse("$backendUrlBase/api/v1/tasks/${taskId.toString()}");
    var body = json.encode(newTask.toJson());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.put(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      var responseDto = ResponseDto.fromJson(jsonDecode(response.body));
      debugPrint(
          "backend response (UPDATE TASK STATUS): ${responseDto.toJson()}");
      if (responseDto.code.toString() == 'TODO-0000') {
        // si la tarea se actualizó correctamente
        result = responseDto;
      } else {
        throw Exception(responseDto.errorMessage);
      }
    } else {
      throw Exception('Error desconocido al intentar actualizar la tarea.');
    }
    return result;
  }
}
