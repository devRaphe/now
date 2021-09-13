import 'package:borome/coordinators.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../make_app.dart';
import 'test_coordinator.dart';

void main() {
  group("AuthCoordinator", () {
    final navigatorKey = GlobalKey<NavigatorState>();
    final coo = AuthCoordinator(navigatorKey);

    setUpAll(() {
      setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    testWidgets("can navigate to change password", (tester) async {
      await testCoordinator<AuthCoordinator, ChangePasswordPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toChangePassword(code: "", phone: ""),
      );
    });

    testWidgets("can navigate to verify forgot password", (tester) async {
      await testCoordinator<AuthCoordinator, VerifyForgotPasswordPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toVerifyForgotPassword(phone: ""),
      );
    });

    testWidgets("can navigate to forgot password", (tester) async {
      await testCoordinator<AuthCoordinator, ForgotPasswordPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toForgotPassword(),
      );
    });

    testWidgets("can navigate to signup", (tester) async {
      await testCoordinator<AuthCoordinator, SignupPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toSignup(),
      );
    });

    testWidgets("can navigate to login", (tester) async {
      await testCoordinator<AuthCoordinator, LoginPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toLogin(),
      );
    });
  });
}
