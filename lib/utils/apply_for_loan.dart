import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/loans/loan_request_routes.dart';
import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';

import 'app_log.dart';
import 'error_to_string.dart';
import 'ui/app_snack_bar.dart';

void applyForLoan(
  BuildContext context, {
  @required ProfileStatusModel profileStatus,
  bool clearRouteUntilDashboard = false,
}) async {
  final registry = Registry.di;
  final loanCoordinator = registry.coordinator.loan;
  final routes = deriveLoanRequestRoutes(profileStatus);
  if (routes.isNotEmpty) {
    await AppSnackBar.of(context).info(AppStrings.loanRequestRequiredMessage);
    loanCoordinator.toRequest(routes: routes);
    return;
  }

  AppSnackBar.of(context).loading();
  final amount = await registry.repository.loan.approvedAmount();
  if (amount == null) {
    AppSnackBar.of(context).hide();
    loanCoordinator.toUploading(clearUntilDashboard: clearRouteUntilDashboard);
    return;
  }

  final cache = registry.loanApplication.hydrateCache();
  if (cache == null) {
    loanCoordinator.toUploading(clearUntilDashboard: clearRouteUntilDashboard);
    return;
  }

  try {
    final response = await registry.repository.loan.previewLoan(amount);
    if (!response.first.passedChecks) {
      AppSnackBar.of(context).error(response.second);
      return;
    }

    AppSnackBar.of(context).hide();
    loanCoordinator.toSummary(
      request: cache.first,
      summary: cache.second,
      skippedOfferStep: true,
      clearUntilDashboard: clearRouteUntilDashboard,
    );
  } catch (e, st) {
    AppLog.e(e, st);
    AppSnackBar.of(context).error(errorToString(e));
  }
}

List<SimpleRoute> deriveLoanRequestRoutes(ProfileStatusModel profileStatus) {
  return [
    if (profileStatus == null || !profileStatus.contactInformation) SimpleRoute(LoanRequestRoutes.contactInfo),
    if (profileStatus == null || !profileStatus.personalInformation) SimpleRoute(LoanRequestRoutes.personalDetails),
    if (profileStatus == null || !profileStatus.workInformation) SimpleRoute(LoanRequestRoutes.workDetails),
    if (profileStatus == null || !profileStatus.nokInformation) SimpleRoute(LoanRequestRoutes.nextOfKin),
    if (profileStatus == null || !profileStatus.profileImage) SimpleRoute(LoanRequestRoutes.profileImage),
    if (profileStatus == null || !profileStatus.workId) SimpleRoute(LoanRequestRoutes.workIdImage),
    if (profileStatus == null || !profileStatus.bankAccount || !profileStatus.paymentVerification) ...[
      SimpleRoute(LoanRequestRoutes.termsOfUse),
      SimpleRoute(LoanRequestRoutes.identityVerification),
    ]
  ];
}
