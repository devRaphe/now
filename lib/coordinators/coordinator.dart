import 'package:flutter/widgets.dart';

import 'auth_coordinator.dart';
import 'loan_coordinator.dart';
import 'notification_coordinator.dart';
import 'payments_coordinator.dart';
import 'profile_coordinator.dart';
import 'services_coordinator.dart';
import 'shared_coordinator.dart';

@immutable
class Coordinator {
  Coordinator(GlobalKey<NavigatorState> navigatorKey)
      : assert(navigatorKey != null),
        auth = AuthCoordinator(navigatorKey),
        loan = LoanCoordinator(navigatorKey),
        notification = NotificationCoordinator(navigatorKey),
        profile = ProfileCoordinator(navigatorKey),
        shared = SharedCoordinator(navigatorKey),
        payments = PaymentsCoordinator(navigatorKey),
        services = ServicesCoordinator(navigatorKey);

  final AuthCoordinator auth;
  final LoanCoordinator loan;
  final NotificationCoordinator notification;
  final ProfileCoordinator profile;
  final SharedCoordinator shared;
  final PaymentsCoordinator payments;
  final ServicesCoordinator services;
}
