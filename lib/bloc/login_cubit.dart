import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/dto/login_response_dto.dart';
import 'package:todoapp_frontend/service/login_service.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage(); // para mantener los tokens seguros
    try {
      LoginResponseDto loginResponse = await LoginService.login(
          username, password); // devuelve {authToken, refreshToken}
      await storage.write(key: "AuthToken", value: loginResponse.authToken);
      await storage.write(
        key: "RefreshToken",
        value: loginResponse.refreshToken,
      ); // TODO: refrescar el token cada cierto tiempo
      emit(state.copyWith(
        status: PageStatus.success,
        loginSuccess: true,
        authToken: loginResponse.authToken,
        refreshToken: loginResponse.refreshToken,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        loginSuccess: false,
        errorMessage: e.toString(),
        exception: e,
      ));
    }
  }
}
