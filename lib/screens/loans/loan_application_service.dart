import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:flutter/foundation.dart';

class LoanApplicationService {
  LoanApplicationService({@required this.prefs}) : assert(prefs != null);

  final SharedPrefs prefs;
  static const _key = "KEY";

  Future<void> persistCache(LoanRequestData request, LoanSummaryData summary) async {
    await prefs.setMap(_key, <String, dynamic>{"request": request.toMap(), "summary": summary.toMap()});
  }

  Pair<LoanRequestData, LoanSummaryData> hydrateCache() {
    final res = prefs.getMap(_key);
    if (res == null) {
      return null;
    }
    return Pair(LoanRequestData.fromJson(res["request"]), LoanSummaryData.fromJson(res["summary"]));
  }

  Future<void> emptyCache() async {
    await prefs.remove(_key);
  }
}
