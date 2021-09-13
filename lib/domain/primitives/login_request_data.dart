import 'package:flutter/foundation.dart';

class LoginRequestData {
  LoginRequestData({this.phone, this.password, @required this.deviceId});

  String password;

  String phone;

  String deviceId;

  bool get isValid => phone != null && password != null && deviceId != null;

  Map<String, String> toMap() {
    return <String, String>{'phone': phone, 'password': password, 'device_id': deviceId};
  }
}
