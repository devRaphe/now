import 'package:flutter/foundation.dart';

import '../models/user.dart';

class LoginResponseData {
  LoginResponseData({
    @required this.user,
    @required this.token,
    @required this.message,
  });

  final UserModel user;
  final String token;
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginResponseData &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          token == other.token &&
          message == other.message;

  @override
  int get hashCode => user.hashCode ^ token.hashCode ^ message.hashCode;
}
