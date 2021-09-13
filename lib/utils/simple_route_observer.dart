import 'package:flutter/widgets.dart';

class SimpleRouteObserver extends NavigatorObserver {
  final ValueNotifier<RouteSettings> listener = ValueNotifier<RouteSettings>(null);
  VoidCallback listenerFn;

  void listen(void Function(RouteSettings settings) fn) {
    if (listenerFn != null) {
      listener.removeListener(listenerFn);
    }
    listenerFn = () => fn(listener.value);
    listener.addListener(listenerFn);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute != null) {
      listener.value = route.settings;
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    listener.value = previousRoute.settings;
  }

  void dispose() {
    if (listenerFn != null) {
      listener.removeListener(listenerFn);
    }
    listener.dispose();
  }
}
