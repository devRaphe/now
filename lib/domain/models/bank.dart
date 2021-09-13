import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'bank.g.dart';

abstract class BankModel with ModelInterface implements Built<BankModel, BankModelBuilder> {
  factory BankModel([void Function(BankModelBuilder b) updates]) = _$BankModel;

  BankModel._();

  int get id;

  String get name;

  String get code;

  @nullable
  String get imageUrl;

//  @nullable
//  Object get isMobileVerified;
//
//  @nullable
//  Object get branches;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(BankModel.serializer, this);

  static BankModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(BankModel.serializer, map);

  static Serializer<BankModel> get serializer => _$bankModelSerializer;
}
