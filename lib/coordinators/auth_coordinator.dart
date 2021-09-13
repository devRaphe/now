import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_base.dart';

@immutable
class AuthCoordinator extends CoordinatorBase {
  const AuthCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toChangePassword({@required String phone, @required String code}) =>
      navigator?.push(RouteTransition.slideIn(ChangePasswordPage(phone: phone, code: code)));

  void toVerifyForgotPassword({@required String phone}) =>
      navigator?.push(RouteTransition.slideIn(VerifyForgotPasswordPage(phone: phone)));

  void toForgotPassword() => navigator?.push(RouteTransition.slideIn(ForgotPasswordPage()));

  void toSignup({String currentPage, bool clearHistory = false}) {
    final route = RouteTransition.slideIn(SignupPage(currentPage: currentPage));
    clearHistory ? navigator?.pushAndRemoveUntil(route, (route) => false) : navigator?.push(route);
  }

  void toLogin() => navigator?.push(RouteTransition.slideIn(LoginPage()));
}
