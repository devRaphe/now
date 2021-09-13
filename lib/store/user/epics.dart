import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import 'actions.dart';

Epic<AppState> fetchUserEpic(AuthRepository repository, void Function(UserModel) onFetch) =>
    (actions, state) => actions.whereType<FetchUser>().switchMap((action) => _fetchUser(repository, onFetch));

Stream<Action> _fetchUser(AuthRepository repository, void Function(UserModel) onFetch) async* {
  yield const UserActions.loading();

  try {
    final data = await repository.getAccount();
    onFetch(data);
    yield UserActions.add(data);
  } catch (e, st) {
    AppLog.e(e, st);
    yield UserActions.error(errorToString(e));
  }
}
