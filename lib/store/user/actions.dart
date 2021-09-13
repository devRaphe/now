import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxstore/rxstore.dart';

part 'actions.freezed.dart';

@freezed
abstract class UserActions with _$UserActions implements Action {
  const factory UserActions.add(UserModel value) = AddUser;

  const factory UserActions.fetch() = FetchUser;

  const factory UserActions.update(UserModel user) = UpdateUser;

  const factory UserActions.updateAccounts(List<AccountModel> accounts) = UpdateUserAccounts;

  const factory UserActions.loading() = UserLoading;

  const factory UserActions.error([String message]) = UserErrorDetails;
}
