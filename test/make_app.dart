import 'package:borome/app.dart';
import 'package:borome/coordinators.dart';
import 'package:borome/domain.dart';
import 'package:borome/environment.dart';
import 'package:borome/error_handling.dart';
import 'package:borome/push_notice.dart';
import 'package:borome/registry.dart';
import 'package:borome/repository.dart';
import 'package:borome/screens/loans/loans.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:rxstore/rxstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/permissions_test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {
  @override
  Future<RemoteMessage> getInitialMessage() async => RemoteMessage();

  @override
  Future<String> getToken({String vapidKey}) async => "";
}

class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSetupRepository extends Mock implements SetupRepository {}

class MockLoanRepository extends Mock implements LoanRepository {}

class MockNoticeRepository extends Mock implements NoticeRepository {}

class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockLocalAuthentication extends Mock implements LocalAuthentication {
  @override
  Future<bool> get canCheckBiometrics async => false;
}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockContactsClient extends Fake implements ContactsClient {
  @override
  Future<List<ContactData>> fetchContacts() async => [];
}

class MockLocationClient extends Fake implements LocationClient {
  @override
  Future<LocationData> fetchLocation() async => LocationData(lng: 1, lat: 2);

  @override
  Future<bool> enableLocation() async => true;
}

App makeApp({
  @required List<NavigatorObserver> observers,
  @required GlobalKey<NavigatorState> navigatorKey,
  AppState initialState,
  Widget home,
  Reducer<AppState> reducer,
}) {
  return App(
    store: Store(reducer ?? dummyReducer, initialState: initialState ?? AppState.initialState()),
    navigatorKey: navigatorKey,
    isFirstTime: false,
    home: home,
    pushNoticeService: PushNoticeService(
      navigatorKey: navigatorKey,
      messaging: MockFirebaseMessaging(),
      notifications: MockFlutterLocalNotificationsPlugin(),
    ),
    navigatorObservers: observers ?? [],
  );
}

Future<Registry> setupRegistry({
  @required GlobalKey<NavigatorState> navigatorKey,
  LocalAuthService localAuth,
}) async {
  final registry = Registry();
  final session = Session(environment: Environment.MOCK);
  final sharedPrefs = SharedPrefs(MockSharedPreferences());
  final camera = CameraClient([]);
  final locationClient = MockLocationClient();
  final appDeviceInfo = AppDeviceInfo.mock();
  final repository = Repository(
    auth: MockAuthRepository(),
    setup: MockSetupRepository(),
    loan: MockLoanRepository(),
    notice: MockNoticeRepository(),
    payment: MockPaymentRepository(),
  );
  registry
    ..add<Repository>(repository)
    ..add<Session>(session)
    ..add<Permissions>(Permissions(locationClient, MockPermissionHandler()))
    ..add<SharedPrefs>(sharedPrefs)
    ..add<CameraClient>(camera)
    ..add<LocalAuthService>(
      localAuth ??
          LocalAuthService(
            auth: MockLocalAuthentication(),
            storage: MockFlutterSecureStorage(),
            sharedPrefs: sharedPrefs,
          ),
    )
    ..add<ContactsClient>(MockContactsClient())
    ..add<LocationClient>(locationClient)
    ..add<AppDeviceInfo>(appDeviceInfo)
    ..add<LoanApplicationService>(LoanApplicationService(prefs: sharedPrefs))
    ..add<ErrorReporter>(ErrorReporter())
    ..add<Coordinator>(Coordinator(navigatorKey));
  return registry;
}

AppState dummyReducer(AppState state, Action action) => state;
