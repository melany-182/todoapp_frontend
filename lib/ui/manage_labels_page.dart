import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_frontend/bloc/label_cubit.dart';
import 'package:todoapp_frontend/bloc/label_state.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/dto/label_dto.dart';

class ManageLabelsPage extends StatelessWidget {
  ManageLabelsPage({Key? key}) : super(key: key);

  final List<LabelDto> labelsToModify = [];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LabelCubit>(context)
        .getAllLabels(); // obtención de las etiquetas mediante el cubit
    BlocProvider.of<LabelCubit>(context).clearLabelsToDelete();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Etiquetas'),
      ),
      body: BlocConsumer<LabelCubit, LabelState>(
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
          } else if (state.data.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(25),
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  LabelDto actualLabel = state.data[index];
                  if (state.labelsToDelete!.contains(actualLabel)) {
                    return const SizedBox.shrink();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: actualLabel.labelName,
                              decoration: const InputDecoration(
                                labelText: 'Etiqueta',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (modifiedValue) {
                                LabelDto newLabel = LabelDto(
                                  labelId: actualLabel.labelId,
                                  labelName: modifiedValue,
                                  userId: actualLabel.userId,
                                );
                                var found = false;
                                for (int i = 0;
                                    i < labelsToModify.length;
                                    i++) {
                                  // se busca si la etiqueta ya está en la lista de etiquetas a modificar
                                  if (labelsToModify[i].labelId ==
                                      actualLabel.labelId) {
                                    labelsToModify[i] = newLabel;
                                    found = true;
                                    break;
                                  }
                                }
                                if (!found) {
                                  // si no se encontró, se añade a la lista de etiquetas a modificar
                                  labelsToModify.add(newLabel);
                                }
                                debugPrint(
                                    "labelsToModify: ${labelsToModify.toString()}");
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 30,
                            padding: const EdgeInsets.only(left: 7.5),
                            onPressed: state.status == PageStatus.loading
                                ? null
                                : () {
                                    // se actualiza el estado del cubit para "marcar" la etiqueta como eliminada
                                    context
                                        .read<LabelCubit>()
                                        .addLabelToDelete(actualLabel);
                                  },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No existen etiquetas.',
                style: TextStyle(fontSize: 15),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<LabelCubit, LabelState>(
        builder: (context, state) {
          return BottomAppBar(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // función que se ejecutará al apretar el botón Cerrar, invocará a la página de añadir tarea sin guardar ningún cambio
                  onPressed: () {
                    labelsToModify.clear();
                    context.read<LabelCubit>().clearLabelsToDelete();
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  // función que se ejecutará al apretar el botón Guardar, invocará a la página de añadir tarea + guardará todos los cambios
                  onPressed: () {
                    // se llama al cubit para que ejecute la función de modificar etiqueta, para todas las etiquetas a modificar
                    for (int i = 0; i < labelsToModify.length; i++) {
                      context.read<LabelCubit>().updateLabelById(
                          labelsToModify[i].labelId!, labelsToModify[i]);
                      if (context.read<LabelCubit>().state.selectedLabelId ==
                          labelsToModify[i].labelId) {
                        // para que no se pierda la etiqueta seleccionada y el dropdown no tire error
                        context
                            .read<LabelCubit>()
                            .selectLabel(labelsToModify[i].labelName);
                        break;
                      }
                    }
                    // se llama al cubit para que ejecute la función de eliminar etiqueta, para todas las etiquetas a eliminar
                    // TODO: gestionar el caso en el que se quiera eliminar una etiqueta que está siendo utilizada por alguna tarea
                    for (var labelDto in state.labelsToDelete!) {
                      debugPrint(
                          "Para eliminar: ${labelDto.labelId.toString()}");
                      context
                          .read<LabelCubit>()
                          .deleteLabelById(labelDto.labelId!);
                      if (context.read<LabelCubit>().state.selectedLabelId ==
                          labelDto.labelId) {
                        // para que se reestablezca la etiqueta seleccionada y el dropdown no tire error
                        context.read<LabelCubit>().state.selectedLabel = null;
                        break;
                      }
                    }
                    labelsToModify.clear();
                    context.read<LabelCubit>().clearLabelsToDelete();
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  // función que se ejecutará al apretar el botón Nuevo, creará un nuevo campo de texto para añadir una nueva etiqueta
                  onPressed: () {
                    LabelDto newLabel = LabelDto(
                        labelName: 'Nueva etiqueta',
                        userId: BlocProvider.of<LabelCubit>(context)
                            .state
                            .data[0]
                            .userId);
                    // se llama al cubit para que ejecute la función de añadir etiqueta
                    context.read<LabelCubit>().createLabel(newLabel);
                  },
                  child: const Text('Nuevo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
