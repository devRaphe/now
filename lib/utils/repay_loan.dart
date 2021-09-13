import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:flutter/material.dart';

import 'ui/show_choice_sheet.dart';

void repayLoan(
  BuildContext context, {
  @required LoanModel loan,
  @required String accountNumber,
  @required String bankName,
}) async {
  final method = await showChoiceSheet(context);
  if (method == null) {
    return;
  }

  final setupState = context.store.state.value.setup;
  if (!setupState.hasData) {
    return;
  }

  Registry.di.coordinator.payments.toAmount(
    method: method,
    loan: loan,
    paymentUrl: setupState.value.paymentUrl,
  );
}
