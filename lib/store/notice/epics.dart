import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import '../sub_state.dart';
import 'actions.dart';

Epic<AppState> fetchNoticeEpic(NoticeRepository repository) =>
    (actions, state) => actions.whereType<FetchNotice>().switchMap((action) => _fetchNotice(repository));

Stream<Action> _fetchNotice(NoticeRepository repository) async* {
  yield const NoticeActions.loading();

  try {
    final data = await repository.fetch();
    yield NoticeActions.complete(data);
  } catch (e, st) {
    AppLog.e(e, st);
    yield NoticeActions.error(errorToString(e));
  }
}

Epic<AppState> readNoticeEpic(NoticeRepository repository) => (actions, state) =>
    actions.whereType<ReadNotice>().switchMap((action) => _readNotice(repository, state.value.notice, action.id));

Stream<Action> _readNotice(NoticeRepository repository, SubState<List<NoticeModel>> notices, int id) async* {
  try {
    final notice = await repository.markAsRead(id);
    final notifications = notices.map((data) => data, orElse: () => <NoticeModel>[])
      ..retainWhere((n) => n.id != id)
      ..add(notice)
      ..toList();
    yield NoticeActions.complete(notifications);
  } catch (e, st) {
    AppLog.e(e, st);
    yield NoticeActions.error(errorToString(e));
  }
}
