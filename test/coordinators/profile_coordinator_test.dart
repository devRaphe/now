import 'package:borome/coordinators.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_app_state.dart';
import '../make_app.dart';
import 'test_coordinator.dart';

void main() {
  group("ProfileCoordinator", () {
    final navigatorKey = GlobalKey<NavigatorState>();
    final coo = ProfileCoordinator(navigatorKey);

    setUpAll(() {
      setupRegistry(navigatorKey: navigatorKey);
    });

    tearDownAll(() {
      Registry.di.dispose();
    });

    testWidgets("can navigate to profile", (tester) async {
      await testCoordinator<ProfileCoordinator, ProfilePage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toProfile(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to personal information", (tester) async {
      await testCoordinator<ProfileCoordinator, PersonalInformationPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toPersonalInformation(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to profile photo", (tester) async {
      await testCoordinator<ProfileCoordinator, ProfilePhotoPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toProfilePhoto(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to work id", (tester) async {
      await testCoordinator<ProfileCoordinator, WorkIdPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toWorkId(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to contact information", (tester) async {
      await testCoordinator<ProfileCoordinator, ContactInformationPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toContactInformation(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to change password", (tester) async {
      await testCoordinator<ProfileCoordinator, ProfileChangePasswordPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toChangePassword(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to my bank", (tester) async {
      await testCoordinator<ProfileCoordinator, MyBankPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toMyBank(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to my files", (tester) async {
      await testCoordinator<ProfileCoordinator, MyFilesPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toMyFiles(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to file group", (tester) async {
      final appState = fakeAppState();
      await testCoordinator<ProfileCoordinator, FileGroupDetailsPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toFileGroup(appState.user.value.files.first.name),
        initialState: appState,
      );
    });

    testWidgets("can navigate to add file", (tester) async {
      await testCoordinator<ProfileCoordinator, AddFilePage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toAddFile(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to work details", (tester) async {
      await testCoordinator<ProfileCoordinator, WorkDetailsPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toWorkDetails(),
        initialState: fakeAppState(),
      );
    });

    testWidgets("can navigate to next of kin", (tester) async {
      await testCoordinator<ProfileCoordinator, NextOfKinPage>(
        tester,
        coo,
        navigatorKey,
        (c) => c.toNextOfKin(),
        initialState: fakeAppState(),
      );
    });
  });
}
