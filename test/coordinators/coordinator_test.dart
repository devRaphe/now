import 'package:borome/coordinators.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Coordinator", () {
    test("works normally", () {
      final coo = Coordinator(GlobalKey<NavigatorState>());
      expect(coo.loan, isA<LoanCoordinator>());
      expect(coo.auth, isA<AuthCoordinator>());
      expect(coo.profile, isA<ProfileCoordinator>());
      expect(coo.notification, isA<NotificationCoordinator>());
      expect(coo.shared, isA<SharedCoordinator>());
    });

    test("would throw assertion error when no navigator key", () {
      expect(() => Coordinator(null), throwsAssertionError);
    });
  });
}
