import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:flutter/widgets.dart';

import 'app_log.dart';
import 'biometric_action.dart';
import 'error_to_string.dart';
import 'ui/app_snack_bar.dart';

Future<bool> loginAction({@required BuildContext context, @required LoginRequestData request}) async {
  try {
    context.dispatchAction(UserActions.loading());
    final authRepository = Registry.di.repository.auth;
    final response = await authRepository.signIn(request);

    final session = Registry.di.session;
    session.setToken(response.token);

    final data = await Future.wait([
      authRepository.getAccount(),
      authRepository.getProfileStatus(),
    ]);
    if (data.contains(null)) {
      throw AppException(AppStrings.networkError);
    }

    final user = data[0];
    session.setUser(user);
    context.dispatchAction(UserActions.add(user));

    final profileStatus = data[1];
    context.dispatchAction(ProfileStatusActions.add(profileStatus));

    if ([response.user.isEmailVerified, response.user.isPhoneVerified].contains(0)) {
      await AppSnackBar.of(context).error(response.message);
      final routeName =
          response.user.isEmailVerified == 0 ? SignupRoutes.emailVerification : SignupRoutes.phoneVerification;
      Registry.di.coordinator.auth.toSignup(currentPage: routeName);
      return false;
    }

    context.dispatchAction(const NoticeActions.fetch());
    context.dispatchAction(const DashboardActions.fetch());

    AppSnackBar.of(context).hide();
    await biometricAction(context: context, request: request);
    Registry.di.coordinator.shared.toDashboard();
    return true;
  } catch (e, st) {
    AppLog.e(e, st, message: <String, String>{
      "login": request.phone,
    });
    final message = errorToString(e);
    context.dispatchAction(UserActions.error(message));
    AppSnackBar.of(context).error(message);
    return false;
  }
}
