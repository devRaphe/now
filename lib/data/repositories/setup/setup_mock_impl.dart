import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';

class SetupMockImpl implements SetupRepository {
  SetupMockImpl([this.delay = const Duration(milliseconds: 1000)]);

  final Duration delay;

  @override
  Future<SetUpData> initialize() async {
    final data = await jsonReader("setup", delay);
    return SetUpData.fromJson(data);
  }

  @override
  Future<Pair<BankAccountData, String>> resolveBankAccount(String bank, String accountNumber) async {
    final data = await jsonReader("resolve_bank_account", delay);
    return Pair(BankAccountData.fromJson(data), AppStrings.successMessage);
  }
}
