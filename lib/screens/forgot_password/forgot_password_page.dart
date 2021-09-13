import 'package:borome/constants.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with DismissKeyboardMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _autovalidateMode = AutovalidateMode.disabled;
  String _phone;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      appBar: ClearAppBar(),
      body: KeyboardDismissible(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const ScaledBox.vertical(40),
                const Align(alignment: Alignment.centerLeft, child: AppIcon()),
                const ScaledBox.vertical(38),
                Text(
                  "So you forgot\nyour password...",
                  style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
                ),
                const ScaledBox.vertical(56),
                TextFormField(
                  autofocus: true,
                  initialValue: Registry.di.session.isDev ? "08081234504" : "",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    prefixIcon: Icon(Icons.phone_iphone),
                  ),
                  validator: Validators.tryPhone(),
                  onSaved: (value) => _phone = value,
                  onEditingComplete: handleSubmit,
                ),
                const ScaledBox.vertical(28),
                FilledButton(
                  onPressed: handleSubmit,
                  child: Text("Recover Password"),
                ),
                const ScaledBox.vertical(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSubmit() async {
    final FormState form = formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate() && !Registry.di.session.isMock) {
      _autovalidateMode = AutovalidateMode.always;
      return;
    }

    form.save();
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      await Registry.di.repository.auth.startForgotPassword(_phone);
      AppSnackBar.of(context).hide();
      Registry.di.coordinator.auth.toVerifyForgotPassword(phone: _phone);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
