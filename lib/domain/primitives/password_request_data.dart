class PasswordRequestData {
  PasswordRequestData();

  factory PasswordRequestData.fromJson(Map<String, dynamic> json) {
    return PasswordRequestData()
      ..oldPassword = json['old_password']
      ..password = json['password'];
  }

  String oldPassword;
  String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'current_password': oldPassword,
      'new_password': password,
      'password': password,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordRequestData &&
          runtimeType == other.runtimeType &&
          oldPassword == other.oldPassword &&
          password == other.password;

  @override
  int get hashCode => oldPassword.hashCode ^ password.hashCode;

  @override
  String toString() {
    return 'PasswordRequestData{current_password: $oldPassword, new_password: $password, password: $password}';
  }
}
