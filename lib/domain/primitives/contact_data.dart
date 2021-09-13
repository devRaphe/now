import 'package:flutter/foundation.dart';

class ContactData {
  const ContactData({@required this.email, @required this.name, @required this.phone});

  final String email;
  final String name;
  final String phone;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'ContactData{email: $email, name: $name, phone: $phone}';
  }
}
