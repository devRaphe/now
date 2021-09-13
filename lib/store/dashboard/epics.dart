import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import 'actions.dart';

Epic<AppState> fetchDashboardEpic(AuthRepository repository) => (actions, state) =>
    actions.whereType<FetchDashboard>().switchMap((action) => _fetchDashboard(repository, action.duration));

Stream<Action> _fetchDashboard(AuthRepository repository, SortType duration) async* {
  yield const DashboardActions.loading();

  try {
    final data = await repository.fetchDashboard(duration);
    yield DashboardActions.complete(data);
  } catch (e, st) {
    AppLog.e(e, st);
    yield DashboardActions.error(errorToString(e));
  }
}
