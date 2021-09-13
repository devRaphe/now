import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'schedule.g.dart';

abstract class ScheduleModel with ModelInterface implements Built<ScheduleModel, ScheduleModelBuilder> {
  factory ScheduleModel([void Function(ScheduleModelBuilder b) updates]) = _$ScheduleModel;

  ScheduleModel._();

  int get id;

  @BuiltValueField(wireName: 'loan_id')
  int get loanId;

  @BuiltValueField(wireName: 'loan_payment_id')
  @nullable
  int get loanPaymentId;

  @BuiltValueField(wireName: 'amount')
  String get oldAmount;

  @memoized
  double get amount => oldAmount == null ? 0 : double.tryParse(oldAmount);

  String get description;

  @BuiltValueField(wireName: 'payment_status')
  String get paymentStatus;

  String get reference;

  String get status;

  @BuiltValueField(wireName: 'date_due')
  DateTime get dateDue;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(ScheduleModel.serializer, this);

  static ScheduleModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(ScheduleModel.serializer, map);

  static Serializer<ScheduleModel> get serializer => _$scheduleModelSerializer;
}
