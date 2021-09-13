import 'dart:math' as math;

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter/material.dart';

enum PaymentMethod {
  debit,
  transfer,
  card,
}

extension PaymentMethodX on PaymentMethod {
  String get title {
    return {
      PaymentMethod.debit: 'Pay by Account Debit',
      PaymentMethod.transfer: 'Pay by Bank Transfer',
      PaymentMethod.card: 'Pay with Debit Card',
    }[this];
  }

  String description(FeesModel fees, double amount) {
    return {
      PaymentMethod.debit: 'Transaction Fee: ${Money(
        _calculateTransactionFee(fees.accountDebit, amount),
      ).formatted}',
      PaymentMethod.transfer: 'Transaction Fee: ${Money(
        _calculateTransactionFee(fees.bankTransfer, amount),
      ).formatted}',
      PaymentMethod.card: 'Transaction Fee: 1.5% + ${Money(
        fees.cards.map((fee) => _calculateTransactionFee(fee, amount)).reduce(math.max),
      ).formatted}',
    }[this];
  }

  IconData get icon {
    return {
      // TODO: fix icons
      PaymentMethod.debit: Icons.alt_route_rounded,
      PaymentMethod.transfer: AppIcons.bank,
      PaymentMethod.card: AppIcons.credit_card,
    }[this];
  }
}

double _calculateTransactionFee(PaymentMethodInfoModel fee, double amount) {
  return double.parse(fee.base) + (double.parse(fee.percent) * amount);
}
