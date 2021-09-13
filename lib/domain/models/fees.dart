import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'model.dart';
import 'serializers.dart';

part 'fees.g.dart';

abstract class FeesModel with ModelInterface implements Built<FeesModel, FeesModelBuilder> {
  factory FeesModel([void Function(FeesModelBuilder b) updates]) = _$FeesModel;

  factory FeesModel.empty() {
    return FeesModel(
      (b) => b
        ..accountDebit = PaymentMethodInfoModel.empty().toBuilder()
        ..bankTransfer = PaymentMethodInfoModel.empty().toBuilder()
        ..cards = BuiltList<PaymentMethodInfoModel>.from(<PaymentMethodInfoModel>[]).toBuilder(),
    );
  }

  FeesModel._();

  @BuiltValueField(wireName: 'account_debit')
  PaymentMethodInfoModel get accountDebit;

  @BuiltValueField(wireName: 'bank_transfer')
  PaymentMethodInfoModel get bankTransfer;

  BuiltList<PaymentMethodInfoModel> get cards;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(FeesModel.serializer, this);

  static FeesModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(FeesModel.serializer, map);

  bool get isEmpty => accountDebit.isEmpty && bankTransfer.isEmpty && cards.isEmpty;

  static Serializer<FeesModel> get serializer => _$feesModelSerializer;
}

abstract class PaymentMethodInfoModel
    with ModelInterface
    implements Built<PaymentMethodInfoModel, PaymentMethodInfoModelBuilder> {
  factory PaymentMethodInfoModel([void Function(PaymentMethodInfoModelBuilder b) updates]) = _$PaymentMethodInfoModel;

  factory PaymentMethodInfoModel.empty() {
    return PaymentMethodInfoModel(
      (b) => b
        ..base = '0.0'
        ..percent = '0.0'
        ..name = '',
    );
  }

  PaymentMethodInfoModel._();

  String get base;

  String get percent;

  @nullable
  String get name;

  bool get isEmpty => base == '0.0' && percent == '0.0' && (name?.isEmpty ?? true);

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(PaymentMethodInfoModel.serializer, this);

  static PaymentMethodInfoModel fromJson(Map<String, dynamic> map) =>
      serializers.deserializeWith(PaymentMethodInfoModel.serializer, map);

  static Serializer<PaymentMethodInfoModel> get serializer => _$paymentMethodInfoModelSerializer;
}
