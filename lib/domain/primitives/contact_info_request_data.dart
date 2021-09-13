class ContactInfoRequestData {
  ContactInfoRequestData();

  factory ContactInfoRequestData.fromJson(Map<String, dynamic> json) {
    return ContactInfoRequestData()
      ..address = json['address']
      ..city = json['city']
      ..email = json['email']
      ..phone = json['phone']
      ..state = json['state']
      ..landmark = json['landmark'];
  }

  String address;
  String city;
  String email;
  String phone;
  String state;
  String landmark;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'city': city,
      'email': email,
      'phone': phone,
      'state': state,
      'landmark': landmark,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactInfoRequestData &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          city == other.city &&
          email == other.email &&
          phone == other.phone &&
          state == other.state &&
          landmark == other.landmark;

  @override
  int get hashCode =>
      address.hashCode ^ city.hashCode ^ email.hashCode ^ phone.hashCode ^ state.hashCode ^ landmark.hashCode;

  @override
  String toString() {
    return 'ContactInfoRequestData{address: $address, city: $city, email: $email, phone: $phone, state: $state, landmark: $landmark}';
  }
}
