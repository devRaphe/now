class NextOfKinRequestData {
  NextOfKinRequestData();

  factory NextOfKinRequestData.fromJson(Map<String, dynamic> json) {
    return NextOfKinRequestData()
      ..guarantorEmail = json['guarantor_email']
      ..guarantorName = json['guarantor_name']
      ..guarantorPhone = json['guarantor_phone']
      ..guarantorRelationship = json['guarantor_relationship'];
  }

  String guarantorEmail;
  String guarantorName;
  String guarantorPhone;
  String guarantorRelationship;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guarantor_email': guarantorEmail,
      'guarantor_name': guarantorName,
      'guarantor_phone': guarantorPhone,
      'guarantor_relationship': guarantorRelationship,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NextOfKinRequestData &&
          runtimeType == other.runtimeType &&
          guarantorEmail == other.guarantorEmail &&
          guarantorName == other.guarantorName &&
          guarantorPhone == other.guarantorPhone &&
          guarantorRelationship == other.guarantorRelationship;

  @override
  int get hashCode =>
      guarantorEmail.hashCode ^ guarantorName.hashCode ^ guarantorPhone.hashCode ^ guarantorRelationship.hashCode;

  @override
  String toString() {
    return 'NextOfKinRequestData{guarantorEmail: $guarantorEmail, guarantorName: $guarantorName, guarantorPhone: $guarantorPhone, guarantorRelationship: $guarantorRelationship}';
  }
}
