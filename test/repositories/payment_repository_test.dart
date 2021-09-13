import 'package:borome/constants.dart';
import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../request.dart';

class PaymentMockRequest extends MockRequestImpl {
  @override
  Future<http.Response> get(String url) async {
    switch (url) {
      case Endpoints.bankTransferCheck:
        return http.Response("{\"message\":\"Success\"}", 200);
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }

  @override
  Future<http.Response> post(String url) async {
    switch (url) {
      case Endpoints.accountDebit:
        return http.Response("{\"message\":\"Success\"}", 200);
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("PaymentRepository", () {
    run("Impl", PaymentImpl(request: MockRequest(PaymentMockRequest()), isDev: true));
    run("MockImpl", PaymentMockImpl());
  });
}

void run(String title, PaymentRepository repo) {
  group("$title", () {
    test("checkBankTransfer", () async {
      expect(await repo.checkBankTransfer(), isA<String>());
    });

    test("debitAccount", () async {
      expect(await repo.debitAccount('', ''), isA<String>());
    });
  });
}
