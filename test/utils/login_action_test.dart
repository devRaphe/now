import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:borome/utils/login_action.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_app_state.dart';
import '../helpers.dart';
import '../make_app.dart';

final reducer = RecordingReducer();

void main() {
  final appState = fakeAppState();
  final user = appState.user.value;
  final profileStatus = appState.profileStatus.value;
  final loginRequest = LoginRequestData(phone: user.phone, password: "", deviceId: "12345");

  group("loginAction", () {
    Registry registry;
    final navigatorKey = GlobalKey<NavigatorState>();

    setUpAll(() async {
      registry = await setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      registry.dispose();
    });

    tearDown(() {
      registry.session.resetUser();
      registry.session.resetToken();
      reducer.reset();
    });

    testWidgets("when user exist", (tester) async {
      when(registry.repository.auth.signIn(any))
          .thenAnswer((_) async => LoginResponseData(user: user, token: "token", message: "Success"));
      when(registry.repository.auth.getAccount()).thenAnswer((_) async => user);
      when(registry.repository.auth.getProfileStatus()).thenAnswer((_) async => profileStatus);

      await loginAction(
        context: await createStoreContext(
          tester,
          reducer: reducer,
          navigatorKey: navigatorKey,
        ),
        request: loginRequest,
      );

      await tester.pump();

      expect(registry.session.token.value, "token");
      expect(registry.session.user.value, user);

      expect(reducer.actions.length, 6);

      expect(reducer.actions[0], isA<InitSetup>());
      expect(reducer.actions[1], isA<UserLoading>());
      expect(reducer.actions[2], isA<AddUser>());
      expect(reducer.actions[3], isA<AddProfileStatus>());
      expect(reducer.actions[4], isA<FetchNotice>());
      expect(reducer.actions[5], isA<FetchDashboard>());

      await tester.pump();

      reset(registry.repository.auth);

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets("when user does not exist", (tester) async {
      when(registry.repository.auth.signIn(any)).thenThrow(AppException(""));

      await loginAction(context: await createStoreContext(tester, reducer: reducer), request: loginRequest);

      await tester.pumpAndSettle();

      expect(reducer.actions.length, 3);

      expect(reducer.actions[0], isA<InitSetup>());
      expect(reducer.actions[1], isA<UserLoading>());
      expect(reducer.actions[2], isA<UserErrorDetails>());

      reset(registry.repository.auth);
    });

    testWidgets("when user is null", (tester) async {
      when(registry.repository.auth.signIn(any))
          .thenAnswer((_) async => LoginResponseData(user: user, token: "", message: "Failure"));

      await loginAction(context: await createStoreContext(tester, reducer: reducer), request: loginRequest);

      await tester.pumpAndSettle();

      expect(reducer.actions.length, 3);

      expect(reducer.actions[0], isA<InitSetup>());
      expect(reducer.actions[1], isA<UserLoading>());
      expect(reducer.actions[2], isA<UserErrorDetails>());

      expect(reducer.actions.last, UserActions.error(AppStrings.errorMessage));

      reset(registry.repository.auth);
    });

    testWidgets("when user email is not verified", (tester) async {
      when(registry.repository.auth.signIn(any)).thenAnswer((_) async => LoginResponseData(
          user: user.rebuild((b) => b..isEmailVerified = 0), token: "token", message: "Email unverified"));
      when(registry.repository.auth.getAccount()).thenAnswer((_) async => user);
      when(registry.repository.auth.getProfileStatus()).thenAnswer((_) async => profileStatus);

      await tester.runAsync(() async {
        await loginAction(
          context: await createStoreContext(
            tester,
            reducer: reducer,
            navigatorKey: navigatorKey,
          ),
          request: loginRequest,
        );

        await tester.pump();

        expect(registry.session.token.value, "token");
        expect(registry.session.user.value, user);

        expect(reducer.actions.length, 4);

        expect(reducer.actions[0], isA<InitSetup>());
        expect(reducer.actions[1], isA<UserLoading>());
        expect(reducer.actions[2], isA<AddUser>());
        expect(reducer.actions[3], isA<AddProfileStatus>());

        await tester.pump();

        expect(find.byType(EmailVerificationView), findsOneWidget);

        reset(registry.repository.auth);
      });
    });

    testWidgets("when user phone is not verified", (tester) async {
      when(registry.repository.auth.signIn(any)).thenAnswer((_) async => LoginResponseData(
          user: user.rebuild((b) => b..isPhoneVerified = 0), token: "token", message: "Phone unverified"));
      when(registry.repository.auth.getAccount()).thenAnswer((_) async => user);
      when(registry.repository.auth.getProfileStatus()).thenAnswer((_) async => profileStatus);

      await tester.runAsync(() async {
        await loginAction(
          context: await createStoreContext(
            tester,
            reducer: reducer,
            navigatorKey: navigatorKey,
          ),
          request: loginRequest,
        );

        await tester.pump();

        expect(registry.session.token.value, "token");
        expect(registry.session.user.value, user);

        expect(reducer.actions.length, 4);

        expect(reducer.actions[0], isA<InitSetup>());
        expect(reducer.actions[1], isA<UserLoading>());
        expect(reducer.actions[2], isA<AddUser>());
        expect(reducer.actions[3], isA<AddProfileStatus>());

        await tester.pump();

        expect(find.byType(PhoneVerificationView), findsOneWidget);

        reset(registry.repository.auth);
      });
    });
  });
}
