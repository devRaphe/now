import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'notice.g.dart';

abstract class NoticeModel with ModelInterface implements Built<NoticeModel, NoticeModelBuilder> {
  factory NoticeModel([void Function(NoticeModelBuilder b) updates]) = _$NoticeModel;

  NoticeModel._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'staff_id')
  @nullable
  int get staffId;

  String get title;

  String get content;

  @BuiltValueField(wireName: 'requested_files')
  @nullable
  int get requestedFiles;

  @memoized
  bool get requestedFilesAsBool => (requestedFiles ?? 0) == 1;

  @nullable
  BuiltList<String> get images;

  @BuiltValueField(wireName: 'is_read')
  int get isRead;

  @memoized
  bool get isReadAsBool => isRead == 1;

  @BuiltValueField(wireName: 'read_at')
  @nullable
  DateTime get readAt;

  @nullable
  String get from;

  @BuiltValueField(wireName: 'sent_by')
  String get sentBy;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(NoticeModel.serializer, this);

  static NoticeModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(NoticeModel.serializer, map);

  static Serializer<NoticeModel> get serializer => _$noticeModelSerializer;
}
