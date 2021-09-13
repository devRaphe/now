import '../models.dart';

abstract class NoticeRepository {
  Future<NoticeModel> markAsRead(int id);

  Future<NoticeModel> info(int id);

  Future<List<NoticeModel>> fetch();

  Future<bool> addDeviceToken(String token);
}
