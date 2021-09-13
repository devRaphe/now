import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import '../sub_state.dart';
import 'actions.dart';

AppState dashboardReducer(AppState state, Action action) {
  if (action is CompleteDashboard) {
    return state.rebuild((b) => b..dashboard = SubState(value: action.data));
  }

  if (action is FetchingDashboard) {
    return state.rebuild((b) => b..dashboard = state.dashboard.withLoading());
  }

  if (action is DashboardError) {
    return state.rebuild((b) => b..dashboard = state.dashboard.withError(action.message));
  }

  return state;
}
