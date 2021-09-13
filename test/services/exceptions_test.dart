import 'package:borome/constants.dart';
import 'package:borome/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

void main() {
  group("Exceptions", () {
    test("works normally", () {
      expect(() => throw AppException(), throwsA(TypeMatcher<AppException>()));
      expect(() => throw NoInternetException(), throwsA(TypeMatcher<NoInternetException>()));
      expect(() => throw RedirectException("https://bing.com", "Hey"), throwsA(TypeMatcher<RedirectException>()));
      expect(() => throw ForbiddenException("error", "Forbidden"), throwsA(TypeMatcher<ForbiddenException>()));
      expect(() => throw TimeOutException(), throwsA(TypeMatcher<TimeOutException>()));
      expect(() => throw BadRequestException("error", "Bad request"), throwsA(TypeMatcher<BadRequestException>()));
      expect(() => throw UnAuthorisedException("error", "Unauthorised"), throwsA(TypeMatcher<UnAuthorisedException>()));
      expect(() => throw ResponseException(400, "error", "Hey"), throwsA(TypeMatcher<ResponseException>()));
    });

    test("toString", () {
      expect(AppException().toString(), "AppException");
      expect(AppException("me").toString(), "AppException(me)");

      expect(NoInternetException().toString(), "NoInternetException(${AppStrings.networkError})");

      expect(
        RedirectException("https://bing.com", "Hey").toString(),
        "RedirectException(307, Temporary Redirect, Hey, https://bing.com)",
      );

      expect(
        ForbiddenException("error", "Forbidden").toString(),
        toString("ForbiddenException", 403, "error", "Forbidden"),
      );
      expect(
        TimeOutException().toString(),
        toString("TimeOutException", 408, 'UNKNOWN', AppStrings.timeoutError),
      );
      expect(
        BadRequestException("error", "Bad request").toString(),
        toString("BadRequestException", 400, "error", "Bad request"),
      );
      expect(
        UnAuthorisedException("error", "Unauthorised").toString(),
        toString("UnAuthorisedException", 401, "error", "Unauthorised"),
      );

      expect(
        ResponseException(400, "error", "Hey").toString(),
        toString("ResponseException", 400, "error", "Hey"),
      );
    });
  });
}

String toString(String className, int statusCode, String status, String message) {
  return '$className($statusCode, $status, $message)';
}
