import 'package:borome/data.dart';
import 'package:borome/environment.dart';
import 'package:borome/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Session', () {
    test('works normally', () {
      const mock = Environment.MOCK;
      final session = Session(environment: mock);
      expect(session.isDev, mock.isDev);
      expect(session.isMock, mock.isMock);
      expect(session.isDebugging, mock.isDebugging);
    });

    test('can manipulate token', () {
      final session = Session(environment: Environment.MOCK);

      expect(session.token.value, null);

      session.setToken('token');

      expect(session.token.value, 'token');

      session.setToken('nekot');

      expect(session.token.value, 'nekot');

      session.resetToken();

      expect(session.token.value, null);
    });

    test('can manipulate user', () async {
      final session = Session(environment: Environment.MOCK);
      final userModel = await AuthMockImpl(Duration.zero).getAccount();

      expect(session.user.value, null);

      session.setUser(userModel);

      expect(session.user.value, userModel);

      session.setUser(userModel.rebuild((b) => b..id = 50));

      expect(session.user.value.id, 50);

      session.resetUser();

      expect(session.user.value, null);
    });

    test('should not accept null environment', () {
      expect(() => Session(environment: null), throwsAssertionError);
    });
  });
}
