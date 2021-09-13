class BankRequestData {
  BankRequestData({
    this.bvn,
    this.bank,
    this.accountNumber,
    this.accountName,
  });

  String bvn;
  String bank;
  String accountNumber;
  String accountName;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bvn': bvn,
      'bank': bank,
      'account_number': accountNumber,
      'account_name': accountName,
    };
  }
}
