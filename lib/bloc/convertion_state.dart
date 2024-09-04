import 'package:equatable/equatable.dart';

class ConversionState extends Equatable {
  final String convertedText;

  const ConversionState(this.convertedText);

  @override
  List<Object> get props => [convertedText];
}
