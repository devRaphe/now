import 'package:borome/domain.dart';
import 'package:built_collection/built_collection.dart';
import 'package:rxstore/rxstore.dart';

import '../app_state.dart';
import '../sub_state.dart';
import 'actions.dart';

AppState userReducer(AppState state, Action action) {
  if (action is AddUser) {
    return state.rebuild((b) => b..user = SubState(value: action.value));
  }

  if (action is UserLoading) {
    return state.rebuild((b) => b..user = state.user.withLoading());
  }

  if (action is UpdateUser) {
    return state.rebuild((b) => b..user = state.user.update((data) => data.mergeWith(action.user)));
  }

  if (action is UpdateUserAccounts) {
    return state.rebuild(
      (b) => b
        ..user = state.user.update(
          (data) => data.rebuild((b) => b..accounts = ListBuilder<AccountModel>(action.accounts)),
        ),
    );
  }

  if (action is UserErrorDetails) {
    return state.rebuild((b) => b..user = state.user.withError(action.message));
  }

  return state;
}
