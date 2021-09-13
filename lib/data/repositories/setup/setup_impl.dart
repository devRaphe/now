import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';

class SetupImpl implements SetupRepository {
  SetupImpl({@required this.request, @required this.version, @required this.isDev});

  final Request request;
  final String version;
  final bool isDev;

  @override
  Future<SetUpData> initialize() async {
    final res = Response<dynamic>(
      await request.get(
        Endpoints.setup,
        options: Options(
          cache: true,
          cacheKeyBuilder: (_) => version,
          cacheType: CacheType.file,
          cacheExpiry: Duration(days: 7),
        ),
      ),
      isDev: isDev,
    );
    return SetUpData.fromJson(res.rawData);
  }

  @override
  Future<Pair<BankAccountData, String>> resolveBankAccount(String bank, String accountNumber) async {
    final res = Response<dynamic>(
      await request.post(
        Endpoints.resolveAccount,
        <String, String>{"bank": bank, "account_number": accountNumber},
        options: Options(cache: true, cacheType: CacheType.file, cacheKeyBuilder: (_) => "$bank $accountNumber"),
      ),
      isDev: isDev,
    );
    return Pair(BankAccountData.fromJson(res.rawData), res.message);
  }
}
