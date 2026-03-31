import 'package:equatable/equatable.dart';

class TextBlock extends Equatable {
  final String text;
  final List<double> boundingBox;

  const TextBlock({required this.text, this.boundingBox = const []});

  @override
  List<Object?> get props => [text, boundingBox];
}
