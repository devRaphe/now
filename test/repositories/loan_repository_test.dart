import 'package:borome/constants.dart';
import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../request.dart';

class LoanMockRequest extends MockRequestImpl {
  @override
  Future<http.Response> get(String url) async {
    switch (url) {
      case "${Endpoints.loanDetails}?reference=ref":
        return http.Response(await jsonRawReader("loan_details_success"), 200);
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }

  @override
  Future<http.Response> post(String url) async {
    switch (url) {
      case Endpoints.applyForLoan:
        return http.Response("{\"message\":\"Success\"}", 200);
      case Endpoints.approvedAmount:
        return http.Response("{\"message\":\"Succcess\", \"data\":\"3000.00\"}", 200);
      case Endpoints.cancelApprovedAmount:
        return http.Response("{}", 200);
      case Endpoints.previewLoan:
        return http.Response(
          "{\"message\": \"Success\", \"data\": {\"has_card\": \"1\", \"passed_checks\": \"1\", \"amount\": \"0\"}}",
          200,
        );
      case Endpoints.loanSummary:
        return http.Response(await jsonRawReader("loan_summary_success"), 200);
      case Endpoints.chargeLoan:
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("LoanRepository", () {
    run("Impl", LoanImpl(request: MockRequest(LoanMockRequest()), isDev: true));
    run("MockImpl", LoanMockImpl(Duration.zero));
  });
}

void run(String title, LoanRepository repo) {
  group("$title", () {
    test("apply", () async {
      expect(await repo.apply(LoanRequestData()), isA<String>());
    });

    test("checkSummary", () async {
      expect(await repo.checkSummary(1, 2000), isA<LoanSummaryData>());
    });

    test("approvedAmount", () async {
      expect(await repo.approvedAmount(), isA<double>());
    });

    test("cancelApprovedAmount", () async {
      expect(await repo.cancelApprovedAmount(), isA<bool>());
    });

    test("previewLoan", () async {
      expect(await repo.previewLoan(20000.0), isA<Pair<PreviewLoanData, String>>());
    });

    test("getDetails", () async {
      expect(await repo.getDetails("ref"), isA<LoanDetailsData>());
    });

    test("repayLoan", () async {
      expect(await repo.repayLoan("ref", LoanChoice.full), isA<String>());
      expect(await repo.repayLoan("ref", LoanChoice.next), isA<String>());
    });
  });
}
