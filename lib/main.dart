import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_frontend/bloc/label_cubit.dart';
import 'package:todoapp_frontend/bloc/login_cubit.dart';
import 'package:todoapp_frontend/bloc/task_cubit.dart';
import 'package:todoapp_frontend/ui/add_task_page.dart';
import 'package:todoapp_frontend/ui/login_page.dart';
import 'package:todoapp_frontend/ui/manage_labels_page.dart';
import 'package:todoapp_frontend/ui/menu_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // este es el nivel más alto de la aplicación
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<TaskCubit>(create: (context) => TaskCubit()),
        BlocProvider<LabelCubit>(create: (context) => LabelCubit()),
      ],
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/menu': (context) => const MenuPage(),
          '/addTask': (context) => AddTaskPage(),
          '/manageLabels': (context) => ManageLabelsPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
