import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';

class LoanImpl implements LoanRepository {
  LoanImpl({@required this.request, @required this.isDev});

  final Request request;
  final bool isDev;

  @override
  Future<String> apply(LoanRequestData data) async {
    return Response<dynamic>(
      await request.post(
        Endpoints.applyForLoan,
        data.toMap(),
        options: Options(timeout: Duration(seconds: 90)),
      ),
      isDev: isDev,
    ).message;
  }

  @override
  Future<double> approvedAmount() async {
    final res = Response<dynamic>(
      await request.post(Endpoints.approvedAmount, <String, String>{}),
      isDev: isDev,
      shouldThrow: false,
    );
    return res.status.isOk ? double.tryParse(res.rawData) : null;
  }

  @override
  Future<bool> cancelApprovedAmount() async {
    final res = Response<dynamic>(
      await request.post(Endpoints.cancelApprovedAmount, <String, String>{}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<Pair<PreviewLoanData, String>> previewLoan(double amount) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.previewLoan, <String, double>{'amount': amount}),
      isDev: isDev,
    );
    return Pair(
      PreviewLoanData(
        amount: "${res.rawData['amount']}",
        hasCard: res.rawData['has_card'] == 1,
        passedChecks: res.rawData['passed_checks'] == 1,
      ),
      res.message,
    );
  }

  @override
  Future<LoanSummaryData> checkSummary(double amount, int duration) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.loanSummary, <String, dynamic>{'amount': amount, 'duration': duration}),
      isDev: isDev,
    );
    return LoanSummaryData.fromJson(res.rawData);
  }

  @override
  Future<LoanDetailsData> getDetails(String reference) async {
    final res = Response<dynamic>(
      await request.get('${Endpoints.loanDetails}?reference=$reference', options: Options(cache: true)),
      isDev: isDev,
    );
    return LoanDetailsData.fromJson(res.rawData);
  }

  @override
  Future<String> repayLoan(String reference, LoanChoice choice) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.chargeLoan, <String, dynamic>{'reference': reference, 'type': choice.value}),
      isDev: isDev,
    );
    return res.message;
  }
}
