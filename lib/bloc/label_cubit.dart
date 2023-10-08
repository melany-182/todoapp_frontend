import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todoapp_frontend/bloc/label_state.dart';
import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/dto/label_dto.dart';
import 'package:todoapp_frontend/dto/response_dto.dart';
import 'package:todoapp_frontend/service/label_service.dart';

class LabelCubit extends Cubit<LabelState> {
  LabelCubit() : super(LabelState());

  Future<void> getAllLabels() async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      final result = await LabelService.getAllLabels(token!);
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

  Future<void> createLabel(LabelDto newLabel) async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      ResponseDto response = await LabelService.createLabel(newLabel, token!);
      debugPrint("response (aquí, add label cubit): ${response.toJson()}");
      emit(state.copyWith(
        status: PageStatus.success,
        data: await LabelService.getAllLabels(
            token), // actualización de la lista de etiquetas // esto es importante
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateLabelById(int labelId, LabelDto newLabel) async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      ResponseDto response =
          await LabelService.updateLabelById(labelId, newLabel, token!);
      debugPrint("response (aquí, update label cubit): ${response.toJson()}");
      emit(state.copyWith(
        status: PageStatus.success,
        data: await LabelService.getAllLabels(
            token), // actualización de la lista de etiquetas // esto es importante
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteLabelById(int labelId) async {
    emit(state.copyWith(status: PageStatus.loading));
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "AuthToken");
    try {
      ResponseDto response =
          await LabelService.deleteLabelById(labelId, token!);
      debugPrint("response (aquí, delete label cubit): ${response.toJson()}");
      emit(state.copyWith(
        status: PageStatus.success,
        data: await LabelService.getAllLabels(
            token), // actualización de la lista de etiquetas // esto es importante
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PageStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // métodos para settear el valor seleccionado en el dropdown button

  void selectLabel(String selectedLabel) {
    int selectedLabelId = identifyLabelByName(selectedLabel).labelId!;
    debugPrint("id: $selectedLabelId");
    emit(state.copyWith(
      selectedLabel: selectedLabel,
      selectedLabelId: selectedLabelId,
    ));
  }

  LabelDto identifyLabelByName(String labelName) {
    List<LabelDto> labels = state.data;
    LabelDto label = LabelDto(labelId: 0, labelName: '', userId: 0);
    for (int i = 0; i < labels.length; i++) {
      if (labels[i].labelName.toString() == labelName) {
        // debugPrint("etiqueta encontrada: ${labels[i].name.toString()}");
        label = labels[i];
        break;
      }
    }
    debugPrint(label.toJson().toString());
    return label;
  }

  void addLabelToDelete(LabelDto labelToDelete) {
    emit(state.copyWith(
        labelsToDelete: state.labelsToDelete!..add(labelToDelete)));
  }

  void clearLabelsToDelete() {
    emit(state.copyWith(labelsToDelete: {}));
  }
}
