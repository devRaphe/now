import 'package:borome/utils.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

import 'account.dart';
import 'file.dart';
import 'model.dart';
import 'serializers.dart';

part 'user.g.dart';

abstract class UserModel with ModelInterface implements Built<UserModel, UserModelBuilder> {
  factory UserModel([void Function(UserModelBuilder b) updates]) = _$UserModel;

  UserModel._();

  int get id;

  String get email;

  String get phone;

  @BuiltValueField(wireName: 'alt_phone')
  @nullable
  String get altPhone;

  @nullable
  String get address;

  @nullable
  String get state;

  @nullable
  String get city;

  @nullable
  String get landmark;

  @nullable
  String get image;

  @memoized
  bool get hasImage => image != null && image.isNotEmpty;

  @BuiltValueField(wireName: 'marital_status')
  @nullable
  String get maritalStatus;

  String get firstname;

  String get surname;

  String get fullname => "${firstname ?? ""} ${surname ?? ""}".trim();

  @nullable
  String get dob;

  @memoized
  DateTime get dobAsDateTime {
    var split = dob?.split('-');
    if (split == null || split.length < 3) {
      split = ['1', '1', '1970'];
    }
    return DateTime(int.tryParse(split[2]), int.tryParse(split[1]), int.tryParse(split[0]));
  }

  @nullable
  String get gender;

  @BuiltValueField(wireName: 'education_level')
  @nullable
  String get educationLevel;

  @BuiltValueField(wireName: 'work_status')
  @nullable
  String get workStatus;

  @nullable
  String get industry;

  @nullable
  String get occupation;

  @BuiltValueField(wireName: 'company_name')
  @nullable
  String get companyName;

  @BuiltValueField(wireName: 'company_phone')
  @nullable
  String get companyPhone;

  @BuiltValueField(wireName: 'company_address')
  @nullable
  String get companyAddress;

  @nullable
  String get payday;

  @memoized
  DateTime get paydayAsDateTime {
    final today = DateTime.now();
    return DateTime(today.year, today.month, payday == null ? 25 : int.tryParse(payday));
  }

  @BuiltValueField(wireName: 'monthly_income')
  @nullable
  String get monthlyIncome;

  @BuiltValueField(wireName: 'real_monthly_income')
  @nullable
  String get realMonthlyIncome;

  @BuiltValueField(wireName: 'guarantor_name')
  @nullable
  String get guarantorName;

  @BuiltValueField(wireName: 'guarantor_phone')
  @nullable
  String get guarantorPhone;

  @BuiltValueField(wireName: 'guarantor_email')
  @nullable
  String get guarantorEmail;

  @BuiltValueField(wireName: 'guarantor_relationship')
  @nullable
  String get guarantorRelationship;

  @BuiltValueField(wireName: 'heard_from')
  @nullable
  String get heardFrom;

  @BuiltValueField(wireName: 'ref_code')
  @nullable
  String get refCode;

  @BuiltValueField(wireName: 'referred_by')
  @nullable
  String get referredBy;

  @nullable
  String get bvn;

  @nullable
  String get facebook;

  @nullable
  String get instagram;

  @nullable
  String get twitter;

  @BuiltValueField(wireName: 'phone_verified_at')
  @nullable
  String get phoneVerifiedAt;

  @BuiltValueField(wireName: 'email_verified_at')
  @nullable
  String get emailVerifiedAt;

  @BuiltValueField(wireName: 'bvn_verified_at')
  @nullable
  String get bvnVerifiedAt;

  @BuiltValueField(wireName: 'profile_completed_at')
  @nullable
  String get profileCompletedAt;

  @nullable
  String get delay;

  @BuiltValueField(wireName: 'is_phone_verified')
  int get isPhoneVerified;

  @BuiltValueField(wireName: 'is_email_verified')
  int get isEmailVerified;

  @BuiltValueField(wireName: 'is_banned')
  int get isBanned;

  @BuiltValueField(wireName: 'is_bvn_verified')
  int get isBvnVerified;

  @BuiltValueField(wireName: 'has_active_loan')
  int get hasActiveLoan;

  @BuiltValueField(wireName: 'is_profile_complete')
  int get isProfileComplete;

  @BuiltValueField(wireName: 'has_taken_loan')
  int get hasTakenLoan;

  @BuiltValueField(wireName: 'can_edit')
  int get canEdit;

  @BuiltValueField(wireName: 'credit_score')
  double get creditScore;

  @BuiltValueField(wireName: 'status')
  String get status;

  @BuiltValueField(wireName: 'other')
  @nullable
  JsonObject get other;

  @BuiltValueField(wireName: 'last_login')
  @nullable
  DateTime get lastLogin;

  @BuiltValueField(wireName: 'virtual_account_number')
  @nullable
  String get virtualAccountNumber;

  @BuiltValueField(wireName: 'virtual_bank_name')
  @nullable
  String get virtualBankName;

  @BuiltValueField(wireName: "repayment_account_number")
  String get repaymentAccountNumber;

  @BuiltValueField(wireName: "repayment_account_name")
  String get repaymentAccountName;

  @BuiltValueField(wireName: "repayment_bank_name")
  String get repaymentBankName;

  @BuiltValueField(wireName: "eligible_amount")
  String get eligibleAmount;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @nullable
  BuiltList<AccountModel> get accounts;

  @nullable
  BuiltList<FileModel> get files;

  @memoized
  @nullable
  Map<String, List<FileModel>> get filesGrouped {
    return groupModelBy<FileModel>(files?.toList() ?? [], (file) => file.name);
  }

  UserModel mergeWith(UserModel other) => UserModel.fromJson(toJson()..addAll(other.toJson()));

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(UserModel.serializer, this);

  static UserModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(UserModel.serializer, map);

  static Serializer<UserModel> get serializer => _$userModelSerializer;
}

extension ListX on List<AccountModel> {
  AccountModel findById(int id) {
    return firstWhere((item) => item.id == id, orElse: () => null);
  }
}
