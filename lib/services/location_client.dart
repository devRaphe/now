import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:geolocator/geolocator.dart';

import 'exceptions.dart';

class LocationClient {
  Future<LocationData> fetchLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      if (position == null) {
        throw AppException(AppStrings.locationUnavailable);
      }
      return LocationData(lat: position.latitude, lng: position.longitude);
    } on PermissionDeniedException catch (_) {
      throw AppException(AppStrings.locationDisabled);
    } on LocationServiceDisabledException catch (_) {
      throw AppException(AppStrings.locationDisabled);
    } catch (e, st) {
      AppLog.e(e, st);
      throw AppException(AppStrings.locationUnavailable);
    }
  }

  Future<bool> enableLocation() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (isEnabled == true) {
        return true;
      }

      final permission = await Geolocator.checkPermission();
      if (permission == null) {
        return false;
      }

      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if ([LocationPermission.denied, LocationPermission.deniedForever].contains(requestPermission)) {
          return false;
        }
        return true;
      }

      if (permission == LocationPermission.deniedForever) {
        final isOpened = await Geolocator.openAppSettings();
        if (isOpened == false) {
          await Geolocator.openLocationSettings();
        }
        throw AppException(AppStrings.retryApplyForLoanWhenLocationWasDisabled);
      }

      return true;
    } on AppException catch (_) {
      rethrow;
    } catch (e, st) {
      AppLog.e(e, st);
      throw AppException(AppStrings.locationDisabled);
    }
  }
}
