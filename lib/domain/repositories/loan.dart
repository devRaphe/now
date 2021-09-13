import '../primitives.dart';

enum LoanChoice {
  full,
  next,
}

extension LoanChoiceX on LoanChoice {
  String get value {
    switch (this) {
      case LoanChoice.next:
        return "next";
      case LoanChoice.full:
      default:
        return "full";
    }
  }
}

abstract class LoanRepository {
  Future<String> apply(LoanRequestData data);

  Future<double> approvedAmount();

  Future<bool> cancelApprovedAmount();

  Future<Pair<PreviewLoanData, String>> previewLoan(double amount);

  Future<LoanSummaryData> checkSummary(double amount, int duration);

  Future<String> repayLoan(String reference, LoanChoice choice);

  Future<LoanDetailsData> getDetails(String reference);
}
