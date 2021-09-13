import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/environment.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxstore/rxstore.dart';

import '../helpers.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.MOCK;
  final session = Session(environment: environment);
  Registry()..add<Session>(session);

  final recordingReducer = RecordingReducer();
  final authRepository = MockAuthRepo();
  final initialState = AppState.initialState();

  final repo = AuthMockImpl(Duration.zero);
  final userModel = await repo.getAccount();
  final listOfAccounts = await repo.setDefaultAccount(1);

  group("Store > User", () {
    Store<AppState> store;

    setUp(() async {
      store = Store<AppState>(
        combineReducers([userReducer, recordingReducer]),
        initialState: initialState,
        epic: combineEpics([fetchUserEpic(authRepository, session.setUser)]),
      );
    });

    tearDown(() async {
      session.resetUser();
      recordingReducer.reset();
      await store.dispose();
    });

    test("works normally", () async {
      when(authRepository.getAccount()).thenAnswer((_) async => userModel);

      store.dispatcher.add(UserActions.fetch());

      await tick();

      expect(recordingReducer.actions, [
        UserActions.fetch(),
        UserActions.loading(),
        UserActions.add(userModel),
      ]);

      expect(session.user.value, userModel);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..user = SubState(value: userModel)),
        ]),
      );
    });

    test("works normally with error", () async {
      const message = "We";
      when(authRepository.getAccount()).thenThrow(AppException(message));

      store.dispatcher.add(UserActions.fetch());

      await tick();

      expect(recordingReducer.actions, [
        UserActions.fetch(),
        UserActions.loading(),
        UserActions.error(message),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..user = b.user.withError(message)),
        ]),
      );
    });

    test("can update existing user", () async {
      final updatedUserModel = userModel.rebuild((b) => b..firstname = "We");
      store.dispatcher..add(UserActions.add(userModel))..add(UserActions.update(updatedUserModel));

      await tick();

      expect(recordingReducer.actions.length, 2);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..user = SubState(value: updatedUserModel)),
        ]),
      );
    });

    test("can update accounts", () async {
      final updatedUserModel = userModel.rebuild((b) => b..accounts = ListBuilder(listOfAccounts));
      store.dispatcher..add(UserActions.add(userModel))..add(UserActions.updateAccounts(listOfAccounts));

      await tick();

      expect(recordingReducer.actions.length, 2);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..user = SubState(value: updatedUserModel)),
        ]),
      );
    });
  });
}
