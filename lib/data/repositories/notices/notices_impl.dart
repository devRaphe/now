import 'dart:io';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';

class NoticeImpl extends NoticeRepository {
  NoticeImpl({@required this.request, @required this.isDev});

  final Request request;
  final bool isDev;

  @override
  Future<List<NoticeModel>> fetch() async {
    final res = Response<dynamic>(
      await request.get(Endpoints.notifications, options: Options(cache: true)),
      isDev: isDev,
    );
    return List<dynamic>.from(res.rawData["notifications"]["data"])
        .map((dynamic notice) => NoticeModel.fromJson(notice))
        .toList();
  }

  @override
  Future<NoticeModel> markAsRead(int id) async {
    final res =
        Response<dynamic>(await request.post(Endpoints.readNotification, <String, int>{"nid": id}), isDev: isDev);
    return NoticeModel.fromJson(res.rawData["notification"]);
  }

  @override
  Future<bool> addDeviceToken(String token) async {
    final res = Response<dynamic>(
      await request
          .post(Endpoints.addDeviceToken, <String, String>{"token": token, "platform": Platform.operatingSystem}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<NoticeModel> info(int id) async {
    final res = Response<dynamic>(
      await request.post(
        Endpoints.notificationDetails,
        <String, int>{"nid": id},
        options: Options(cache: true, cacheKeyBuilder: (_) => "$id"),
      ),
      isDev: isDev,
    );
    return NoticeModel.fromJson(res.rawData["notification"]);
  }
}
