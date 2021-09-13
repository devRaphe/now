import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/environment.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxstore/rxstore.dart';

import '../helpers.dart';

class MockNoticeRepo extends Mock implements NoticeRepository {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const environment = Environment.MOCK;
  Registry()..add<Session>(Session(environment: environment));

  final recordingReducer = RecordingReducer();
  final noticeRepository = MockNoticeRepo();
  final initialState = AppState.initialState();

  final repo = NoticeMockImpl(Duration.zero);
  final noticeModel = await repo.markAsRead(1);
  final listOfNotices = await repo.fetch();

  group("Store > Notice", () {
    Store<AppState> store;

    setUp(() async {
      store = Store<AppState>(
        combineReducers([noticeReducer, recordingReducer]),
        initialState: initialState,
        epic: combineEpics([fetchNoticeEpic(noticeRepository), readNoticeEpic(noticeRepository)]),
      );
    });

    tearDown(() async {
      recordingReducer.reset();
      await store.dispose();
    });

    test("works normally", () async {
      when(noticeRepository.fetch()).thenAnswer((_) async => listOfNotices);

      store.dispatcher.add(NoticeActions.fetch());

      await tick();

      expect(recordingReducer.actions, [
        NoticeActions.fetch(),
        NoticeActions.loading(),
        NoticeActions.complete(listOfNotices),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..notice = SubState(value: listOfNotices)),
        ]),
      );
    });

    test("works normally with error", () async {
      const message = "We";
      when(noticeRepository.fetch()).thenThrow(AppException(message));

      store.dispatcher.add(NoticeActions.fetch());

      await tick();

      expect(recordingReducer.actions, [
        NoticeActions.fetch(),
        NoticeActions.loading(),
        NoticeActions.error(message),
      ]);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..notice = b.notice.withError(message)),
        ]),
      );
    });

    test("can read notification", () async {
      final updatedList = listOfNotices
        ..removeWhere((n) => n.id == 1)
        ..add(noticeModel.rebuild((b) => b.isRead = 1));
      when(noticeRepository.markAsRead(1)).thenAnswer((_) async => noticeModel);

      store.dispatcher..add(NoticeActions.complete(listOfNotices))..add(NoticeActions.read(1));

      await tick();

      expect(recordingReducer.actions.length, 3);

      expect(
        store.state,
        emitsInOrder(<AppState>[
          initialState.rebuild((b) => b..notice = SubState(value: updatedList)),
        ]),
      );
    });
  });
}
