import 'package:borome/domain.dart';
import 'package:borome/screens/loans/loan_request_routes.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("deriveLoanRequestRoutes", () {
    test("works as expected", () async {
      expect(
        deriveLoanRequestRoutes(null).names,
        orderedEquals([
          LoanRequestRoutes.contactInfo,
          LoanRequestRoutes.personalDetails,
          LoanRequestRoutes.workDetails,
          LoanRequestRoutes.nextOfKin,
          LoanRequestRoutes.profileImage,
          LoanRequestRoutes.workIdImage,
          LoanRequestRoutes.termsOfUse,
          LoanRequestRoutes.identityVerification,
        ].asIterable),
      );
      expect(
        deriveLoanRequestRoutes(_composeModel(false)).names,
        orderedEquals([
          LoanRequestRoutes.contactInfo,
          LoanRequestRoutes.personalDetails,
          LoanRequestRoutes.workDetails,
          LoanRequestRoutes.nextOfKin,
          LoanRequestRoutes.profileImage,
          LoanRequestRoutes.workIdImage,
          LoanRequestRoutes.termsOfUse,
          LoanRequestRoutes.identityVerification,
        ].asIterable),
      );
      expect(
        deriveLoanRequestRoutes(_composeModel(false, contactInformation: true)).names,
        orderedEquals([
          LoanRequestRoutes.personalDetails,
          LoanRequestRoutes.workDetails,
          LoanRequestRoutes.nextOfKin,
          LoanRequestRoutes.profileImage,
          LoanRequestRoutes.workIdImage,
          LoanRequestRoutes.termsOfUse,
          LoanRequestRoutes.identityVerification,
        ].asIterable),
      );
      expect(
        deriveLoanRequestRoutes(_composeModel(false, workId: true)).names,
        orderedEquals([
          LoanRequestRoutes.contactInfo,
          LoanRequestRoutes.personalDetails,
          LoanRequestRoutes.workDetails,
          LoanRequestRoutes.nextOfKin,
          LoanRequestRoutes.profileImage,
          LoanRequestRoutes.termsOfUse,
          LoanRequestRoutes.identityVerification,
        ].asIterable),
      );
      expect(
        deriveLoanRequestRoutes(_composeModel(false, contactInformation: true, personalInformation: true)).names,
        orderedEquals([
          LoanRequestRoutes.workDetails,
          LoanRequestRoutes.nextOfKin,
          LoanRequestRoutes.profileImage,
          LoanRequestRoutes.workIdImage,
          LoanRequestRoutes.termsOfUse,
          LoanRequestRoutes.identityVerification,
        ].asIterable),
      );
      expect(deriveLoanRequestRoutes(_composeModel(true)), isEmpty);
    });

    group("terms of use", () {
      test("hidden when both bank and payment is valid", () async {
        expect(
          deriveLoanRequestRoutes(_composeModel(
            true,
            contactInformation: false,
            bankAccount: true,
            paymentVerification: true,
          )).names,
          [LoanRequestRoutes.contactInfo],
        );
      });

      test("shown when either bank or payment or both is invalid", () async {
        expect(
          deriveLoanRequestRoutes(_composeModel(
            true,
            contactInformation: false,
            bankAccount: true,
            paymentVerification: false,
          )).names,
          orderedEquals([
            LoanRequestRoutes.contactInfo,
            LoanRequestRoutes.termsOfUse,
            LoanRequestRoutes.identityVerification,
          ].asIterable),
        );
        expect(
          deriveLoanRequestRoutes(_composeModel(
            true,
            contactInformation: false,
            bankAccount: false,
            paymentVerification: true,
          )).names,
          orderedEquals([
            LoanRequestRoutes.contactInfo,
            LoanRequestRoutes.termsOfUse,
            LoanRequestRoutes.identityVerification,
          ].asIterable),
        );
        expect(
          deriveLoanRequestRoutes(_composeModel(
            true,
            contactInformation: false,
            bankAccount: false,
            paymentVerification: false,
          )).names,
          orderedEquals([
            LoanRequestRoutes.contactInfo,
            LoanRequestRoutes.termsOfUse,
            LoanRequestRoutes.identityVerification,
          ].asIterable),
        );
      });
    });
  });
}

ProfileStatusModel _composeModel(
  bool defaultState, {
  bool contactInformation,
  bool personalInformation,
  bool workInformation,
  bool nokInformation,
  bool profileImage,
  bool workId,
  bool bankAccount,
  String bankAccountConnectionLink,
  bool paymentVerification,
  String paymentVerificationLink,
}) {
  return ProfileStatusModel(
    (b) => b
      ..workId = workId ?? defaultState
      ..profileImage = profileImage ?? defaultState
      ..nokInformation = nokInformation ?? defaultState
      ..workInformation = workInformation ?? defaultState
      ..contactInformation = contactInformation ?? defaultState
      ..personalInformation = personalInformation ?? defaultState
      ..bankAccount = bankAccount ?? defaultState
      ..bankAccountConnectionLink = bankAccountConnectionLink ?? '$defaultState'
      ..paymentVerification = paymentVerification ?? defaultState
      ..paymentVerificationLink = paymentVerificationLink ?? '$defaultState',
  );
}

extension on List<SimpleRoute> {
  Iterable get names {
    return Iterable.castFrom<String, dynamic>(map((item) => item.name));
  }
}

extension on List<String> {
  Iterable get asIterable {
    return Iterable.castFrom<String, dynamic>(this);
  }
}
