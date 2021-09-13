import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ProfileChangePasswordPage extends StatefulWidget {
  @override
  _ProfileChangePasswordPageState createState() => _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState extends State<ProfileChangePasswordPage> with DismissKeyboardMixin {
  PasswordRequestData passwordRequestData;

  @override
  void initState() {
    super.initState();

    passwordRequestData = PasswordRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: Text("Change Password"), primary: true),
          SliverPadding(
            padding: const EdgeInsets.all(24).scale(context),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ChangePasswordFormView(
                  request: passwordRequestData,
                  updateAction: true,
                  onSaved: handleSubmit,
                  buttonCaption: "Save",
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  void handleSubmit(PasswordRequestData request) async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      final message = await Registry.di.repository.auth.changePassword(request);
      AppSnackBar.of(context).success(message);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
