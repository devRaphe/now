import 'package:borome/route_transition.dart';
import 'package:borome/screens/services/services.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_base.dart';

@immutable
class ServicesCoordinator extends CoordinatorBase {
  const ServicesCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toAirtime() => navigator?.push(RouteTransition.slideIn(AirtimePage()));
}
