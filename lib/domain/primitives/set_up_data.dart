import 'package:flutter/foundation.dart';

import '../models/bank.dart';
import '../models/fees.dart';

class SetUpData {
  SetUpData({
    @required this.banks,
    @required this.heardFrom,
    @required this.industry,
    @required this.occupation,
    @required this.states,
    @required this.workStatus,
    @required this.relationships,
    @required this.loanReasons,
    @required this.cities,
    @required this.paymentUrl,
    @required this.bankImages,
    @required this.fees,
  })  : assert(banks != null),
        assert(heardFrom != null),
        assert(industry != null),
        assert(occupation != null),
        assert(states != null),
        assert(workStatus != null),
        assert(relationships != null),
        assert(loanReasons != null),
        assert(cities != null),
        assert(paymentUrl != null),
        assert(bankImages != null),
        assert(fees != null);

  factory SetUpData.fromJson(Map<String, dynamic> json) {
    final banks =
        json['banks'] != null ? (json['banks'] as List).map((dynamic i) => BankModel.fromJson(i)).toList() : null;
    return SetUpData(
      banks: banks,
      heardFrom: json['heard_from'] != null ? List<String>.from(json['heard_from']) : null,
      industry: json['industry'] != null ? List<String>.from(json['industry']) : null,
      occupation: json['occupation'] != null ? List<String>.from(json['occupation']) : null,
      states: json['states'] != null ? List<String>.from(json['states']) : null,
      workStatus: json['work_status'] != null ? List<String>.from(json['work_status']) : null,
      relationships: json['relationships'] != null ? List<String>.from(json['relationships']) : null,
      loanReasons: json['loan_reasons'] != null ? List<String>.from(json['loan_reasons']) : null,
      cities: json['cities'] != null ? mapCities(json['cities']) : null,
      paymentUrl: json['payment_url'] != null ? json['payment_url'] : null,
      bankImages: banks != null ? mapBankImages(banks) : {},
      fees: json['fees'] != null ? FeesModel.fromJson(json['fees']) : FeesModel.empty(),
    );
  }

  factory SetUpData.empty() {
    return SetUpData(
      banks: [],
      heardFrom: [],
      industry: [],
      occupation: [],
      states: [],
      workStatus: [],
      relationships: [],
      loanReasons: [],
      cities: {},
      bankImages: {},
      paymentUrl: '',
      fees: FeesModel.empty(),
    );
  }

  bool get isEmpty =>
      banks.isEmpty &&
      heardFrom.isEmpty &&
      industry.isEmpty &&
      occupation.isEmpty &&
      states.isEmpty &&
      workStatus.isEmpty &&
      relationships.isEmpty &&
      cities.isEmpty &&
      fees.isEmpty &&
      paymentUrl.isEmpty &&
      bankImages.isEmpty;

  final List<BankModel> banks;
  final List<String> heardFrom;
  final List<String> industry;
  final List<String> occupation;
  final List<String> states;
  final List<String> workStatus;
  final List<String> relationships;
  final List<String> loanReasons;
  final Map<String, List<String>> cities;
  final Map<String, String> bankImages;
  final String paymentUrl;
  final FeesModel fees;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetUpData &&
          runtimeType == other.runtimeType &&
          banks == other.banks &&
          heardFrom == other.heardFrom &&
          industry == other.industry &&
          occupation == other.occupation &&
          states == other.states &&
          workStatus == other.workStatus &&
          relationships == other.relationships &&
          loanReasons == other.loanReasons &&
          cities == other.cities &&
          bankImages == other.bankImages &&
          paymentUrl == other.paymentUrl &&
          fees == other.fees;

  @override
  int get hashCode =>
      banks.hashCode ^
      heardFrom.hashCode ^
      industry.hashCode ^
      occupation.hashCode ^
      states.hashCode ^
      workStatus.hashCode ^
      relationships.hashCode ^
      loanReasons.hashCode ^
      cities.hashCode ^
      bankImages.hashCode ^
      paymentUrl.hashCode ^
      fees.hashCode;

  @override
  String toString() {
    return 'SetUpData{banks: $banks, heardFrom: $heardFrom, industry: $industry, occupation: $occupation, states: $states, workStatus: $workStatus, relationships: $relationships, loanReasons: $loanReasons, cities: $cities, bankImages: $bankImages, fees: $fees, paymentUrl: $paymentUrl}';
  }
}

Map<String, List<String>> mapCities(dynamic cities) {
  return List<dynamic>.from(cities).fold<Map<String, List<String>>>(
    <String, List<String>>{},
    (acc, dynamic cur) => acc..putIfAbsent(cur["name"], () => List<String>.from(cur["items"])),
  );
}

Map<String, String> mapBankImages(List<BankModel> banks) {
  return banks.fold<Map<String, String>>(
    <String, String>{},
    (acc, cur) => acc..putIfAbsent(cur.name, () => cur.imageUrl),
  );
}
