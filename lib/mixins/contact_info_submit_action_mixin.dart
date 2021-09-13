import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:flutter/widgets.dart';

import 'dismiss_keyboard_mixin.dart';

mixin ContactInfoSubmitActionMixin {
  BuildContext get context;

  bool get mounted;

  Future<bool> handleSubmit(ContactInfoRequestData request) async {
    closeKeyboardAction(context);
    AppSnackBar.of(context).loading();
    try {
      final user = await Registry.di.repository.auth.saveContactInfo(request);
      if (!mounted) {
        return false;
      }
      Registry.di.session.setUser(user);
      context.dispatchAction(UserActions.update(user));
      context.dispatchAction(ProfileStatusActions.fetch());
      AppSnackBar.of(context).success(AppStrings.successMessage);
      return true;
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
      return false;
    }
  }
}
