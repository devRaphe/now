import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'payment.g.dart';

abstract class PaymentModel with ModelInterface implements Built<PaymentModel, PaymentModelBuilder> {
  factory PaymentModel([void Function(PaymentModelBuilder b) updates]) = _$PaymentModel;

  PaymentModel._();

  int get id;

  @BuiltValueField(wireName: 'loan_id')
  int get loanId;

  @BuiltValueField(wireName: 'loan_reference')
  String get loanReference;

  String get amount;

  @BuiltValueField(wireName: 'added_by')
  String get addedBy;

  @BuiltValueField(wireName: 'payment_method')
  String get paymentMethod;

  // TODO
  @nullable
  String get staff;

  // TODO
  @nullable
  String get charge;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  @nullable
  DateTime get updatedAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(PaymentModel.serializer, this);

  static PaymentModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(PaymentModel.serializer, map);

  static Serializer<PaymentModel> get serializer => _$paymentModelSerializer;
}
