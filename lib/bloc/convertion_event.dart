import 'package:equatable/equatable.dart';

abstract class ConversionEvent extends Equatable {
  const ConversionEvent();

  @override
  List<Object> get props => [];
}

class ConvertText extends ConversionEvent {
  final String text;
  final bool isLatinToCyrillic;

  const ConvertText({required this.text, required this.isLatinToCyrillic});

  @override
  List<Object> get props => [text, isLatinToCyrillic];
}
