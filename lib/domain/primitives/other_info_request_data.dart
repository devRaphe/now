class OtherInfoRequestData {
  OtherInfoRequestData({
    this.heardFrom,
    this.referredBy,
  });

  String heardFrom;
  String referredBy;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "heard_from": heardFrom,
      "referred_by": referredBy,
    };
  }
}
