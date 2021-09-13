import 'package:borome/constants.dart';
import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../request.dart';

class NoticeMockRequest extends MockRequestImpl {
  @override
  Future<http.Response> get(String url) async {
    switch (url) {
      case Endpoints.notifications:
        return http.Response(await jsonRawReader("notifications_success"), 200);
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }

  @override
  Future<http.Response> post(String url) async {
    switch (url) {
      case Endpoints.readNotification:
      case Endpoints.notificationDetails:
        return http.Response(await jsonRawReader("notification_update_success"), 200);
      case Endpoints.addDeviceToken:
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("NoticeRepository", () {
    run("Impl", NoticeImpl(request: MockRequest(NoticeMockRequest()), isDev: true));
    run("MockImpl", NoticeMockImpl(Duration.zero));
  });
}

void run(String title, NoticeRepository repo) {
  group("$title", () {
    test("markAsRead", () async {
      expect(await repo.markAsRead(1), isA<NoticeModel>());
    });

    test("info", () async {
      expect(await repo.info(1), isA<NoticeModel>());
    });

    test("fetch", () async {
      expect(await repo.fetch(), isA<List<NoticeModel>>());
    });

    test("addDeviceToken", () async {
      expect(await repo.addDeviceToken("token"), isA<bool>());
    });
  });
}
