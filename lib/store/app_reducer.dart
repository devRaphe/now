import 'package:rxstore/rxstore.dart';

import 'app_actions.dart';
import 'app_state.dart';

AppState appReducer(AppState state, Action action) {
  if (action is AppSignOut) {
    return state.reset();
  }

  return state;
}
