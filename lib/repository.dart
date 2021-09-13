import 'package:flutter/foundation.dart';

import 'domain.dart';

class Repository {
  Repository({
    @required this.auth,
    @required this.setup,
    @required this.loan,
    @required this.notice,
    @required this.payment,
  });

  final AuthRepository auth;
  final SetupRepository setup;
  final LoanRepository loan;
  final NoticeRepository notice;
  final PaymentRepository payment;
}
