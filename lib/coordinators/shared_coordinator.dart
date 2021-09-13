import 'package:borome/constants.dart';
import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_base.dart';

@immutable
class SharedCoordinator extends CoordinatorBase {
  const SharedCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toStart({@required bool pristine, bool clearHistory = true}) {
    final route = RouteTransition.fadeIn(StartPage(pristine: pristine), name: AppRoutes.start);
    clearHistory ? navigator?.pushAndRemoveUntil(route, (route) => false) : navigator?.pushReplacement(route);
  }

  void toOnboard() {
    navigator?.pushReplacement(RouteTransition.fadeIn(OnboardPage(), name: AppRoutes.start));
  }

  void toSplash() {
    navigator?.pushAndRemoveUntil(
      RouteTransition.fadeIn(SplashPage(isFirstTime: false), name: AppRoutes.start),
      (Route<void> route) => false,
    );
  }

  void toDashboard() {
    navigator?.pushAndRemoveUntil(
      RouteTransition.fadeIn(DashboardPage(), name: AppRoutes.dashboard),
      (Route<void> route) => false,
    );
  }
}
