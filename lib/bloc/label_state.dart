import 'package:todoapp_frontend/bloc/login_state.dart';
import 'package:todoapp_frontend/dto/label_dto.dart';

class LabelState {
  final PageStatus status;
  final List<LabelDto> data;
  final String? errorMessage;
  String? selectedLabel; // valor seleccionado en el dropdown button
  int? selectedLabelId; // id de la etiqueta seleccionada en el dropdown button
  Set<LabelDto>? labelsToDelete;

  LabelState({
    this.status = PageStatus.initial,
    this.data = const [],
    this.errorMessage,
    this.selectedLabel,
    this.selectedLabelId,
    this.labelsToDelete,
  });

  LabelState copyWith({
    PageStatus? status,
    List<LabelDto>? data,
    String? errorMessage,
    String? selectedLabel,
    int? selectedLabelId,
    Set<LabelDto>? labelsToDelete,
  }) {
    return LabelState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLabel: selectedLabel ?? this.selectedLabel,
      selectedLabelId: selectedLabelId ?? this.selectedLabelId,
      labelsToDelete: labelsToDelete ?? this.labelsToDelete,
    );
  }

  List<Object?> get props => [
        status,
        data,
        errorMessage,
        selectedLabel,
        selectedLabelId,
        labelsToDelete,
      ];
}
