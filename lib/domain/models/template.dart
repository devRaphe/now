//import 'package:borome/data/models/model.dart';
//import 'package:borome/data/models/serializers.dart';
//import 'package:built_value/built_value.dart';
//import 'package:built_value/serializer.dart';
//
//part 'user.g.dart';
//
//abstract class UserModel with ModelInterface implements Built<UserModel, UserModelBuilder> {
//  factory UserModel([void updates(UserModelBuilder b)]) = _$UserModel;
//
//  UserModel._();
//
//@BuiltValueField(wireName: "alt_phone")
//@nullable
//  String get id;
//
//  @override
//  Map<String, dynamic> toMap() => serializers.serializeWith(UserModel.serializer, this);
//
//  static UserModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(UserModel.serializer, map);
//
//  static Serializer<UserModel> get serializer => _$userModelSerializer;
//}
