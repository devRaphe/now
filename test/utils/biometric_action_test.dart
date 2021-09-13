import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/utils/biometric_action.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_app_state.dart';
import '../helpers.dart';
import '../make_app.dart';

class MockLocalAuthService extends Mock implements LocalAuthService {}

void main() {
  final appState = fakeAppState();
  final user = appState.user.value;
  final loginRequest = LoginRequestData(phone: user.phone, password: "", deviceId: "12345");

  group("biometricAction", () {
    Registry registry;
    final navigatorKey = GlobalKey<NavigatorState>();

    setUpAll(() async {
      registry = await setupRegistry(navigatorKey: navigatorKey, localAuth: MockLocalAuthService());
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    testWidgets("when credentials exist", (tester) async {
      when(registry.localAuth.hasCredentials()).thenReturn(true);
      when(registry.localAuth.fetchCredentials()).thenAnswer((_) async => Pair(loginRequest.phone, ""));

      final status = await biometricAction(context: await createStoreContext(tester), request: loginRequest);
      expect(status, BiometricStatus.ok);

      reset(registry.localAuth);
    });

    testWidgets("when auth is not available", (tester) async {
      when(registry.localAuth.hasCredentials()).thenReturn(false);
      when(registry.localAuth.isAvailable()).thenAnswer((_) async => false);

      final status = await biometricAction(context: await createStoreContext(tester), request: loginRequest);
      expect(status, BiometricStatus.notAvailable);

      reset(registry.localAuth);
    });

    // TODO(jogboms): Needs further investigation why it hangs at show dialog
    testWidgets("when credentials do not exist", (tester) async {
      when(registry.localAuth.hasCredentials()).thenReturn(false);
      when(registry.localAuth.isAvailable()).thenAnswer((_) async => true);
      when(registry.localAuth.persistCredentials(any, any)).thenAnswer((_) async => true);

      await biometricAction(context: await createStoreContext(tester), request: loginRequest);

      await tester.pumpAndSettle();

      reset(registry.localAuth);
    }, skip: true);
  });
}
