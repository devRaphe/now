import 'package:flutter/foundation.dart';

class LocationData {
  const LocationData({@required this.lat, @required this.lng});

  final double lat;
  final double lng;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'lat': lat, 'lng': lng};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationData && runtimeType == other.runtimeType && lat == other.lat && lng == other.lng;

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;

  @override
  String toString() {
    return 'LocationData{lat: $lat, lng: $lng}';
  }
}
