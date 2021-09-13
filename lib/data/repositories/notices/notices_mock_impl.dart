import 'package:borome/domain.dart';
import 'package:borome/utils.dart';

class NoticeMockImpl extends NoticeRepository {
  NoticeMockImpl([this.delay = const Duration(milliseconds: 1000)]);

  final Duration delay;

  @override
  Future<List<NoticeModel>> fetch() async {
    final data = await jsonReader("notifications_success", delay);
    return List<dynamic>.from(data["notifications"]["data"])
        .map((dynamic notice) => NoticeModel.fromJson(notice))
        .toList();
  }

  @override
  Future<NoticeModel> markAsRead(int id) async {
    final data = await jsonReader("notification_update_success", delay);
    return NoticeModel.fromJson(data["notification"]);
  }

  @override
  Future<bool> addDeviceToken(String token) async {
    return true;
  }

  @override
  Future<NoticeModel> info(int id) async {
    final data = await jsonReader("notification_update_success", delay);
    return NoticeModel.fromJson(data["notification"]);
  }
}
