import 'package:borome/constants.dart';
import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../request.dart';

class SetupMockRequest extends MockRequestImpl {
  @override
  Future<http.Response> get(String url) async {
    switch (url) {
      case Endpoints.setup:
      default:
        return http.Response(await jsonRawReader("setup"), 200);
    }
  }

  @override
  Future<http.Response> post(String url) async {
    switch (url) {
      case Endpoints.resolveAccount:
      default:
        return http.Response(await jsonRawReader("resolve_bank_account"), 200);
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("SetupRepository", () {
    run("Impl", SetupImpl(request: MockRequest(SetupMockRequest()), version: '1.2.3', isDev: true));
    run("MockImpl", SetupMockImpl(Duration.zero));
  });
}

void run(String title, SetupRepository repo) {
  group("$title", () {
    test("initialize", () async {
      expect(await repo.initialize(), isA<SetUpData>());
    });

    test("resolveBankAccount", () async {
      expect(await repo.resolveBankAccount("a", "b"), isA<Pair<BankAccountData, String>>());
    });
  });
}
