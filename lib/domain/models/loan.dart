import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'account.dart';
import 'model.dart';
import 'serializers.dart';

part 'loan.g.dart';

abstract class LoanModel with ModelInterface implements Built<LoanModel, LoanModelBuilder> {
  factory LoanModel([void Function(LoanModelBuilder b) updates]) = _$LoanModel;

  LoanModel._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'account_id')
  @nullable
  int get accountId;

  String get reference;

  String get status;

  @memoized
  bool get isDue => status == 'due';

  @memoized
  bool get isOverdue => status == 'overdue';

  @memoized
  bool get canRepayLoan => ['disbursed', 'overdue', 'partial', 'due'].contains(status);

  @memoized
  bool get canApplyForLoan => !canRepayLoan && !['pending'].contains(status);

  @BuiltValueField(wireName: 'repayment_status')
  String get repaymentStatus;

  @BuiltValueField(wireName: 'date_fully_paid')
  @nullable
  String get dateFullyPaid;

  @BuiltValueField(wireName: 'date_approved')
  @nullable
  DateTime get dateApproved;

  @BuiltValueField(wireName: 'date_disbursed')
  @nullable
  DateTime get dateDisbursed;

  @BuiltValueField(wireName: 'date_due')
  DateTime get dateDue;

  @nullable
  String get delay;

  @BuiltValueField(wireName: 'max_amount')
  String get maxAmount;

  String get amount;

  @nullable
  AccountModel get account;

  @BuiltValueField(wireName: 'next_payment')
  String get nextPayment;

  String get interest;

  @BuiltValueField(wireName: 'overdue_interest')
  @nullable
  String get overdueInterest;

  @BuiltValueField(wireName: 'recovery_charge')
  @nullable
  String get recoveryCharge;

  @BuiltValueField(wireName: 'gateway_charge')
  @nullable
  String get gatewayCharge;

  @BuiltValueField(wireName: 'transfer_charge')
  @nullable
  String get transferCharge;

  @BuiltValueField(wireName: 'default_likelihood')
  @nullable
  String get defaultLikelihood;

  @BuiltValueField(wireName: 'duration_days')
  int get durationDays;

  @BuiltValueField(wireName: 'extended_days')
  @nullable
  String get extendedDays;

  @BuiltValueField(wireName: 'extended_reason')
  @nullable
  String get extendedReason;

  @BuiltValueField(wireName: 'amount_for_repayment')
  String get amountForRepayment;

  @BuiltValueField(wireName: 'amount_remaining')
  String get amountRemaining;

  @BuiltValueField(wireName: 'loan_reason')
  String get loanReason;

  @BuiltValueField(wireName: 'decline_reason')
  @nullable
  String get declineReason;

  @BuiltValueField(wireName: 'was_overdue')
  @nullable
  int get wasOverdue;

  @BuiltValueField(wireName: 'requires_manual')
  @nullable
  int get requiresManual;

  @BuiltValueField(wireName: 'is_extended')
  @nullable
  int get isExtended;

  @BuiltValueField(wireName: 'is_transfer_verified')
  @nullable
  int get isTransferVerified;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(LoanModel.serializer, this);

  static LoanModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(LoanModel.serializer, map);

  static Serializer<LoanModel> get serializer => _$loanModelSerializer;
}
