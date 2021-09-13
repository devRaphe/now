import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with DismissKeyboardMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();

  var _autovalidateMode = AutovalidateMode.disabled;
  final LoginRequestData loginRequestData = LoginRequestData(deviceId: Registry.di.appDeviceInfo.deviceId);

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
                  "Welcome back",
                  style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
                ),
                const ScaledBox.vertical(35),
                Text(
                  "LOGIN TO\nCONTINUE",
                  style: theme.subhead3Semi.copyWith(height: 1.24, letterSpacing: 1.5),
                ),
                const ScaledBox.vertical(56),
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    prefixIcon: Icon(AppIcons.smartphone),
                  ),
                  initialValue: Registry.di.session.isDev ? "08169226213" : "",
                  validator: Validators.tryPhone(),
                  onSaved: (value) {
                    loginRequestData.phone = value;
                  },
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),
                const ScaledBox.vertical(16),
                PasswordFormField(
                  initialValue: Registry.di.session.isDev ? "12345678" : "",
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(AppIcons.padlock),
                  ),
                  validator: Validators.tryLength(),
                  onSaved: (value) {
                    loginRequestData.password = value;
                  },
                  onEditingComplete: handleSubmit,
                ),
                const ScaledBox.vertical(20),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      text: "Forgot Password?",
                      style: theme.body1,
                      recognizer: TapGestureRecognizer()..onTap = () => Registry.di.coordinator.auth.toForgotPassword(),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const ScaledBox.vertical(28),
                StreamBuilder<SubState<UserModel>>(
                  initialData: SubState.withEmpty(),
                  stream: context.store.state.map((state) => state.user),
                  builder: (context, snapshot) {
                    Widget child = Text("Login");

                    if (snapshot.data.loading) {
                      child = LoadingSpinner.circle(color: Colors.white);
                    } else if (!snapshot.data.hasError && snapshot.data.hasData) {
                      child = Icon(Icons.check, size: 44, color: Colors.white);
                    }

                    return FilledButton(
                      onPressed: snapshot.data.loading ? () {} : handleSubmit,
                      child: child,
                    );
                  },
                ),
                const ScaledBox.vertical(16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account?  ",
                      children: [
                        TextSpan(
                          text: "Register Now",
                          style: theme.bodyMedium.copyWith(color: AppColors.primary),
                          recognizer: TapGestureRecognizer()..onTap = () => Registry.di.coordinator.auth.toSignup(),
                        ),
                      ],
                      style: theme.body1,
                    ),
                  ),
                ),
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

    if (!loginRequestData.isValid) {
      return;
    }

    closeKeyboard();

    await loginAction(context: context, request: loginRequestData);
  }
}
