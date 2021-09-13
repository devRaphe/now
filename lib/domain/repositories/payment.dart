abstract class PaymentRepository {
  Future<String> debitAccount(String reference, String amount);

  Future<String> checkBankTransfer();
}
