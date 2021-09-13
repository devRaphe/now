import 'dart:async';

import 'package:borome/coordinators.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:rxstore/rxstore.dart';
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data.dart';
import 'environment.dart';
import 'error_handling.dart';
import 'error_view.dart';
import 'push_notice.dart';
import 'registry.dart';
import 'repository.dart';
import 'screens.dart';
import 'services.dart';
import 'store.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Future<dynamic>.delayed(Duration(seconds: 1));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  final navigatorKey = GlobalKey<NavigatorState>();
  final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
  final session = Session(environment: environment);
  final locationClient = LocationClient();
  final loanApplicationService = LoanApplicationService(prefs: sharedPrefs);
  final appDeviceInfo = await AppDeviceInfo.initialize();
  final errorReporter = ErrorReporter(
    client: _SentryReporterClient(
      SentryClient(SentryOptions(dsn: 'https://2ad5bae84dbf4ec0b96de0d88905119f@o446736.ingest.sentry.io/5426534')),
      appDeviceInfo: appDeviceInfo,
      session: session,
    ),
  );

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    logListener(onReleaseModeException: errorReporter.report),
  );

  final repository = _createRepository(environment, appDeviceInfo.version, session.token);

  Registry()
    ..add<Repository>(repository)
    ..add<Session>(session)
    ..add<Permissions>(Permissions(locationClient))
    ..add<SharedPrefs>(sharedPrefs)
    ..add<CameraClient>(await _initializeCameraClient())
    ..add<LocalAuthService>(
      LocalAuthService(auth: LocalAuthentication(), storage: FlutterSecureStorage(), sharedPrefs: sharedPrefs),
    )
    ..add<ContactsClient>(ContactsClient())
    ..add<LocationClient>(locationClient)
    ..add<AppDeviceInfo>(appDeviceInfo)
    ..add<LoanApplicationService>(loanApplicationService)
    ..add<ErrorReporter>(errorReporter)
    ..add<Coordinator>(Coordinator(navigatorKey));

  final store = Store<AppState>(
    combineReducers([
      userReducer,
      setupReducer,
      dashboardReducer,
      appReducer,
      noticeReducer,
      profileStatusReducer,
    ]),
    initialState: AppState.initialState(),
    epic: combineEpics([
      initSetupEpic(repository.setup),
      fetchUserEpic(repository.auth, session.setUser),
      fetchProfileStatusEpic(repository.auth),
      fetchDashboardEpic(repository.auth),
      fetchNoticeEpic(repository.notice),
      readNoticeEpic(repository.notice),
    ]),
  );

  await firebase.Firebase.initializeApp();

  ErrorBoundary(
    isReleaseMode: !session.isDebugging,
    errorViewBuilder: (_) => const ErrorView(),
    onException: AppLog.e,
    child: App(
      store: store,
      navigatorKey: navigatorKey,
      isFirstTime: FirstTimeUserCheck.check(sharedPrefs),
      pushNoticeService: PushNoticeService(
        navigatorKey: navigatorKey,
        messaging: FirebaseMessaging.instance,
        notifications: FlutterLocalNotificationsPlugin(),
      ),
    ),
  );
}

Future<CameraClient> _initializeCameraClient() async {
  try {
    return CameraClient(await availableCameras());
  } on CameraException catch (e, st) {
    AppLog.e(e, st, message: 'Failed to initialize camera');
    return CameraClient([]);
  }
}

Repository _createRepository(Environment environment, String version, ValueNotifier<String> token) {
  if (environment.isMock) {
    return Repository(
      auth: AuthMockImpl(),
      setup: SetupMockImpl(),
      loan: LoanMockImpl(),
      notice: NoticeMockImpl(),
      payment: PaymentMockImpl(),
    );
  }

  final request = Request(
    baseUrl: environment.url,
    timeout: Duration(seconds: environment.isDev ? 30 : 45),
    token: token,
    logger: environment.isDebugging,
  );

  return Repository(
    auth: AuthImpl(request: request, isDev: environment.isDev),
    setup: SetupImpl(request: request, version: version, isDev: environment.isDev),
    loan: LoanImpl(request: request, isDev: environment.isDev),
    notice: NoticeImpl(request: request, isDev: environment.isDev),
    payment: PaymentImpl(request: request, isDev: environment.isDev),
  );
}

class _SentryReporterClient implements ReporterClient {
  _SentryReporterClient(
    this.client, {
    @required this.appDeviceInfo,
    @required this.session,
  });

  final SentryClient client;
  final AppDeviceInfo appDeviceInfo;
  final Session session;

  @override
  FutureOr<void> report({
    @required StackTrace stackTrace,
    @required Object error,
    @required Object extra,
  }) async {
    final user = session.user.value;
    final event = SentryEvent(
      exception: error,
      environment: session.envName,
      release: appDeviceInfo.version,
      tags: appDeviceInfo.toMap(),
      user: SentryUser(
        id: '${user?.id ?? appDeviceInfo.deviceId}',
        email: user?.email ?? '',
        username: user?.fullname ?? '',
        extras: <String, String>{
          'deviceId': appDeviceInfo.deviceId,
          'phone': user?.phone ?? 'n/a',
        },
      ),
      extra: extra,
    );

    await client.captureEvent(event, stackTrace: stackTrace);
  }

  @override
  void log(Object object) {
    AppLog.i(object);
  }
}

extension on Environment {
  String get url {
    return {
      Environment.DEVELOPMENT: 'https://v2-staging.borome.ng/api',
      Environment.STAGING: 'https://v2-staging.borome.ng/api',
      Environment.PRODUCTION: 'https://v2.borome.ng/api',
    }[this];
  }
}
