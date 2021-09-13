import 'package:flutter/widgets.dart';

@immutable
class CoordinatorBase {
  const CoordinatorBase(this.navigatorKey) : assert(navigatorKey != null);

  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorState get navigator => navigatorKey?.currentState;

  void pop() => navigator?.pop();

  void popUntil(String routeName) => navigator?.popUntil((route) => route.settings.name == routeName);
}
