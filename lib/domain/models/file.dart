import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'file.g.dart';

abstract class FileModel with ModelInterface implements Built<FileModel, FileModelBuilder> {
  factory FileModel([void Function(FileModelBuilder b) updates]) = _$FileModel;

  FileModel._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'vetted_by')
  @nullable
  String get vettedBy;

  String get name;

  @nullable
  String get description;

  String get url;

  String get status;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(FileModel.serializer, this);

  static FileModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(FileModel.serializer, map);

  static Serializer<FileModel> get serializer => _$fileModelSerializer;
}
