import 'package:borome/domain.dart';
import 'package:borome/environment.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxstore/rxstore.dart';

import '../helpers.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.MOCK;
  Registry()..add<Session>(Session(environment: environment));

  final recordingReducer = RecordingReducer();
  final authRepository = MockAuthRepo();
  final initialState = AppState.initialState();

  group("Store > Dashboard", () {
    Store<AppState> store;

    setUp(() async {
      store = Store<AppState>(
        combineReducers([dashboardReducer, recordingReducer]),
        initialState: initialState,
        epic: combineEpics([fetchDashboardEpic(authRepository)]),
      );
    });

    tearDown(() async {
      recordingReducer.reset();
      await store.dispose();
    });

    test("works normally", () async {
      final data = DashboardData();
      when(authRepository.fetchDashboard(SortType.month)).thenAnswer((_) async => data);

      store.dispatcher.add(DashboardActions.fetch());

      await tick();

      expect(recordingReducer.actions, [
        DashboardActions.fetch(),
        DashboardActions.loading(),
        DashboardActions.complete(data),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..dashboard = SubState(value: data)),
        ]),
      );
    });

    test("works normally with error", () async {
      const message = "We";
      when(authRepository.fetchDashboard(SortType.month)).thenThrow(AppException(message));

      store.dispatcher.add(DashboardActions.fetch());

      await tick();

      expect(recordingReducer.actions, [
        DashboardActions.fetch(),
        DashboardActions.loading(),
        DashboardActions.error(message),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..dashboard = b.dashboard.withError(message)),
        ]),
      );
    });
  });
}
