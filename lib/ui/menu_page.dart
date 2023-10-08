import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_frontend/bloc/label_cubit.dart';
import 'package:todoapp_frontend/bloc/label_state.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/bloc/task_cubit.dart';
import 'package:todoapp_frontend/bloc/task_state.dart';
import 'package:todoapp_frontend/ui/add_task_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TaskCubit>(context)
        .getAllTasks(); // obtención de las tareas mediante el cubit
    BlocProvider.of<LabelCubit>(context)
        .getAllLabels(); // obtención de las etiquetas mediante el cubit
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state.status == PageStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Error al obtener la data de las tareas: ${state.errorMessage}'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == PageStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.data.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(25),
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  String changeStateString = '';
                  if (state.data[index].status == 'Pendiente') {
                    changeStateString = 'COMPLETAR';
                  } else {
                    changeStateString = 'MARCAR COMO PENDIENTE';
                  }
                  Color stateStringColor = Colors.red;
                  if (state.data[index].status == 'Pendiente') {
                    stateStringColor = Colors.red;
                  } else {
                    stateStringColor = Colors.green;
                  }
                  return Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                state.data[index].status!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: stateStringColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            state.data[index].description,
                            style: const TextStyle(fontSize: 17.5),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.data[index].dueDate.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                          BlocBuilder<LabelCubit, LabelState>(
                            builder: (context, state) {
                              String taskLabel = '';
                              for (int i = 0; i < state.data.length; i++) {
                                if (BlocProvider.of<TaskCubit>(context)
                                        .state
                                        .data[index]
                                        .labelId ==
                                    state.data[i].labelId) {
                                  taskLabel = state.data[i].labelName;
                                }
                              }
                              return Text(
                                taskLabel,
                                style: const TextStyle(fontSize: 15),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // se llama al cubit para que ejecute el cambio de estado de la tarea
                                  context
                                      .read<TaskCubit>()
                                      .updateTaskStatusById(
                                          state.data[index].taskId!);
                                },
                                child: Text(
                                  changeStateString,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No existen tareas registradas.',
                style: TextStyle(fontSize: 15),
              ),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: RawMaterialButton(
          // función que se ejecutará al apretar el botón +, invocará a la página de añadir tarea
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskPage()));
          },
          elevation: 2,
          fillColor: const Color.fromARGB(255, 220, 214, 248),
          padding: const EdgeInsets.all(15),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
