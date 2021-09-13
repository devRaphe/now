import 'package:borome/domain.dart';
import 'package:borome/environment.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxstore/rxstore.dart';

import '../helpers.dart';

class MockSetupRepo extends Mock implements SetupRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.MOCK;
  Registry()..add<Session>(Session(environment: environment));

  final recordingReducer = RecordingReducer();
  final setupRepository = MockSetupRepo();
  final initialState = AppState.initialState();

  group("Store > Setup", () {
    Store<AppState> store;

    setUp(() async {
      store = Store<AppState>(
        combineReducers([setupReducer, recordingReducer]),
        initialState: initialState,
        epic: combineEpics([initSetupEpic(setupRepository)]),
      );
    });

    tearDown(() async {
      recordingReducer.reset();
      await store.dispose();
    });

    test("works normally", () async {
      final data = SetUpData.empty();
      when(setupRepository.initialize()).thenAnswer((_) async => data);

      store.dispatcher.add(SetupActions.init());

      await tick();

      expect(recordingReducer.actions, [
        SetupActions.init(),
        SetupActions.loading(),
        SetupActions.complete(data),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..setup = SubState(value: data)),
        ]),
      );
    });

    test("works normally with error", () async {
      const message = "We";
      when(setupRepository.initialize()).thenThrow(AppException(message));

      store.dispatcher.add(SetupActions.init());

      await tick();

      expect(recordingReducer.actions, [
        SetupActions.init(),
        SetupActions.loading(),
        SetupActions.error(message),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..setup = b.setup.withError(message)),
        ]),
      );
    });
  });
}
