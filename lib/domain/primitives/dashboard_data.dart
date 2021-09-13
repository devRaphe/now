import '../models/loan.dart';

class SortType {
  const SortType._(this.index);

  static const SortType day = SortType._(0);
  static const SortType month = SortType._(1);
  static const SortType year = SortType._(2);
  static const SortType all = SortType._(3);

  static List<String> values = ['day', 'month', 'year', 'all'];

  static List<String> prettifiedValues = ['Daily', 'Monthly', 'Yearly', 'All'];

  static SortType fromValue(String value) {
    final index = values.indexOf(value);
    if (index >= 0) {
      return SortType._(index);
    }
    return SortType.all;
  }

  final int index;

  String get value => values[index];

  @override
  String toString() => 'SortType.$value';
}

class DashboardData {
  const DashboardData({
    this.maxRate,
    this.duration,
    this.adImage,
    this.lastLoan,
    this.loans,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      maxRate: double.tryParse(json['max_rate'].toString()),
      duration: SortType.fromValue(json['duration']),
      adImage: json['ad_image'],
      lastLoan: json['last_loan'] != null ? LoanModel.fromJson(json['last_loan']) : null,
      loans: json['loans'] != null ? (json['loans'] as List).map((dynamic i) => LoanModel.fromJson(i)).toList() : null,
    );
  }

  final double maxRate;
  final SortType duration;
  final String adImage;
  final LoanModel lastLoan;
  final List<LoanModel> loans;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardData &&
          runtimeType == other.runtimeType &&
          maxRate == other.maxRate &&
          duration == other.duration &&
          adImage == other.adImage &&
          lastLoan == other.lastLoan &&
          loans == other.loans;

  @override
  int get hashCode => maxRate.hashCode ^ duration.hashCode ^ adImage.hashCode ^ lastLoan.hashCode ^ loans.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'max_rate': maxRate,
      'duration': duration.value,
      'ad_image': adImage,
      'last_loan': lastLoan,
      'loans': loans,
    };
  }

  @override
  String toString() {
    return 'DashboardData{maxRate: $maxRate, duration: $duration, adImage: $adImage, lastLoan: $lastLoan, loans: $loans}';
  }
}
