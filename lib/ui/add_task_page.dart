import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp_frontend/bloc/label_cubit.dart';
import 'package:todoapp_frontend/bloc/label_state.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/bloc/task_cubit.dart';
import 'package:todoapp_frontend/bloc/task_state.dart';
import 'package:todoapp_frontend/dto/label_dto.dart';
import 'package:todoapp_frontend/dto/task_dto.dart';
import 'package:todoapp_frontend/ui/manage_labels_page.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({Key? key}) : super(key: key);

  final titleInput = TextEditingController();
  final descriptionInput = TextEditingController();
  final dueDateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LabelCubit>(context)
        .getAllLabels(); // obtención de las etiquetas mediante el cubit
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Tarea'),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state.status == PageStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error al guardar la tarea: ${state.errorMessage}'),
              ),
            );
          } else if (state.status == PageStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tarea guardada correctamente'),
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
                TextField(
                  controller: titleInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.border_color_outlined),
                    border: OutlineInputBorder(),
                    labelText: 'Título de la tarea',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descriptionInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.assignment),
                    border: OutlineInputBorder(),
                    labelText: 'Descripción de la tarea',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: dueDateInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    labelText: 'Fecha de cumplimiento',
                  ),
                  readOnly: true,
                  showCursor: false,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      dueDateInput.text = formattedDate;
                    } else {
                      debugPrint("No se seleccionó ninguna fecha");
                    }
                  },
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Etiqueta:',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<LabelCubit, LabelState>(
                      listener: (context, state) {
                        if (state.status == PageStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error al obtener la data de las etiquetas: ${state.errorMessage}'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status == PageStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          String? selectedLabel = state.selectedLabel;
                          return Expanded(
                            child: DropdownButtonFormField<String>(
                              hint: const Text('Seleccionar etiqueta'),
                              dropdownColor:
                                  const Color.fromARGB(255, 250, 250, 250),
                              focusColor:
                                  const Color.fromARGB(255, 250, 250, 250),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              value:
                                  state.data.isNotEmpty ? selectedLabel : null,
                              onChanged: (newValue) {
                                BlocProvider.of<LabelCubit>(context)
                                    .selectLabel(newValue!);
                                // debugPrint("Se seleccionó la etiqueta $newValue");
                              },
                              items: state.data.map<DropdownMenuItem<String>>(
                                (LabelDto value) {
                                  return DropdownMenuItem<String>(
                                    value: value.labelName,
                                    child: Text(value.labelName),
                                  );
                                },
                              ).toList(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      // función que se ejecutará al apretar el botón Editar, invocará a la gestión de etiquetas
                      icon: const Icon(Icons.edit),
                      iconSize: 30,
                      padding: const EdgeInsets.only(left: 7.5),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageLabelsPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return BottomAppBar(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // función que se ejecutará al apretar el botón Cancelar, invocará al menú principal sin guardar la tarea
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 50),
                state.status == PageStatus.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        // función que se ejecutará al apretar el botón Guardar, guardará la tarea
                        onPressed: state.status == PageStatus.loading
                            ? null
                            : () {
                                if (titleInput.text != "" &&
                                    descriptionInput.text != "" &&
                                    dueDateInput.text != "" &&
                                    BlocProvider.of<LabelCubit>(context)
                                            .state
                                            .selectedLabel !=
                                        null) {
                                  // si el título de la tarea, la descripción, la fecha de cumplimiento y la etiqueta no están vacíos
                                  TaskDto newTask = TaskDto(
                                    title: titleInput.text,
                                    description: descriptionInput.text,
                                    dueDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                        .format(DateFormat('dd-MM-yyyy')
                                            .parse(dueDateInput.text)),
                                    labelId:
                                        BlocProvider.of<LabelCubit>(context)
                                            .state
                                            .selectedLabelId!,
                                    userId: BlocProvider.of<LabelCubit>(context)
                                        .state
                                        .data[0]
                                        .userId,
                                  );
                                  // se llama al cubit para que ejecute la función de agregar tarea
                                  context.read<TaskCubit>().createTask(newTask);
                                  Navigator.pop(context);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error."),
                                        content: const Text(
                                            'No se puede guardar la tarea porque no se especificó el título, la descripción, la fecha de cumplimiento o la etiqueta de la misma.',
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.justify),
                                        actions: [
                                          TextButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // cierra el diálogo emergente
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                        child: const Text('Guardar'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
