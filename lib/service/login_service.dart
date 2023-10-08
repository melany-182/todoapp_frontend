import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp_frontend/dto/login_response_dto.dart';
import 'package:todoapp_frontend/dto/response_dto.dart';
import 'package:todoapp_frontend/service/ip/ip.dart' as ip;
import 'package:http/http.dart' as http;

class LoginService {
  static String backendUrlBase = ip.urlBackend; // url del backend

  static Future<LoginResponseDto> login(
      String username, String password) async {
    LoginResponseDto result;
    var uri = Uri.parse('$backendUrlBase/api/v1/auth/login');
    var body = jsonEncode({
      'username': username,
      'password': password,
    });
    // los headers son necesarios para Java Spring Boot
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(uri,
        headers: headers, body: body); // invocación al backend
    // debugPrint('Respuesta del backend: ${response.body}');
    if (response.statusCode == 200) {
      debugPrint(
          'Respuesta 200 del backend (exitoso).'); // 200 significa que el backend procesó la solicitud correctamente
      var responseDto = ResponseDto.fromJson(jsonDecode(response
          .body)); // aquí ya no existe statusCode, dado que ya se decodificó
      // debugPrint("AQUÍ: ${responseDto.code.toString()}");
      if (responseDto.code.toString() == 'TODO-0000') {
        // si el backend autenticó al usuario
        result = LoginResponseDto.fromJson(
            responseDto.response); // ESTO es lo que se retorna al cubit
        debugPrint('resultado de autenticación correcta: ${result.toJson()}');
      } else {
        throw Exception(responseDto.errorMessage);
      }
    } else {
      debugPrint('Error de estado del backend: ${response.statusCode}');
      throw Exception(
          'Error en el proceso de Login. Código de estado: ${response.statusCode}. Mensaje: ${response.body}');
    }
    return result;
  }
}
