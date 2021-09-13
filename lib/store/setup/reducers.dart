import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import '../sub_state.dart';
import 'actions.dart';

AppState setupReducer(AppState state, Action action) {
  if (action is CompleteSetup) {
    return state.rebuild((b) => b..setup = SubState(value: action.data));
  }

  if (action is FetchingSetup) {
    return state.rebuild((b) => b..setup = state.setup.withLoading());
  }

  if (action is SetupError) {
    return state.rebuild((b) => b..setup = state.setup.withError(action.message));
  }

  return state;
}
