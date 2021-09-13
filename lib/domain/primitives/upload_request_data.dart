import 'package:flutter/foundation.dart';

import 'contact_data.dart';
import 'location_data.dart';

class UploadRequestData {
  UploadRequestData({
    @required this.contacts,
    @required this.location,
    @required this.os,
  });

  List<ContactData> contacts;
  LocationData location;
  String os;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contacts': this.contacts,
      'location': this.location.toMap(),
      'os': this.os,
    };
  }

  @override
  String toString() {
    return 'UploadRequestData{contacts: $contacts, location: $location, os: $os}';
  }
}
