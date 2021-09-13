import 'package:borome/constants.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PhoneVerificationView extends StatefulWidget {
  const PhoneVerificationView({Key key}) : super(key: key);

  @override
  _PhoneVerificationViewState createState() => _PhoneVerificationViewState();
}

class _PhoneVerificationViewState extends State<PhoneVerificationView> with DismissKeyboardMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool canRetry = false;
  bool hasRetried = false;
  final pinTextLength = 6;
  final pinTextValue = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return UserModelStreamBuilder(
      builder: (context, data) => Stack(
        children: <Widget>[
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const ScaledBox.vertical(8),
                Text(
                  "Phone Verification",
                  style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.medium, color: AppColors.primary),
                ),
                const ScaledBox.vertical(16),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 350),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hasRetried
                          ? "We sent another\ncode to you."
                          : "Please enter the 6-digit code sent to the phone number you provided",
                      key: ValueKey<bool>(hasRetried),
                      style: theme.subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: .25),
                    ),
                  ),
                ),
                const ScaledBox.vertical(32),
                ValueListenableBuilder<String>(
                  valueListenable: pinTextValue,
                  builder: (context, value, child) => PinEntryFormField(
                    initialValue: value,
                    length: pinTextLength,
                    onFinished: (code) => handleValidation(data.phone, code, data.firstname),
                  ),
                ),
                const ScaledBox.vertical(16),
                if (!canRetry)
                  Center(
                    child: CountDownTimer(onEnd: () => setState(() => canRetry = true)),
                  )
                else
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
                const ScaledBox.vertical(16),
                Flexible(
                  child: KeypadGridView(
                    controller: pinTextValue,
                    maxLength: pinTextLength,
                  ),
                ),
                const ScaledBox.vertical(16),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: _ChatButton(visibility: hasRetried, phone: data.phone, email: data.email),
          ),
        ],
      ),
      orElse: (context) => Center(child: LoadingSpinner.circle()),
      error: (context, message) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          TextButton(
            child: Text("RETRY"),
            onPressed: () => context.dispatchAction(UserActions.fetch()),
          )
        ],
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
      AppLog.e(e, st, message: <String, String>{
        "session.token": Registry.di.session.token.value,
      });
      AppSnackBar.of(context).error(errorToString(e));
    }
  }

  void handleValidation(String phone, String code, String firstname) async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      await Registry.di.repository.auth.confirmPhone(code);
      if (!mounted) {
        return;
      }

      AppSnackBar.of(context).hide();
      showSuccessDialog(
        context,
        title: "Welcome, $firstname",
        caption: AppStrings.signupSuccessMessage,
        onDismiss: () => Registry.di.coordinator.shared.toStart(pristine: true, clearHistory: true),
      );
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}

class _ChatButton extends StatelessWidget {
  const _ChatButton({
    Key key,
    @required this.visibility,
    @required this.email,
    @required this.phone,
  }) : super(key: key);

  final bool visibility;
  final String phone;
  final String email;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      duration: Duration(milliseconds: 350),
      child: visibility
          ? FloatingActionButton(
              child: Icon(Icons.insert_comment),
              onPressed: () => showSupportDialog(context, email: email, phone: phone),
            )
          : SizedBox(),
    );
  }
}
