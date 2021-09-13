import 'package:borome/domain.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';

import 'sub_state.dart';

part 'app_state.g.dart';

abstract class AppState with DiagnosticableTreeMixin implements Built<AppState, AppStateBuilder> {
  factory AppState([void updates(AppStateBuilder b)]) = _$AppState;

  AppState._();

  factory AppState.initialState() => _$AppState(
        (b) => b
          ..user = SubState.withEmpty()
          ..profileStatus = SubState.withEmpty()
          ..setup = SubState(value: SetUpData.empty())
          ..dashboard = SubState.withEmpty()
          ..notice = SubState.withEmpty(),
      );

  AppState reset() => rebuild(
        (b) => b
          ..user = SubState.withEmpty()
          ..profileStatus = SubState.withEmpty()
          ..dashboard = SubState.withEmpty()
          ..notice = SubState.withEmpty(),
      );

  SubState<UserModel> get user;

  SubState<ProfileStatusModel> get profileStatus;

  SubState<SetUpData> get setup;

  SubState<DashboardData> get dashboard;

  SubState<List<NoticeModel>> get notice;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SubState<UserModel>>('user', user));
    properties.add(DiagnosticsProperty<SubState<ProfileStatusModel>>('profileStatus', profileStatus));
    properties.add(DiagnosticsProperty<SubState<SetUpData>>('setup', setup));
    properties.add(DiagnosticsProperty<SubState<DashboardData>>('dashboard', dashboard));
    properties.add(DiagnosticsProperty<SubState<List<NoticeModel>>>('notice', notice));
  }
}
