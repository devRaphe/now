class LoanRequestData {
  LoanRequestData({
    this.accountid,
    this.amount,
    this.duration,
    this.reason,
  });

  factory LoanRequestData.fromJson(Map<String, dynamic> json) {
    return LoanRequestData(
      accountid: int.tryParse(json['duration']?.toString()),
      amount: double.tryParse(json['amount']?.toString()),
      duration: int.tryParse(json['duration']?.toString()),
      reason: json['reason']?.toString(),
    );
  }

  int accountid;
  double amount;
  int duration;
  String reason;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountid': accountid,
      'amount': amount,
      'duration': duration,
      'reason': reason,
    };
  }

  @override
  String toString() {
    return 'LoanRequestData{accountid: $accountid, amount: $amount, duration: $duration, reason: $reason}';
  }
}
