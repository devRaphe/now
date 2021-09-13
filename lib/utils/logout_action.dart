import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:flutter/widgets.dart';

void logoutAction({@required BuildContext context}) {
  Registry.di.session
    ..resetUser()
    ..resetToken();
  context.dispatchAction(AppActions.signOut());
  Registry.di.coordinator.shared.toStart(pristine: false, clearHistory: true);
}
