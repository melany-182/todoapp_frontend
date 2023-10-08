import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_frontend/bloc/login_cubit.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/ui/menu_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final usernameInput = TextEditingController();
  final passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == PageStatus.success && state.loginSuccess) {
            // si el cubit verifica que la autenticación fue correcta, se va a la página de menú
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MenuPage()));
          } else if (state.status == PageStatus.failure &&
              !state.loginSuccess) {
            // si el cubit verifica que hubo un error en la autenticación, se muestra el error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al iniciar sesión: ${state.errorMessage}'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/todo_icon.png',
                  height: 250,
                ),
                const SizedBox(height: 30), // deja un espacio
                const Text(
                  'Todo App',
                  style: TextStyle(fontSize: 30),
                ),
                const Text(
                  'by m.k.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: 'Usuario',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return BottomAppBar(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state.status == PageStatus.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: state.status == PageStatus.loading
                            ? null
                            : () {
                                // se llama al cubit para que ejecute el login
                                context.read<LoginCubit>().login(
                                    usernameInput.text, passwordInput.text);
                              },
                        child: const Text('Ingresar'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
