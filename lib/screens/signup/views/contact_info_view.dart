import 'dart:math';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class ContactInfoView extends StatefulWidget {
  const ContactInfoView({Key key}) : super(key: key);

  @override
  _ContactInfoViewState createState() => _ContactInfoViewState();
}

class _ContactInfoViewState extends State<ContactInfoView> with DismissKeyboardMixin {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ScaledBox.vertical(8),
          Text(
            "Register",
            style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.medium, color: AppColors.primary),
          ),
          const ScaledBox.vertical(16),
          Text(
            "Please fill the form below with correct information",
            style: theme.subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: .25),
          ),
          const ScaledBox.vertical(32),
          _ContactInfoFormView(
            onSaved: (value) => handleSubmit(value),
          )
        ],
      ),
    );
  }

  void handleSubmit(SignupRequestData request) async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      final pair = await Registry.di.repository.auth.signUp(request);
      Registry.di.session.setToken(pair.second);
      context.dispatchAction(UserActions.fetch());
      AppSnackBar.of(context).hide();
      await Navigator.of(context).pushNamed(context.signupService.nextPage);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}

class _ContactInfoFormView extends StatefulWidget {
  const _ContactInfoFormView({
    Key key,
    @required this.onSaved,
  }) : super(key: key);

  final ValueChanged<SignupRequestData> onSaved;

  @override
  __ContactInfoFormViewState createState() => __ContactInfoFormViewState();
}

class __ContactInfoFormViewState extends State<_ContactInfoFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<DropDownFormFieldState> cityFieldKey = GlobalKey<DropDownFormFieldState>();

  final FocusNode _surnameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  var _autovalidateMode = AutovalidateMode.disabled;

  SignupRequestData request;

  @override
  void initState() {
    super.initState();

    final isDev = Registry.di.session.isDev;
    request = SignupRequestData(deviceId: Registry.di.appDeviceInfo.deviceId)
      ..email = isDev ? "jeremiahogbomo${Random().nextInt(100)}@gmail.com" : null
      ..phone = isDev ? "070${Random().nextInt(9)}5${Random().nextInt(9)}7528${Random().nextInt(9)}" : null
      ..firstname = isDev ? "Taribo" : null
      ..surname = isDev ? "West" : null
      ..password = isDev ? "12345678" : null;
  }

  @override
  void dispose() {
    _surnameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: LabelHintWrapper(
                  label: "First Name",
                  child: TextFormField(
                    initialValue: request.firstname,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    validator: Validators.tryString(label: "First name"),
                    onSaved: (value) {
                      request.firstname = value;
                    },
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_surnameFocusNode),
                  ),
                ),
              ),
              const ScaledBox.horizontal(8),
              Expanded(
                child: LabelHintWrapper(
                  label: "Surname",
                  child: TextFormField(
                    initialValue: request.surname,
                    focusNode: _surnameFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    validator: Validators.tryString(label: "Surname"),
                    onSaved: (value) {
                      request.surname = value;
                    },
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
                  ),
                ),
              ),
            ],
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: "Phone Number",
            hint: "Your phone number should be valid and accessible as we would call you to verify your account.",
            child: TextFormField(
              initialValue: request.phone,
              focusNode: _phoneFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Eg: 08023456789"),
              validator: Validators.tryPhone(),
              onSaved: (value) {
                request.phone = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: "Email Address",
            hint: "Your email address should be valid and accessible as we would send an email to verify your account.",
            child: TextFormField(
              initialValue: request.email,
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Eg: addressname@mail.com"),
              validator: Validators.tryEmail(),
              onSaved: (value) {
                request.email = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: "Password",
            child: PasswordFormField(
              initialValue: request.password,
              textInputAction: TextInputAction.next,
              focusNode: _passwordFocusNode,
              validator: Validators.tryString(label: "Password"),
              onSaved: (value) {
                request.password = value;
              },
            ),
          ),
          const ScaledBox.vertical(28),
          FilledButton(onPressed: handleSubmit, child: Text("Next")),
          const ScaledBox.vertical(16),
        ],
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
    widget.onSaved(request);
  }
}
