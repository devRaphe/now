class WorkDetailsRequestData {
  WorkDetailsRequestData();

  factory WorkDetailsRequestData.fromJson(Map<String, dynamic> json) {
    return WorkDetailsRequestData()
      ..companyAddress = json['company_address']
      ..companyName = json['company_name']
      ..companyPhone = json['company_phone']
      ..industry = json['industry']
      ..monthlyIncome = json['monthly_income']
      ..occupation = json['occupation']
      ..payday = json['payday']
      ..resumptionDate = json['resumptionDate']
      ..workStatus = json['work_status'];
  }

  String companyAddress;

  String companyName;
  String companyPhone;
  String industry;
  String monthlyIncome;
  String occupation;
  String payday;
  // TODO: figure out more about this field
  String resumptionDate;
  String workStatus;

  DateTime get paydayAsDateTime {
    final today = DateTime.now();
    return DateTime(today.year, today.month, payday == null ? 25 : int.tryParse(payday));
  }

  DateTime get resumptionDateAsDateTime {
    var split = resumptionDate?.split('-');
    if (split == null || split.length < 3) {
      split = ['1', '1', '1970'];
    }
    return DateTime(int.tryParse(split[2]), int.tryParse(split[1]), int.tryParse(split[0]));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'company_address': companyAddress,
      'company_name': companyName,
      'company_phone': companyPhone,
      'industry': industry,
      'monthly_income': monthlyIncome,
      'occupation': occupation,
      'payday': payday,
      'work_status': workStatus,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkDetailsRequestData &&
          runtimeType == other.runtimeType &&
          companyAddress == other.companyAddress &&
          companyName == other.companyName &&
          companyPhone == other.companyPhone &&
          industry == other.industry &&
          monthlyIncome == other.monthlyIncome &&
          occupation == other.occupation &&
          payday == other.payday &&
          workStatus == other.workStatus;

  @override
  int get hashCode =>
      companyAddress.hashCode ^
      companyName.hashCode ^
      companyPhone.hashCode ^
      industry.hashCode ^
      monthlyIncome.hashCode ^
      occupation.hashCode ^
      payday.hashCode ^
      workStatus.hashCode;

  @override
  String toString() {
    return 'WorkDetailsRequestData{companyAddress: $companyAddress, companyName: $companyName, companyPhone: $companyPhone, industry: $industry, monthlyIncome: $monthlyIncome, occupation: $occupation, payday: $payday, workStatus: $workStatus}';
  }
}
