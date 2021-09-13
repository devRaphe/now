import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';

class SignupRequestDataNotifier extends ChangeNotifier {
  SignupRequestDataNotifier(this._value);

  SignupRequestData _value;

  SignupRequestData get value => _value;

  void update(SignupRequestData data) {
    _value = data;
    notifyListeners();
  }
}
