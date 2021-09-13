import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';

class PaymentImpl implements PaymentRepository {
  PaymentImpl({@required this.request, @required this.isDev});

  final Request request;
  final bool isDev;

  @override
  Future<String> debitAccount(String reference, String amount) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.accountDebit, <String, String>{"reference": reference, "amount": amount}),
      isDev: isDev,
    );
    return res.message;
  }

  @override
  Future<String> checkBankTransfer() async {
    final res = Response<dynamic>(
      await request.get(Endpoints.bankTransferCheck),
      isDev: isDev,
    );
    return res.message;
  }
}
