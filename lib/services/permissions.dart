import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:platform/platform.dart';

import 'exceptions.dart';
import 'location_client.dart';

class Permissions {
  Permissions(this.location, [PermissionHandlerPlatform handler])
      : this.handler = handler ?? PermissionHandlerPlatform.instance;

  final PermissionHandlerPlatform handler;
  final LocationClient location;

  @visibleForTesting
  static const permissions = [
    Permission.contacts,
    Permission.location,
  ];

  Future<_Result> enableLocation() async {
    try {
      final status = await location.enableLocation();
      if (status != true) {
        return _Result(AppStrings.notEnoughPermissions);
      }
      return _Result.ok();
    } on AppException catch (e) {
      return _Result(e.message);
    } catch (e, st) {
      AppLog.e(e, st);
      return _Result(AppStrings.locationDisabled);
    }
  }

  Future<_Result> request() async {
    for (final group in permissions) {
      final status = await _getPermissionStatus(group);
      if (![PermissionStatus.granted, PermissionStatus.limited].contains(status)) {
        return _Result(AppStrings.notEnoughPermissions);
      }
    }
    return enableLocation();
  }

  Future<_Result> checkStorage(Platform platform) async {
    if (platform.isIOS) {
      return _Result.ok();
    }

    final status = await _getPermissionStatus(Permission.storage);
    if (![PermissionStatus.granted, PermissionStatus.limited].contains(status)) {
      return _Result(AppStrings.notEnoughPermissions);
    }
    return _Result.ok();
  }

  Future<PermissionStatus> _getPermissionStatus(Permission group) async {
    final permission = await handler.checkPermissionStatus(group);
    if (permission != PermissionStatus.granted &&
        (permission == PermissionStatus.permanentlyDenied || permission == PermissionStatus.denied)) {
      final status = await handler.requestPermissions([group]);
      return status[group] ?? PermissionStatus.limited;
    }

    return permission;
  }
}

class _Result {
  const _Result(this.message);

  _Result.ok() : message = "";

  final String message;

  bool get isOk => message.isEmpty;
}
