import 'package:flutter/foundation.dart';

class PreviewLoanData {
  const PreviewLoanData({@required this.hasCard, @required this.passedChecks, @required this.amount});

  final bool hasCard;
  final bool passedChecks;
  final String amount;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'has_card': hasCard,
      'passed_checks': passedChecks,
      'amount': amount,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'ContactData{has_card: $hasCard, passed_checks: $passedChecks, amount: $amount}';
  }
}
