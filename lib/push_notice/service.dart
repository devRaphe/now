import 'dart:async';
import 'dart:convert';

import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:clock/clock.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'models.dart';

class PushNoticeService {
  PushNoticeService({
    @required this.navigatorKey,
    @required this.messaging,
    @required this.notifications,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final FirebaseMessaging messaging;
  final FlutterLocalNotificationsPlugin notifications;

  final BehaviorSubject<int> _onPush = BehaviorSubject<int>();
  final BehaviorSubject<PushNoticeIntentData> _onNavigate = BehaviorSubject<PushNoticeIntentData>();
  final BehaviorSubject<String> _onRegister = BehaviorSubject<String>();
  final BehaviorSubject<void> _onDispose = BehaviorSubject<void>();

  Stream<int> get onPush => _onPush.stream.distinct();

  Stream<PushNoticeIntentData> get onNavigate => _onNavigate.stream.distinct();

  Stream<String> get onRegister => _onRegister.stream;

  Stream<void> get onDispose => _onDispose.stream;

  void _onResume(RemoteMessage message) {
    if (message == null) {
      return;
    }
    AppLog.i("PushNotice: " + message.toString());
    try {
      _onTapNotification(_buildMessage(message).data);
    } catch (e) {
      AppLog.i(e);
    }
  }

  void _onMessage(RemoteMessage message) {
    AppLog.i("PushNotice: " + message.toString());
    try {
      _showItemDialog(_buildMessage(message));
    } catch (e) {
      AppLog.i(e);
    }
  }

  void initialize() async {
    messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: false,
    );

    messaging.getInitialMessage().then(_onResume);

    FirebaseMessaging.onMessage.debounceTime(Duration(seconds: 1)).listen(_onMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);

    notifications.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(),
      ),
      onSelectNotification: (message) => _onSelectNotification(PushNoticeModel.fromJson(_stringToMap(message))),
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    messaging.getToken().then((String token) {
      AppLog.i("Successfully registered for interactive push: $token");
      if (token == null) {
        return;
      }
      _onRegister.add(token);
    });
  }

  void dispose() {
    _onDispose.add(null);
    _onPush.close();
    _onNavigate.close();
    _onRegister.close();
    _onDispose.close();
  }

  void _onTapNotification(PushNoticeDataModel data) async {
    AppLog.i(data.toString());
    if (data?.intent == null) {
      return;
    }

    final _args = data.intent.split(":");
    _onNavigate.add(PushNoticeIntentData(
      path: _args[0],
      param: _args.length > 1 ? _args[1] : null,
      id: data.id,
    ));
  }

  void _showItemDialog(PushNoticeModel message) async {
    final platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        AppStrings.appName.toLowerCase(),
        AppStrings.appName,
        AppStrings.appName,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: AppStrings.appName,
      ),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    _onPush.add(clock.now().second);

    await notifications.show(
      clock.now().millisecond,
      message.notification.title,
      message.notification.body,
      platformChannelSpecifics,
      payload: _mapToString(message.toMap()),
    );
  }

  Future<dynamic> _onSelectNotification(PushNoticeModel payload) async {
    if (payload != null) {
      _onTapNotification(payload.data);
    }
  }

  static PushNoticeModel _buildMessage(RemoteMessage msg) {
    return PushNoticeModel(
      data: PushNoticeDataModel(
        id: msg.messageId,
        intent: msg.data['intent'],
        clickAction: msg.data['click_action'],
        extra: msg.data['extra'],
      ),
      notification: PushNoticeNotificationModel(
        title: msg.notification?.title ?? 'A new notification',
        body: msg.notification?.body ?? 'A new notification',
      ),
    );
  }

  static String _mapToString(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    try {
      return json.encode(map);
    } catch (e, st) {
      AppLog.e(e, st);
      return null;
    }
  }

  static Map<String, dynamic> _stringToMap(String string) {
    if (string == null || string.isEmpty) {
      return null;
    }
    try {
      return json.decode(string);
    } catch (e, st) {
      AppLog.e(e, st);
      return null;
    }
  }
}
