class RateData {
  const RateData({
    this.maxDurationDays,
    this.maxRate,
    this.minDurationDays,
    this.minRate,
  });

  factory RateData.fromJson(Map<String, dynamic> json) {
    return RateData(
      maxDurationDays: int.tryParse(json['max_duration_days']?.toString()),
      maxRate: double.tryParse(json['max_rate']?.toString()),
      minDurationDays: int.tryParse(json['min_duration_days']?.toString()),
      minRate: double.tryParse(json['min_rate']?.toString()),
    );
  }

  final int maxDurationDays;
  final double maxRate;
  final int minDurationDays;
  final double minRate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'max_duration_days': this.maxDurationDays,
      'max_rate': this.maxRate,
      'min_duration_days': this.minDurationDays,
      'min_rate': this.minRate,
    };
  }

  @override
  String toString() {
    return 'Rate{max_duration_days: $maxDurationDays, max_rate: $maxRate, min_duration_days: $minDurationDays, min_rate: $minRate}';
  }
}
