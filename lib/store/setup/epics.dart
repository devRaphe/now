import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import 'actions.dart';

Epic<AppState> initSetupEpic(SetupRepository repository) =>
    (actions, state) => actions.whereType<InitSetup>().switchMap((action) => _initSetup(repository));

Stream<Action> _initSetup(SetupRepository repository) async* {
  yield const SetupActions.loading();
  try {
    final data = await repository.initialize();
    yield SetupActions.complete(data);
  } catch (e, st) {
    AppLog.e(e, st);
    yield SetupActions.error(errorToString(e));
  }
}
