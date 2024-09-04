import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latintokiril/bloc/convertion_event.dart';
import 'package:latintokiril/bloc/convertion_state.dart';
import '../utils/mapping.dart';

class ConversionBloc extends Bloc<ConversionEvent, ConversionState> {
  ConversionBloc() : super(const ConversionState('')) {
    on<ConvertText>((event, emit) {
      String convertedText = event.text;

      if (event.isLatinToCyrillic) {
        for (var entry in latinToCyrillicList) {
          convertedText = convertedText.replaceAll(entry.key, entry.value);
        }
      } else {
        for (var entry in cyrillicToLatinList) {
          convertedText = convertedText.replaceAll(entry.key, entry.value);
        }
      }

      emit(ConversionState(convertedText));
    });
  }
}
