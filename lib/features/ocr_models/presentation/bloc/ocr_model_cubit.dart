import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/features/ocr_models/domain/entities/ocr_model.dart';
import 'package:powerocr/features/ocr_models/domain/usecases/clear_model.dart';
import 'package:powerocr/features/ocr_models/domain/usecases/get_model_language.dart';
import 'package:powerocr/features/ocr_models/domain/usecases/sync_model_language.dart';

part 'ocr_model_state.dart';

@lazySingleton
class OcrModelCubit extends Cubit<OcrModelState> {
  final SyncModelLanguage _syncModelLanguage = locator<SyncModelLanguage>();
  final GetModelLanguage _getModelLanguage = locator<GetModelLanguage>();
  final ClearOcrModel _clearOcrModelCall = locator<ClearOcrModel>();
  OcrModelCubit() : super(const OcrModelState(status: OcrModelStatus.loading)) {
    reloadModel();
  }

  Future<void> selectModel(OcrModel? model) async {
    emit(state.copyWith(selectedModel: model));
  }

  Future<void> reloadModel() async {
    await _clearOcrModel();
    await _syncModels();
    await _getOcrModels();
  }

  Future<void> _clearOcrModel() async {
    await _clearOcrModelCall.call();
  }

  Future<void> _syncModels() async {
    try {
      await _syncModelLanguage.call();
    } catch (e) {}
  }

  Future<void> _getOcrModels() async {
    emit(state.copyWith(status: OcrModelStatus.loading));
    try {
      final ocrModels = await _getModelLanguage.call();
      emit(state.copyWith(status: OcrModelStatus.loaded, ocrModels: ocrModels));
    } catch (e) {
      emit(state.copyWith(status: OcrModelStatus.error));
    }
  }
}
