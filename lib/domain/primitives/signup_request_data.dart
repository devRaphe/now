import 'package:flutter/foundation.dart';

class SignupRequestData {
  SignupRequestData({@required this.deviceId});

  String firstname;
  String surname;
  String phone;
  String email;
  String password;
  final String deviceId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'phone': phone,
      'email': email,
      'password': password,
      'surname': surname,
      'device_id': deviceId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupRequestData &&
          runtimeType == other.runtimeType &&
          deviceId == other.deviceId &&
          firstname == other.firstname &&
          phone == other.phone &&
          email == other.email &&
          password == other.password &&
          surname == other.surname;

  @override
  int get hashCode =>
      deviceId.hashCode ^ firstname.hashCode ^ phone.hashCode ^ email.hashCode ^ password.hashCode ^ surname.hashCode;

  @override
  String toString() {
    return 'SignupRequestData{deviceId: $deviceId, firstname: $firstname, phone: $phone, email: $email, password: $password, surname: $surname}';
  }
}
