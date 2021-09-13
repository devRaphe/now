import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_base.dart';

@immutable
class LoanCoordinator extends CoordinatorBase {
  const LoanCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toUploading({bool clearHistory = false, bool clearUntilDashboard = false}) {
    final route = RouteTransition.slideIn(UploadingPage());
    if (clearUntilDashboard) {
      navigator?.pushAndRemoveUntil(route, (route) => route.settings.name == AppRoutes.dashboard);
    } else if (clearHistory) {
      navigator?.pushAndRemoveUntil(route, (route) => false);
    } else {
      navigator?.push(route);
    }
  }

  void toRequest({@required List<SimpleRoute> routes}) =>
      navigator?.push(RouteTransition.slideIn(LoanRequestPage(routes: routes)));

  void toOffer({@required RateData rate}) =>
      navigator?.pushReplacement(RouteTransition.fadeIn(LoanOfferPage(rate: rate), fullscreenDialog: true));

  void toStatus(bool isSuccessful, String message) => navigator?.push(
      RouteTransition.fadeIn(LoanStatusPage(isSuccessful: isSuccessful, message: message), fullscreenDialog: true));

  void toSummary({
    @required LoanRequestData request,
    @required LoanSummaryData summary,
    @required bool skippedOfferStep,
    bool clearUntilDashboard = false,
  }) {
    final route = RouteTransition.slideIn(
      LoanSummaryPage(
        request: request,
        summary: summary,
        skippedOfferStep: skippedOfferStep,
      ),
    );
    if (clearUntilDashboard) {
      navigator?.pushAndRemoveUntil(route, (route) => route.settings.name == AppRoutes.dashboard);
    } else {
      navigator?.push(route);
    }
  }

  void toDetails({@required LoanModel loan}) => navigator?.push(RouteTransition.slideIn(LoanDetailsPage(loan: loan)));
}
