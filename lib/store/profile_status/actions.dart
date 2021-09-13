import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxstore/rxstore.dart';

part 'actions.freezed.dart';

@freezed
abstract class ProfileStatusActions with _$ProfileStatusActions implements Action {
  const factory ProfileStatusActions.add(ProfileStatusModel value) = AddProfileStatus;

  const factory ProfileStatusActions.fetch() = FetchProfileStatus;

  const factory ProfileStatusActions.loading() = ProfileStatusLoading;

  const factory ProfileStatusActions.error([String message]) = ProfileStatusErrorDetails;
}
