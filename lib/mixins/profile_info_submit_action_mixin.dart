import 'dart:io' as io;

import 'package:borome/constants.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/widgets.dart';

mixin ProfileInfoSubmitActionMixin {
  BuildContext get context;

  bool get mounted;

  Future<bool> handleSubmit(io.File file, GlobalKey<ProfilePhotoFormViewState> photoViewKey) async {
    AppSnackBar.of(context).loading();
    try {
      await Registry.di.repository.auth.savePictureInfo(file);
      if (!mounted) {
        return false;
      }

      context.dispatchAction(UserActions.fetch());
      context.dispatchAction(ProfileStatusActions.fetch());
      photoViewKey.currentState.reset();
      AppSnackBar.of(context).success(AppStrings.successMessage);
      return true;
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
      return false;
    }
  }
}
