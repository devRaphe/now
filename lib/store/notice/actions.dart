import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxstore/rxstore.dart';

part 'actions.freezed.dart';

@freezed
abstract class NoticeActions with _$NoticeActions implements Action {
  const factory NoticeActions.fetch() = FetchNotice;

  const factory NoticeActions.read(int id) = ReadNotice;

  const factory NoticeActions.complete(List<NoticeModel> data) = CompleteNotice;

  const factory NoticeActions.loading() = FetchingNotice;

  const factory NoticeActions.error([String message]) = NoticeError;
}
