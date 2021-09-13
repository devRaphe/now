class BankAccountData {
  BankAccountData({
    this.status,
    this.name,
    this.accountNumber,
    this.bank,
  });

  factory BankAccountData.fromJson(Map<String, dynamic> json) {
    return BankAccountData(
      status: json['status'],
      name: json['name'],
      accountNumber: json['accountNumber'],
      bank: json['bank'],
    );
  }

  String status;
  String name;
  String accountNumber;
  String bank;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'name': name,
      'account_number': accountNumber,
      'bank': bank,
    };
  }
}
