import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxstore/rxstore.dart';

part 'app_actions.freezed.dart';

@freezed
abstract class AppActions with _$AppActions implements Action {
  const factory AppActions.signOut() = AppSignOut;
}
