import 'package:flutter/foundation.dart';

import '../models/loan.dart';
import '../models/payment.dart';
import '../models/schedule.dart';

class LoanDetailsData {
  LoanDetailsData({
    @required this.loan,
    @required this.payments,
    @required this.schedule,
    @required this.updates,
  });

  factory LoanDetailsData.fromJson(Map<String, dynamic> json) {
    return LoanDetailsData(
      loan: LoanModel.fromJson(json['loan']),
      payments: (json['payments'] as List).map((dynamic i) => PaymentModel.fromJson(i)).toList(),
      schedule: (json['schedule'] as List).map((dynamic i) => ScheduleModel.fromJson(i)).toList(),
      updates: (json['updates'] as List).map<dynamic>((dynamic i) => i).toList(),
    );
  }

  factory LoanDetailsData.fromLoan(LoanModel loan) {
    return LoanDetailsData(loan: loan, payments: [], schedule: [], updates: <dynamic>[]);
  }

  final LoanModel loan;
  final List<PaymentModel> payments;
  final List<ScheduleModel> schedule;
  final List<dynamic> updates;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loan': loan.toMap(),
      'payments': payments.map((p) => p.toMap()).toList(),
      'schedule': schedule.map((s) => s.toMap()).toList(),
      'updates': updates,
    };
  }

  @override
  String toString() {
    return 'LoanDetailsData{loan: $loan, payments: $payments, schedule: $schedule, updates: $updates}';
  }
}
