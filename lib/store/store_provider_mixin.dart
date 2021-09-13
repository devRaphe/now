import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_rxstore/flutter_rxstore.dart';
import 'package:rxstore/rxstore.dart';

import 'app_state.dart';

extension StoreProviderX on BuildContext {
  Store<AppState> get store => StoreProvider.of<AppState>(this);

  void dispatchAction(Action action) => store.dispatch(action);
}

extension StoreX on Store {
  void dispatch(Action action) => dispatcher.add(action);
}
