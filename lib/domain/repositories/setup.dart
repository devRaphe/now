import '../primitives.dart';

abstract class SetupRepository {
  Future<SetUpData> initialize();

  Future<Pair<BankAccountData, String>> resolveBankAccount(String bank, String accountNumber);
}
