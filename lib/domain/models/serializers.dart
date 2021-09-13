// ignore: unused_import
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:clock/clock.dart';

import 'account.dart';
import 'bank.dart';
import 'fees.dart';
import 'file.dart';
import 'loan.dart';
import 'notice.dart';
import 'payment.dart';
import 'profile_status.dart';
import 'schedule.dart';
import 'user.dart';

part 'serializers.g.dart';

@SerializersFor([
  UserModel,
  LoanModel,
  AccountModel,
  FileModel,
  BankModel,
  PaymentModel,
  ScheduleModel,
  NoticeModel,
  ProfileStatusModel,
  FeesModel,
  PaymentMethodInfoModel,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(_DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

class _DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>(<Type>[DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime, {FullType specifiedType = FullType.unspecified}) {
    return dateTime.toString();
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) {
    try {
      return DateTime.tryParse(serialized as String);
    } catch (e) {
      return clock.now();
    }
  }
}
