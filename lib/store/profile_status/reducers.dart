import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import '../sub_state.dart';
import 'actions.dart';

AppState profileStatusReducer(AppState state, Action action) {
  if (action is AddProfileStatus) {
    return state.rebuild((b) => b..profileStatus = SubState(value: action.value));
  }

  if (action is ProfileStatusLoading) {
    return state.rebuild((b) => b..profileStatus = state.profileStatus.withLoading());
  }

  if (action is ProfileStatusErrorDetails) {
    return state.rebuild((b) => b..profileStatus = state.profileStatus.withError(action.message));
  }

  return state;
}
