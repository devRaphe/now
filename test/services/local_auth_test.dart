import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {
  @override
  Future<bool> authenticate({
    @required String localizedReason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    AndroidAuthMessages androidAuthStrings = const AndroidAuthMessages(),
    IOSAuthMessages iOSAuthStrings = const IOSAuthMessages(),
    bool sensitiveTransaction = true,
    bool biometricOnly = false,
  }) async {
    return true;
  }

  @override
  Future<bool> get canCheckBiometrics async => true;
}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  final _items = <String, String>{};

  @override
  Future<void> write({
    @required String key,
    @required String value,
    IOSOptions iOptions = IOSOptions.defaultOptions,
    AndroidOptions aOptions,
    LinuxOptions lOptions,
  }) async {
    _items[key] = value;
  }

  @override
  Future<String> read({
    @required String key,
    IOSOptions iOptions = IOSOptions.defaultOptions,
    AndroidOptions aOptions,
    LinuxOptions lOptions,
  }) async {
    return _items[key];
  }

  @override
  Future<void> delete({
    @required String key,
    IOSOptions iOptions = IOSOptions.defaultOptions,
    AndroidOptions aOptions,
    LinuxOptions lOptions,
  }) async {
    _items.remove(key);
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, dynamic>{});
  final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());

  group("LocalAuth", () {
    test("works normally", () async {
      final local = LocalAuthService(
        auth: MockLocalAuthentication(),
        storage: MockFlutterSecureStorage(),
        sharedPrefs: sharedPrefs,
      );

      final creds = Pair("08012345678", "password");

      expect(await local.isAvailable(), true);

      expect(await local.fetchCredentials(), null);

      expect(local.hasCredentials(), false);

      expect(await local.authenticate(), true);

      await local.persistCredentials(creds.first, creds.second);

      expect(local.hasCredentials(), true);

      expect(await local.fetchCredentials(), creds);

      await local.reset();
    });

    test("would not allow null parameters", () async {
      expect(() => LocalAuthService(auth: null, storage: null, sharedPrefs: null), throwsAssertionError);
      expect(
        () => LocalAuthService(auth: null, storage: MockFlutterSecureStorage(), sharedPrefs: null),
        throwsAssertionError,
      );
      expect(
        () => LocalAuthService(auth: null, storage: null, sharedPrefs: sharedPrefs),
        throwsAssertionError,
      );
      expect(
        () => LocalAuthService(auth: MockLocalAuthentication(), storage: null, sharedPrefs: null),
        throwsAssertionError,
      );
    });
  });
}
