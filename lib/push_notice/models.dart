import 'package:meta/meta.dart';

class PushNoticeIntentData {
  PushNoticeIntentData({
    @required this.path,
    @required this.param,
    @required this.id,
  });

  final String path;
  final String param;
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushNoticeIntentData &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          param == other.param &&
          id == other.id;

  @override
  int get hashCode => path.hashCode ^ param.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'PushNoticeIntentData{path: $path, param: $param, id: $id}';
  }
}

class PushNoticeModel {
  PushNoticeModel({@required this.notification, @required this.data});

  PushNoticeModel.fromJson(Map<String, dynamic> json)
      : notification = PushNoticeNotificationModel.fromJson(json['notification']),
        data = PushNoticeDataModel.fromJson(json['data']);

  final PushNoticeNotificationModel notification;
  final PushNoticeDataModel data;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notification': notification?.toMap(),
      'data': data?.toMap(),
    };
  }

  @override
  String toString() {
    return 'PushNoticeModel{notification: $notification, data: $data}';
  }
}

class PushNoticeDataModel {
  PushNoticeDataModel({@required this.id, @required this.intent, @required this.extra, @required this.clickAction});

  PushNoticeDataModel.fromJson(dynamic json)
      : id = json['id'],
        intent = json['intent'],
        extra = json['extra'],
        clickAction = json['click_action'];

  /// Notification id
  final String id;

  /// Eg: job:12 or staff:23 or broadcast
  final String intent;
  final String extra;
  final String clickAction;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'intent': intent,
      'extra': extra,
      'click_action': clickAction,
    };
  }

  @override
  String toString() {
    return 'PushNoticeDataModel{id: $id, intent: $intent, extra: $extra, clickAction: $clickAction}';
  }
}

class PushNoticeNotificationModel {
  PushNoticeNotificationModel({@required this.body, @required this.title});

  PushNoticeNotificationModel.fromJson(dynamic json)
      : body = json['body'],
        title = json['title'];

  final String body;
  final String title;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'PushNoticeNotificationModel{body: $body, title: $title}';
  }
}
