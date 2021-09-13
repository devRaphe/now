import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils/logout_action.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_app_state.dart';
import '../helpers.dart';
import '../make_app.dart';
import '../smoke_test.dart';

final reducer = RecordingReducer();

void main() {
  final appState = fakeAppState();
  final user = appState.user.value;

  group("logoutAction", () {
    Registry registry;
    final navigatorKey = GlobalKey<NavigatorState>();
    final obs = MockNavigatorObserver();

    setUpAll(() async {
      registry = await setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      registry.dispose();
    });

    setUp(() {
      registry.session
        ..setUser(user)
        ..setToken("token");
    });

    tearDown(() {
      reducer.reset();
    });

    testWidgets("when user exist", (tester) async {
      logoutAction(context: await createStoreContext(tester, reducer: reducer, observers: [obs]));

      await tester.pumpAndSettle();

      expect(registry.session.token.value, null);
      expect(registry.session.user.value, null);

      expect(reducer.actions.length, 2);

      expect(reducer.actions[0], isA<InitSetup>());
      expect(reducer.actions[1], isA<AppSignOut>());

      reset(registry.repository.auth);
    });
  });
}
