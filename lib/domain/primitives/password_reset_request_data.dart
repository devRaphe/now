import 'package:flutter/foundation.dart';

class PasswordResetData {
  PasswordResetData({
    @required this.phone,
    @required this.code,
    @required this.password,
  });

  final String phone;
  final String code;
  final String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'new_password': password,
      'new_password_confirmation': password,
      'phone': phone,
    };
  }

  @override
  String toString() {
    return 'PasswordResetData{code: $code, new_password: $password, new_password_confirmation: $password, phone: $phone}';
  }
}
