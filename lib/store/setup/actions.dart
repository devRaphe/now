import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxstore/rxstore.dart';

part 'actions.freezed.dart';

@freezed
abstract class SetupActions with _$SetupActions implements Action {
  const factory SetupActions.init() = InitSetup;

  const factory SetupActions.complete(SetUpData data) = CompleteSetup;

  const factory SetupActions.loading() = FetchingSetup;

  const factory SetupActions.error([String message]) = SetupError;
}
