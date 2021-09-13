import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import '../sub_state.dart';
import 'actions.dart';

AppState noticeReducer(AppState state, Action action) {
  if (action is CompleteNotice) {
    return state.rebuild((b) => b..notice = SubState(value: action.data));
  }

  if (action is FetchingNotice) {
    return state.rebuild((b) => b..notice = state.notice.withLoading());
  }

  if (action is NoticeError) {
    return state.rebuild((b) => b..notice = state.notice.withError(action.message));
  }

  return state;
}
