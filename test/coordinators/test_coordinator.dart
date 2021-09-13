import 'package:borome/coordinators.dart';
import 'package:borome/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../make_app.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Future<void> testCoordinator<T extends CoordinatorBase, U extends Widget>(
  WidgetTester tester,
  T coordinator,
  GlobalKey<NavigatorState> navigatorKey,
  void Function(T coordinator) action, {
  AppState initialState,
  void Function(NavigatorObserver, Type) onVerify,
}) async {
  final obs = MockNavigatorObserver();
  await tester.pumpWidget(makeApp(
    observers: [obs],
    initialState: initialState,
    navigatorKey: navigatorKey,
    home: SizedBox(),
  ));

  expect(coordinator.navigator, isNotNull);

  action(coordinator);

  await tester.pumpAndSettle();

  await tester.runAsync<void>(() {
    if (onVerify != null) {
      onVerify(obs, U);
      return;
    }

    verify(obs.didPush(any, any));

    expect(find.byType(U), findsOneWidget);
    return;
  });
}
