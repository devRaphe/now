import 'package:borome/constants.dart';
import 'package:borome/domain.dart';

class PaymentMockImpl implements PaymentRepository {
  @override
  Future<String> debitAccount(String reference, String amount) async {
    return AppStrings.successMessage;
  }

  @override
  Future<String> checkBankTransfer() async {
    return AppStrings.successMessage;
  }
}
