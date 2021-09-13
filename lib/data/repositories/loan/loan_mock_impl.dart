import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';

class LoanMockImpl implements LoanRepository {
  LoanMockImpl([this.delay = const Duration(milliseconds: 1000)]);

  final Duration delay;

  @override
  Future<String> apply(LoanRequestData data) async {
    return AppStrings.successMessage;
  }

  @override
  Future<double> approvedAmount() async {
    return 10000;
  }

  @override
  Future<bool> cancelApprovedAmount() async {
    return true;
  }

  @override
  Future<Pair<PreviewLoanData, String>> previewLoan(double amount) async {
    return Pair(PreviewLoanData(hasCard: false, passedChecks: true, amount: "10000"), AppStrings.successMessage);
  }

  @override
  Future<LoanSummaryData> checkSummary(double amount, int duration) async {
    final data = await jsonReader("loan_summary_success", delay);
    return LoanSummaryData.fromJson(data);
  }

  @override
  Future<LoanDetailsData> getDetails(String reference) async {
    final data = await jsonReader("loan_details_success", delay);
    return LoanDetailsData.fromJson(data);
  }

  @override
  Future<String> repayLoan(String reference, LoanChoice choice) async {
    return AppStrings.successMessage;
  }
}
