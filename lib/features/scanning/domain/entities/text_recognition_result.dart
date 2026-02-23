import 'package:equatable/equatable.dart';

class TextRecognitionResult extends Equatable {
  final String text;
  final List<TextBlock> blocks;

  const TextRecognitionResult({
    required this.text,
    this.blocks = const [],
  });

  @override
  List<Object?> get props => [text, blocks];
}

class TextBlock extends Equatable {
  final String text;
  final List<double> boundingBox;

  const TextBlock({
    required this.text,
    this.boundingBox = const [],
  });

  @override
  List<Object?> get props => [text, boundingBox];
}
