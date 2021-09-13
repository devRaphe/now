import 'package:borome/services.dart';
import 'package:meta/meta.dart';

const _isFirstTimeUser = "IS_FIRST_TIME_USER";

class FirstTimeUserCheck {
  @visibleForTesting
  static String get key => _isFirstTimeUser;

  static bool check(SharedPrefs sharedPrefs) {
    final state = sharedPrefs.getBool(key);
    if (state != false) {
      sharedPrefs.setBool(key, false);
      return true;
    }
    return false;
  }
}
