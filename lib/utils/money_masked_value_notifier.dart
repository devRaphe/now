import 'package:flutter/foundation.dart';

class MoneyMaskedValueNotifier extends ValueNotifier<String> {
  MoneyMaskedValueNotifier({
    double initialValue = 0.0,
    this.decimalSeparator = '.',
    this.thousandSeparator = ',',
    this.symbol = '',
    this.precision = 2,
  }) : super(initialValue.toString()) {
    addListener(() => updateValue(numberValue));
    updateValue(initialValue);
  }

  final String decimalSeparator;
  final String thousandSeparator;
  final String symbol;
  final int precision;

  double _lastValue = 0.0;

  void updateValue(double newValue) {
    double valueToUse = newValue;
    double currentNumber = double.tryParse(value) ?? 0.0;
    if (currentNumber.toStringAsFixed(0).length > 12) {
      valueToUse = _lastValue;
    } else {
      _lastValue = currentNumber;
    }

    String masked = _applyMask(valueToUse);
    if (symbol.length > 0) {
      masked = symbol + masked;
    }

    if (masked != value) {
      value = masked;
    }
  }

  double get numberValue {
    List<String> parts = _getOnlyNumbers(value).split('').toList(growable: true);
    parts.insert(parts.length - precision, '.');
    return double.parse(parts.join());
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;
    var onlyNumbersRegex = RegExp(r'[^\d]');
    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');
    return cleanedText;
  }

  String _applyMask(double value) {
    List<String> textRepresentation =
        value.toStringAsFixed(precision).replaceAll('.', '').split('').reversed.toList(growable: true);

    textRepresentation.insert(precision, decimalSeparator);

    for (var i = precision + 4; true; i = i + 4) {
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      } else {
        break;
      }
    }

    return textRepresentation.reversed.join('');
  }
}
