class PersonalInfoRequestData {
  PersonalInfoRequestData();

  factory PersonalInfoRequestData.fromJson(Map<String, dynamic> json) {
    return PersonalInfoRequestData()
      ..firstname = json['firstname']
      ..gender = json['gender']
      ..dob = json['dob']
      ..educationLevel = json['education_level']
      ..maritalStatus = json['marital_status']
      ..surname = json['surname'];
  }

  String firstname;
  String gender;
  String dob;
  String educationLevel;
  String maritalStatus;
  String surname;

  DateTime get dobAsDateTime {
    var split = dob?.split('-');
    if (split == null || split.length < 3) {
      split = ['1', '1', '1970'];
    }
    return DateTime(int.tryParse(split[2]), int.tryParse(split[1]), int.tryParse(split[0]));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'gender': gender,
      'dob': dob,
      'education_level': educationLevel,
      'marital_status': maritalStatus,
      'surname': surname,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfoRequestData &&
          runtimeType == other.runtimeType &&
          firstname == other.firstname &&
          gender == other.gender &&
          dob == other.dob &&
          educationLevel == other.educationLevel &&
          maritalStatus == other.maritalStatus &&
          surname == other.surname;

  @override
  int get hashCode =>
      firstname.hashCode ^
      gender.hashCode ^
      dob.hashCode ^
      educationLevel.hashCode ^
      maritalStatus.hashCode ^
      surname.hashCode;

  @override
  String toString() {
    return 'PersonalInfoRequestData{firstname: $firstname, gender: $gender, dob: $dob, educationLevel: $educationLevel, maritalStatus: $maritalStatus, surname: $surname}';
  }
}
