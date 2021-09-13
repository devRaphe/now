import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import 'actions.dart';

Epic<AppState> fetchProfileStatusEpic(AuthRepository repository) =>
    (actions, state) => actions.whereType<FetchProfileStatus>().switchMap((action) => _fetchProfileStatus(repository));

Stream<Action> _fetchProfileStatus(AuthRepository repository) async* {
  yield const ProfileStatusActions.loading();

  try {
    final data = await repository.getProfileStatus();
    yield ProfileStatusActions.add(data);
  } catch (e, st) {
    AppLog.e(e, st);
    yield ProfileStatusActions.error(errorToString(e));
  }
}
