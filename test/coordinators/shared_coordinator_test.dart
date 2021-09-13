import 'package:borome/coordinators.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_app_state.dart';
import '../make_app.dart';
import 'test_coordinator.dart';

void main() async {
  group("SharedCoordinator", () {
    final navigatorKey = GlobalKey<NavigatorState>();
    final coo = SharedCoordinator(navigatorKey);

    setUpAll(() {
      setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    testWidgets("can navigate to start", (tester) async {
      await testCoordinator<SharedCoordinator, StartPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toStart(pristine: true),
      );
    });

    testWidgets("can navigate to onboard", (tester) async {
      await testCoordinator<SharedCoordinator, OnboardPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toOnboard(),
      );
    });

    testWidgets("can navigate to splash", (tester) async {
      await testCoordinator<SharedCoordinator, SplashPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toSplash(),
      );
    });

    testWidgets("can navigate to dashboard", (tester) async {
      await testCoordinator<SharedCoordinator, DashboardPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toDashboard(),
        initialState: fakeAppState(),
      );
    });
  });
}
