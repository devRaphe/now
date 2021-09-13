import 'package:borome/screens.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'make_app.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Smoke test", () {
    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      final navigatorKey = GlobalKey<NavigatorState>();

      setupRegistry(navigatorKey: navigatorKey);

      await tester.pumpWidget(makeApp(
        navigatorKey: navigatorKey,
        observers: [mockObserver],
      ));

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
