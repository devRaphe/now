import 'package:borome/coordinators.dart';
import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:borome/screens/loans/loan_request_routes.dart';
import 'package:borome/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_app_state.dart';
import '../make_app.dart';
import '../services/permissions_test.dart';
import 'test_coordinator.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loanModel = LoanModel.fromJson(await jsonReader("loan_success", Duration.zero));
  final loanDetailsModel = await LoanMockImpl().getDetails("ref");
  final rateData = RateData(maxDurationDays: 90, maxRate: 20000, minDurationDays: 10, minRate: 400);

  group("LoanCoordinator", () {
    final navigatorKey = GlobalKey<NavigatorState>();
    final coo = LoanCoordinator(navigatorKey);
    Registry registry;

    setUpAll(() async {
      registry = await setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    group("can navigate to uploading", () {
      testWidgets("and continues to offer when successful", (tester) async {
        toggleRequestPermission(registry.permissions.handler, allPermissionsGranted);
        when(registry.repository.auth.saveUploadData(any)).thenAnswer((_) async => rateData);

        await testCoordinator<LoanCoordinator, LoanOfferPage>(
          tester,
          coo,
          navigatorKey,
          (c) => c.toUploading(),
          initialState: fakeAppState(),
        );
      });

      testWidgets("pops out of uploading when not successful", (tester) async {
        toggleRequestPermission(registry.permissions.handler, onePermissionGranted);
        when(registry.repository.auth.saveUploadData(any)).thenAnswer((_) async => rateData);

        await testCoordinator<LoanCoordinator, UploadingPage>(
          tester,
          coo,
          navigatorKey,
          (c) => c.toUploading(),
          initialState: fakeAppState(),
          onVerify: (obs, _) => verify(obs.didPop(any, any)),
        );
      });
    });

    testWidgets("can navigate to request", (tester) async {
      await testCoordinator<LoanCoordinator, LoanRequestPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toRequest(routes: [SimpleRoute(LoanRequestRoutes.personalDetails)]),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to offer", (tester) async {
      await testCoordinator<LoanCoordinator, LoanOfferPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toOffer(rate: rateData),
      );
    });

    testWidgets("can navigate to status", (tester) async {
      await testCoordinator<LoanCoordinator, LoanStatusPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toStatus(true, ""),
      );
    });

    testWidgets("can navigate to summary", (tester) async {
      await testCoordinator<LoanCoordinator, LoanSummaryPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toSummary(
          request: LoanRequestData(),
          summary: LoanSummaryData(duration: 0, monthlyInterest: "", monthlyPayment: "", principal: ""),
          skippedOfferStep: false,
        ),
      );
    });

    testWidgets("can navigate to details", (tester) async {
      when(registry.repository.loan.getDetails(any)).thenAnswer((_) async => loanDetailsModel);
      await testCoordinator<LoanCoordinator, LoanDetailsPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toDetails(loan: loanModel),
        initialState: fakeAppState(),
      );
    });
  });
}
