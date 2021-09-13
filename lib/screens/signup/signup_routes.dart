import 'package:borome/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupRoutes {
  static const String contactInfo = "contact_info";
  static const String phoneVerification = "phone_verification";
  static const String emailVerification = "email_verification";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case phoneVerification:
        return _PageRoute(builder: (_) => PhoneVerificationView(), settings: settings);
      case emailVerification:
        return _PageRoute(builder: (_) => EmailVerificationView(), settings: settings);
      case contactInfo:
      default:
        return _PageRoute(builder: (_) => ContactInfoView(), settings: settings);
    }
  }
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(_, Animation<double> animation, __, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
