import 'package:borome/environment.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxstore/rxstore.dart';

import '../helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.MOCK;
  Registry()..add<Session>(Session(environment: environment));

  final recordingReducer = RecordingReducer();
  final emptyState = AppState.initialState();
  final errorState = emptyState.rebuild(
    (b) => b
      ..user = SubState.withError("")
      ..notice = SubState.withError("")
      ..dashboard = SubState.withError("")
      ..setup = SubState.withError(""),
  );

  group("Store > App", () {
    Store<AppState> store;

    setUp(() async {
      store = Store<AppState>(
        combineReducers([appReducer, recordingReducer]),
        initialState: errorState,
      );
    });

    tearDown(() async {
      recordingReducer.reset();
      await store.dispose();
    });

    test("can reset AppState without removing setup", () async {
      store.dispatcher.add(AppActions.signOut());

      await tick();

      expect(recordingReducer.actions.length, 1);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          emptyState.rebuild((b) => b.setup = SubState.withError("")),
        ]),
      );
    });
  });
}
