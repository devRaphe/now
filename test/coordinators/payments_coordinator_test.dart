import 'package:borome/coordinators.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_app_state.dart';
import '../make_app.dart';
import 'test_coordinator.dart';

void main() {
  group("PaymentsCoordinator", () {
    final navigatorKey = GlobalKey<NavigatorState>();
    final coo = PaymentsCoordinator(navigatorKey);
    final loanModel = LoanModel(
      (b) => b
        ..dateDue = DateTime(2030, 10, 20)
        ..status = "partial"
        ..userId = 1
        ..createdAt = DateTime.now()
        ..reference = ""
        ..repaymentStatus = ""
        ..maxAmount = "23"
        ..amount = "244"
        ..nextPayment = "4533"
        ..interest = "234"
        ..durationDays = 23
        ..overdueInterest = "4533"
        ..amountForRepayment = "1234"
        ..amountRemaining = "123"
        ..loanReason = "Hey"
        ..id = 1,
    );

    setUpAll(() {
      setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    testWidgets("can navigate to amount", (tester) async {
      await testCoordinator<PaymentsCoordinator, AmountPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toAmount(method: PaymentMethod.card, loan: loanModel, paymentUrl: ''),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to summary", (tester) async {
      await testCoordinator<PaymentsCoordinator, PaymentSummaryPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toSummary(loan: loanModel, amount: 100.0),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to card payment", (tester) async {
      await testCoordinator<PaymentsCoordinator, CardPaymentPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toCardPayment(loan: loanModel, payUrl: 'url', amount: 100.0),
        initialState: fakeAppState(),
      );
      // NOTE: cannot test this because of the WebviewScaffold
    }, skip: true);

    testWidgets("can navigate to bank transfer", (tester) async {
      await testCoordinator<PaymentsCoordinator, BankTransferPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toBankTransfer(amount: 1000.0),
        initialState: fakeAppState(),
      );
    });
  });
}
