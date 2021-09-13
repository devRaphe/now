import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    Key key,
    @required this.phone,
    @required this.code,
  }) : super(key: key);

  final String phone;
  final String code;

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> with DismissKeyboardMixin {
  PasswordRequestData passwordRequestData;

  @override
  void initState() {
    super.initState();

    passwordRequestData = PasswordRequestData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      appBar: ClearAppBar(),
      body: KeyboardDismissible(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ScaledBox.vertical(40),
              const Align(alignment: Alignment.centerLeft, child: AppIcon()),
              const ScaledBox.vertical(38),
              Text(
                "Pick something\nyou’ll remember\nthis time",
                style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
              ),
              const ScaledBox.vertical(56),
              ChangePasswordFormView(
                request: passwordRequestData,
                onSaved: handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSubmit(PasswordRequestData request) async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      final message = await Registry.di.repository.auth.completeForgotPassword(
        PasswordResetData(phone: widget.phone, code: widget.code, password: request.password),
      );
      await AppSnackBar.of(context).success(message);
      Registry.di.coordinator.shared.toStart(pristine: false);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
