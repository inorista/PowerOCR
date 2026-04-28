part of 'ocr_model_cubit.dart';

enum OcrModelStatus { initial, loading, loaded, error }

class OcrModelState extends Equatable {
  final OcrModelStatus status;
  final List<OcrModel> ocrModels;
  final OcrModel? selectedModel;

  const OcrModelState({
    this.status = OcrModelStatus.initial,
    this.ocrModels = const [],
    this.selectedModel,
  });

  @override
  List<Object?> get props => [status, ocrModels, selectedModel];

  OcrModelState copyWith({
    OcrModelStatus? status,
    List<OcrModel>? ocrModels,
    OcrModel? selectedModel,
  }) {
    return OcrModelState(
      status: status ?? this.status,
      ocrModels: ocrModels ?? this.ocrModels,
      selectedModel: selectedModel ?? selectedModel,
    );
  }
}
