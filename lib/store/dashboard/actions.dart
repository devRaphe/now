import 'package:borome/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxstore/rxstore.dart';

part 'actions.freezed.dart';

@freezed
abstract class DashboardActions with _$DashboardActions implements Action {
  const factory DashboardActions.fetch([@Default(SortType.month) SortType duration]) = FetchDashboard;

  const factory DashboardActions.complete(DashboardData data) = CompleteDashboard;

  const factory DashboardActions.loading() = FetchingDashboard;

  const factory DashboardActions.error([String message]) = DashboardError;
}
