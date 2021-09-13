import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_base.dart';

@immutable
class PaymentsCoordinator extends CoordinatorBase {
  const PaymentsCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toAmount({@required PaymentMethod method, @required LoanModel loan, @required String paymentUrl}) =>
      navigator?.push(
        RouteTransition.slideIn(AmountPage(method: method, loan: loan, paymentUrl: paymentUrl), name: AppRoutes.amount),
      );

  void toSummary({@required LoanModel loan, @required double amount}) =>
      navigator?.push(RouteTransition.slideIn(PaymentSummaryPage(loan: loan, amount: amount)));

  void toCardPayment({@required LoanModel loan, @required String payUrl, @required double amount}) =>
      navigator?.push(RouteTransition.slideIn(CardPaymentPage(loan: loan, payUrl: payUrl, amount: amount)));

  void toBankTransfer({@required double amount}) =>
      navigator?.push(RouteTransition.slideIn(BankTransferPage(amount: amount)));
}
