import 'package:borome/store.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_test/flutter_test.dart';
import 'package:rxstore/rxstore.dart';

import 'make_app.dart';

Future<BuildContext> createContext(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: SizedBox()));
  return tester.element(find.byType(SizedBox));
}

final tick = () => Future(() => null);

class RecordingReducer {
  List<Action> actions = <Action>[];

  AppState call(AppState state, Action action) {
    actions.add(action);
    return state;
  }

  void reset() {
    actions = [];
  }
}

Future<BuildContext> createStoreContext(
  WidgetTester tester, {
  List<NavigatorObserver> observers,
  GlobalKey<NavigatorState> navigatorKey,
  AppState appState,
  Reducer<AppState> reducer,
}) async {
  final key = UniqueKey();
  await tester.pumpWidget(makeApp(
    observers: observers,
    navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
    home: SizedBox(key: key),
    initialState: appState,
    reducer: reducer,
  ));
  return tester.element(find.byKey(key));
}
