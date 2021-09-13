import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'account.g.dart';

abstract class AccountModel with ModelInterface implements Built<AccountModel, AccountModelBuilder> {
  factory AccountModel([void Function(AccountModelBuilder b) updates]) = _$AccountModel;

  AccountModel._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'account_bank')
  String get accountBank;

  @BuiltValueField(wireName: 'bank_code')
  String get bankCode;

  @BuiltValueField(wireName: 'account_name')
  String get accountName;

  @BuiltValueField(wireName: 'account_number')
  String get accountNumber;

  @BuiltValueField(wireName: 'account_verified')
  int get accountVerified;

  @BuiltValueField(wireName: 'is_default')
  int get isDefault;

  @memoized
  bool get isDefaultBool => isDefault == 1;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(AccountModel.serializer, this);

  static AccountModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(AccountModel.serializer, map);

  static Serializer<AccountModel> get serializer => _$accountModelSerializer;
}
