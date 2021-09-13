import 'package:borome/domain.dart';
import 'package:borome/environment.dart';
import 'package:flutter/foundation.dart';

class Session {
  Session({@required Environment environment})
      : assert(environment != null),
        envName = environment.value,
        isDebugging = environment.isDebugging,
        isProduction = environment.isProduction,
        isStaging = environment.isStaging,
        isMock = environment.isMock,
        isDev = environment.isDev;

  final bool isDebugging;

  final String envName;

  final bool isProduction;

  final bool isMock;

  final bool isStaging;

  final bool isDev;

  final _token = ValueNotifier<String>(null);

  void setToken(String token) {
    _token.value = token;
  }

  ValueNotifier<String> get token => _token;

  void resetToken() => setToken(null);

  final _user = ValueNotifier<UserModel>(null);

  void setUser(UserModel user) {
    _user.value = user;
  }

  ValueNotifier<UserModel> get user => _user;

  void resetUser() => setUser(null);
}
