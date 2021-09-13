import 'dart:convert';

import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'shared_prefs.dart';

const _localAuthKey = "LOCAL_AUTH_KEY";
const _hasBiometricKey = "HAS_BIOMETRIC_KEY";

class LocalAuthService {
  LocalAuthService({
    @required this.auth,
    @required this.storage,
    @required this.sharedPrefs,
  }) : assert(auth != null && storage != null && sharedPrefs != null);

  final LocalAuthentication auth;
  final FlutterSecureStorage storage;
  final SharedPrefs sharedPrefs;

  @visibleForTesting
  Future<void> reset() async {
    try {
      await storage.delete(key: _localAuthKey);
      await sharedPrefs.remove(_hasBiometricKey);
    } catch (e, st) {
      AppLog.e(e, st);
    }
  }

  Future<bool> isAvailable() async {
    try {
      return await auth.canCheckBiometrics;
    } catch (e, st) {
      AppLog.e(e, st);
    }

    return false;
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'authenticate to access',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
    } catch (e, st) {
      AppLog.e(e, st);
    }

    return false;
  }

  bool hasCredentials() {
    return sharedPrefs.getBool(_hasBiometricKey) ?? false;
  }

  Future<Pair<String, String>> fetchCredentials() async {
    if (!hasCredentials()) {
      return null;
    }

    try {
      final value = await storage.read(key: _localAuthKey);
      final dynamic map = json.decode(value);
      return Pair(map["phone"], map["password"]);
    } catch (e, st) {
      AppLog.e(e, st);
    }
    return null;
  }

  Future<bool> persistCredentials(String phone, String password) async {
    try {
      final map = {"phone": phone, "password": password};
      await storage.write(key: _localAuthKey, value: json.encode(map));
      await sharedPrefs.setBool(_hasBiometricKey, true);
      return true;
    } catch (e, st) {
      AppLog.e(e, st);
    }
    return false;
  }
}
