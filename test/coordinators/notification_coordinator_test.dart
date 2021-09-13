import 'package:borome/coordinators.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_app_state.dart';
import '../make_app.dart';
import 'test_coordinator.dart';

void main() async {
  group("NotificationCoordinator", () {
    final navigatorKey = GlobalKey<NavigatorState>();
    final coo = NotificationCoordinator(navigatorKey);

    setUpAll(() {
      setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    testWidgets("can navigate to list", (tester) async {
      await testCoordinator<NotificationCoordinator, NotificationsPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toList(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to detail", (tester) async {
      final initialState = fakeAppState();
      await testCoordinator<NotificationCoordinator, NotificationDetailPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toDetail(item: initialState.notice.value.first),
        initialState: initialState,
      );
    });

    testWidgets("can navigate to gallery", (tester) async {
      await testCoordinator<NotificationCoordinator, GalleryPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toGallery(item: ImageListItem(id: "0", url: "", index: 0), items: []),
      );
    });
  });
}
