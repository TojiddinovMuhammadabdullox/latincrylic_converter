import 'package:equatable/equatable.dart';

class ConversionState extends Equatable {
  final String convertedText;
  final bool isLatinToCyrillic;

  const ConversionState(this.convertedText, this.isLatinToCyrillic);

  @override
  List<Object> get props => [convertedText, isLatinToCyrillic];
}
