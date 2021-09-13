import 'package:flutter/foundation.dart';

class LoanSummaryData {
  LoanSummaryData({
    @required this.duration,
    @required this.monthlyInterest,
    @required this.monthlyPayment,
    @required this.principal,
  });

  factory LoanSummaryData.fromJson(Map<String, dynamic> json) {
    return LoanSummaryData(
      duration: json['duration'],
      monthlyInterest: json['monthly_interest'].toString(),
      monthlyPayment: json['monthly_payment'].toString(),
      principal: json['principal'].toString(),
    );
  }

  final int duration;
  final String monthlyInterest;
  final String monthlyPayment;
  final String principal;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'duration': duration,
      'monthly_interest': monthlyInterest,
      'monthly_payment': monthlyPayment,
      'principal': principal,
    };
  }

  @override
  String toString() {
    return 'LoanSummaryData{duration: $duration, monthlyInterest: $monthlyInterest, monthlyPayment: $monthlyPayment, principal: $principal}';
  }
}
