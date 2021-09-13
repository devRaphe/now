import 'package:borome/constants.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VerifyForgotPasswordPage extends StatefulWidget {
  const VerifyForgotPasswordPage({Key key, @required this.phone}) : super(key: key);

  final String phone;

  @override
  _VerifyForgotPasswordPageState createState() => _VerifyForgotPasswordPageState();
}

class _VerifyForgotPasswordPageState extends State<VerifyForgotPasswordPage> with DismissKeyboardMixin {
  bool canRetry = false;
  bool hasRetried = false;

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
              AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hasRetried ? "We sent another\ncode to you." : "Enter the code\nsent to your mail",
                    key: ValueKey<bool>(hasRetried),
                    style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
                  ),
                ),
              ),
              if (hasRetried) ...[
                const ScaledBox.vertical(56),
                Text(
                  "BE SURE TO CHECK EVEN\nYOUR SPAM FOLDER",
                  style: theme.subhead3Semi.copyWith(height: 1.24, letterSpacing: 1.5),
                ),
              ],
              const ScaledBox.vertical(56),
              PinEntryFormField(length: 6, onFinished: handleValidation),
              const ScaledBox.vertical(28),
              if (!canRetry)
                Center(
                  child: CountDownTimer(onEnd: () => setState(() => canRetry = true)),
                ),
              if (canRetry && !hasRetried)
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't get a code?  ",
                      children: [
                        TextSpan(
                          text: "Click Here",
                          style: theme.bodyMedium.copyWith(color: AppColors.primary),
                          recognizer: TapGestureRecognizer()..onTap = resendCode,
                        ),
                      ],
                      style: theme.body1,
                    ),
                  ),
                ),
              const ScaledBox.vertical(28),
            ],
          ),
        ),
      ),
    );
  }

  void resendCode() async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      await Registry.di.repository.auth.resendPhoneCode();
      if (mounted) {
        setState(() => hasRetried = true);
        AppSnackBar.of(context).hide();
      }
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }

  void handleValidation(String code) async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      await Registry.di.repository.auth.confirmPhoneCode(widget.phone, code);
      AppSnackBar.of(context).hide();
      Registry.di.coordinator.auth.toChangePassword(phone: widget.phone, code: code);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
