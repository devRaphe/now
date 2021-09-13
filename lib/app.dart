import 'dart:async';
import 'dart:ui';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/push_notice.dart';
import 'package:borome/registry.dart';
import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rxstore/flutter_rxstore.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:rxstore/rxstore.dart';

class App extends StatefulWidget {
  const App({
    Key key,
    @required this.store,
    @required this.navigatorKey,
    @required this.isFirstTime,
    @required this.pushNoticeService,
    this.navigatorObservers,
    this.home,
  }) : super(key: key);

  final List<NavigatorObserver> navigatorObservers;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final Store<AppState> store;
  final PushNoticeService pushNoticeService;
  final Widget home;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    widget.pushNoticeService.initialize();

    try {
      firstValidUserStream(widget.store)
          .withLatestFrom<String, String>(widget.pushNoticeService.onRegister, (_, token) => token)
          .listen(registerDeviceToken);
    } catch (e, st) {
      AppLog.e(e, st, message: 'Failed to retrieve first valid user');
    }

    waitUntilUser<int>(widget.store, widget.pushNoticeService.onPush)
        .takeUntil(widget.pushNoticeService.onDispose)
        .listen((value) => widget.store.dispatcher.add(const NoticeActions.fetch()));

    waitUntilUser<PushNoticeIntentData>(widget.store, widget.pushNoticeService.onNavigate)
        .takeUntil(widget.pushNoticeService.onDispose)
        .listen((data) async {
      widget.store.dispatcher.add(NoticeActions.read(int.tryParse(data.id)));

      AppLog.i(['pushNoticeService', 'onNavigate', data]);

      final page = (() {
        switch (data.path) {
          case 'add_files':
            return AddFilePage(isRequested: true);
          case 'notification':
          default:
            return AsyncNotificationDetailPage(
              futureBuilder: () => Registry.di.repository.notice.info(int.tryParse(data.id)),
            );
        }
      })();

      await widget.navigatorKey.currentState.push<void>(RouteTransition.fadeIn(page));
    });
  }

  @override
  void dispose() {
    widget.store.dispose();
    widget.pushNoticeService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnackBarProvider(
      navigatorKey: widget.navigatorKey,
      child: StoreProvider<AppState>(
        store: widget.store,
        child: ScaleAware(
          config: ScaleConfig(width: 375, height: 812),
          child: ThemeProvider(
            child: Builder(
              builder: (BuildContext context) => OneTimeBuilder(
                once: () => widget.store.dispatcher.add(SetupActions.init()),
                child: _Banner(
                  session: Registry.di.session,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: AppStrings.appName,
                    color: Colors.white,
                    navigatorKey: widget.navigatorKey,
                    home: widget.home,
                    navigatorObservers: widget.navigatorObservers ?? [],
                    theme: ThemeProvider.of(context).themeData(Theme.of(context)),
                    onGenerateRoute: (RouteSettings settings) => _PageRoute(
                      builder: (_) => SplashPage(isFirstTime: widget.isFirstTime),
                      settings: settings.copyWith(name: AppRoutes.start),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({Key key, @required this.session, @required this.child}) : super(key: key);

  final Widget child;
  final Session session;

  @override
  Widget build(BuildContext context) {
    if (session.isProduction) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: [
        child,
        CustomPaint(
          painter: BannerPainter(
            message: session.envName,
            textDirection: TextDirection.ltr,
            layoutDirection: TextDirection.ltr,
            location: BannerLocation.topStart,
            color: session.isMock
                ? AppColors.primary
                : session.isStaging
                    ? AppColors.success
                    : AppColors.dark,
          ),
        ),
      ],
    );
  }
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(_, Animation<double> animation, __, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}

Stream<UserModel> firstValidUserStream(Store<AppState> store) {
  return store.state.map((state) => state.user.value).where((data) => data != null).take(1);
}

Stream<T> waitUntilUser<T>(Store<AppState> store, Stream<T> source) {
  return source
      .withLatestFrom<UserModel, T>(firstValidUserStream(store), (data, setup) => setup == null ? null : data)
      .where((data) => data != null);
}

void registerDeviceToken(String token) async {
  const key = 'FCM_REGISTRATION';
  final sharedPrefs = Registry.di.sharedPref;
  if (sharedPrefs.contains(key) && sharedPrefs.getString(key) == token) {
    return;
  }

  await sharedPrefs.setString(key, token);
  await Registry.di.repository.notice.addDeviceToken(token);
}
