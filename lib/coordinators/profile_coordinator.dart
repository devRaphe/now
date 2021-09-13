import 'package:borome/route_transition.dart';
import 'package:borome/screens.dart';
import 'package:flutter/widgets.dart';

import 'coordinator_base.dart';

@immutable
class ProfileCoordinator extends CoordinatorBase {
  const ProfileCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toProfile() => navigator?.push(RouteTransition.slideIn(ProfilePage()));

  void toPersonalInformation() => navigator?.push(RouteTransition.slideIn(PersonalInformationPage()));

  void toProfilePhoto() => navigator?.push(RouteTransition.slideIn(ProfilePhotoPage()));

  void toWorkId() => navigator?.push(RouteTransition.slideIn(WorkIdPage()));

  void toContactInformation() => navigator?.push(RouteTransition.slideIn(ContactInformationPage()));

  void toChangePassword() => navigator?.push(RouteTransition.slideIn(ProfileChangePasswordPage()));

  void toMyBank() => navigator?.push(RouteTransition.slideIn(MyBankPage()));

  void toMyFiles() => navigator?.push(RouteTransition.slideIn(MyFilesPage()));

  void toFileGroup(String name) => navigator?.push(RouteTransition.slideIn(FileGroupDetailsPage(name: name)));

  void toAddFile({bool isRequested = false}) =>
      navigator?.push(RouteTransition.slideIn(AddFilePage(isRequested: isRequested)));

  void toWorkDetails() => navigator?.push(RouteTransition.slideIn(WorkDetailsPage()));

  void toNextOfKin() => navigator?.push(RouteTransition.slideIn(NextOfKinPage()));
}
