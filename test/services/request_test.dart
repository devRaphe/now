import 'package:borome/services/request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http_extensions/http_extensions.dart';
import 'package:mockito/mockito.dart';

class MockExtendedClient extends Mock implements ExtendedClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final _http = MockExtendedClient();
  final client = Request.test(_http);

  // TODO: would be implemented with the new http
  group("Request", () {
    test("GET works normally", () async {
      when(_http.get(any)).thenAnswer((_) async => http.Response("", 200));
      final res = await client.get("");
      expect(res.body, "");
    });

    test("POST works normally", () async {
      when(_http.post(any)).thenAnswer((_) async => http.Response("", 200));
      final res = await client.post("", <String, dynamic>{});
      expect(res.body, "");
    });

    test("DELETE works normally", () async {
      when(_http.delete(any)).thenAnswer((_) async => http.Response("", 200));
      final res = await client.delete("");
      expect(res.body, "");
    });

    test("FORM works normally", () async {
      when(_http.post(any)).thenAnswer((_) async => http.Response("", 200));
      final res = await client.form("");
      expect(res.body, "");
    });
  }, skip: true);
}
