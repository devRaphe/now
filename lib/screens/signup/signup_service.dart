import 'package:borome/screens/signup/signup_routes.dart';
import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';

class SignupService extends SimpleRoutingService {
  factory SignupService([int initialIndex = 0, List<SimpleRoute> routes = _routes]) {
    return SignupService._(
      initialIndex: initialIndex,
      observer: SimpleRouteObserver(),
      routes: routes,
    ).._initialize();
  }

  factory SignupService.fromRoute(String routeName) {
    var index = _routes.indexWhere((item) => item.name == routeName);
    return SignupService(
      0,
      List.of(_routes)..removeRange(0, index),
    );
  }

  SignupService._({
    @required int initialIndex,
    @required this.observer,
    @required List<SimpleRoute> routes,
  }) : super(initialIndex, routes);

  final SimpleRouteObserver observer;

  static const _routes = [
    SimpleRoute(SignupRoutes.contactInfo, false),
    SimpleRoute(SignupRoutes.emailVerification),
    SimpleRoute(SignupRoutes.phoneVerification, false),
  ];

  void _initialize() {
    observer.listen((settings) {
      value = findIndex(settings.name);
    });
  }

  @override
  void dispose() {
    observer.dispose();
    super.dispose();
  }
}
