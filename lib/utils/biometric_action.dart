import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:flutter/widgets.dart';

import 'ui/show_confirm_dialog.dart';

enum BiometricStatus {
  ok,
  notAvailable,
  skipped,
  failed,
}

Future<BiometricStatus> biometricAction({@required BuildContext context, @required LoginRequestData request}) async {
  final auth = Registry.di.localAuth;
  if (auth.hasCredentials()) {
    final creds = await auth.fetchCredentials();
    if (creds.first == request.phone) {
      return BiometricStatus.ok;
    }
  }

  if (!await auth.isAvailable()) {
    return BiometricStatus.notAvailable;
  }

  final choice = await showConfirmDialog(
    context,
    "Your biometrics could be used to sign in the next time.",
    yes: "Allow",
    no: "Skip",
  );
  if (choice != true) {
    return BiometricStatus.skipped;
  }

  final result = await auth.persistCredentials(request.phone, request.password);
  return result ? BiometricStatus.ok : BiometricStatus.failed;
}
