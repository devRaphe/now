import 'package:intl/intl.dart';

import 'app_log.dart';

class Money {
  Money._(this.money, {double min, int digits, bool isLong})
      : assert(min != null),
        _format = money >= min
            ? isLong
                ? NumberFormat.simpleCurrency(name: symbol, decimalDigits: digits)
                : NumberFormat.compactSimpleCurrency(name: symbol, decimalDigits: digits)
            : NumberFormat.currency(symbol: symbol, decimalDigits: digits);

  factory Money(num money, {double min, int digits, bool isLong}) {
    final _money = money ?? 0.0;
    final fraction = _money.remainder(_money.truncate());
    final _digits = _money > 0 && fraction > 0 ? digits ?? 2 : 0;
    return Money._(_money, min: min ?? 100000, digits: _digits, isLong: isLong ?? false);
  }

  final num money;
  final NumberFormat _format;

  static const symbol = "₦";

  static Money fromString(String money, {bool isLong, int digits}) {
    return Money(double.tryParse(money), isLong: isLong, digits: digits);
  }

  String get formatted {
    try {
      return _format.format(money);
    } catch (e, st) {
      AppLog.e(e, st);
      return "${symbol}0.0";
    }
  }
}
