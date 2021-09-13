import 'package:flutter/material.dart';

import 'views/contact_info_view.dart';
import 'views/identity_verification_view.dart';
import 'views/next_of_kin_view.dart';
import 'views/personal_details_view.dart';
import 'views/profile_image_view.dart';
import 'views/terms_of_use_view.dart';
import 'views/work_details_view.dart';
import 'views/work_id_image_view.dart';

class LoanRequestRoutes {
  static const String contactInfo = "contact_info";
  static const String personalDetails = "personal_details";
  static const String workDetails = "work_details";
  static const String nextOfKin = "next_of_kin";
  static const String profileImage = "profile_image";
  static const String workIdImage = "work_id_image";
  static const String termsOfUse = "terms_of_use";
  static const String identityVerification = "identity_verification";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case personalDetails:
        return _PageRoute(builder: (_) => PersonalDetailsView(), settings: settings);
      case workDetails:
        return _PageRoute(builder: (_) => WorkDetailsView(), settings: settings);
      case nextOfKin:
        return _PageRoute(builder: (_) => NextOfKinView(), settings: settings);
      case profileImage:
        return _PageRoute(builder: (_) => ProfileImageView(), settings: settings);
      case workIdImage:
        return _PageRoute(builder: (_) => WorkIdImageView(), settings: settings);
      case termsOfUse:
        return _PageRoute(builder: (_) => TermsOfUseView(), settings: settings);
      case identityVerification:
        return _PageRoute(builder: (_) => IdentityVerificationView(), settings: settings);
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
