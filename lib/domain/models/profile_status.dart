import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'profile_status.g.dart';

abstract class ProfileStatusModel with ModelInterface implements Built<ProfileStatusModel, ProfileStatusModelBuilder> {
  factory ProfileStatusModel([void Function(ProfileStatusModelBuilder b) updates]) = _$ProfileStatusModel;

  ProfileStatusModel._();

  @BuiltValueField(wireName: 'contact_information')
  bool get contactInformation;

  @BuiltValueField(wireName: 'personal_information')
  bool get personalInformation;

  @BuiltValueField(wireName: 'work_information')
  bool get workInformation;

  @BuiltValueField(wireName: 'nok_information')
  bool get nokInformation;

  @BuiltValueField(wireName: 'profile_image')
  bool get profileImage;

  @BuiltValueField(wireName: 'work_id')
  bool get workId;

  @BuiltValueField(wireName: 'bank_account')
  bool get bankAccount;

  @BuiltValueField(wireName: 'bank_account_connection_link')
  String get bankAccountConnectionLink;

  @BuiltValueField(wireName: 'payment_verification')
  bool get paymentVerification;

  @BuiltValueField(wireName: 'payment_verification_link')
  String get paymentVerificationLink;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(ProfileStatusModel.serializer, this);

  static ProfileStatusModel fromJson(Map<String, dynamic> map) =>
      serializers.deserializeWith(ProfileStatusModel.serializer, map);

  static Serializer<ProfileStatusModel> get serializer => _$profileStatusModelSerializer;
}
