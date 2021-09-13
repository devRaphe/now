import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordFormView extends StatefulWidget {
  const ChangePasswordFormView({
    Key key,
    @required this.request,
    @required this.onSaved,
    this.buttonCaption,
    this.updateAction = false,
  }) : super(key: key);

  final PasswordRequestData request;
  final ValueChanged<PasswordRequestData> onSaved;
  final String buttonCaption;
  final bool updateAction;

  @override
  _ChangePasswordFormViewState createState() => _ChangePasswordFormViewState();
}

class _ChangePasswordFormViewState extends State<ChangePasswordFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final passwordField = GlobalKey<FormFieldState<String>>();

  var _autovalidateMode = AutovalidateMode.disabled;
  final initialValues = PasswordRequestData();

  @override
  void initState() {
    super.initState();

    final isDev = Registry.di.session.isDev;
    initialValues..password = widget.updateAction ? null : widget.request.password ?? (isDev ? "password" : null);
  }

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();
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
          if (widget.updateAction) ...[
            PasswordFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Previous Password",
                prefixIcon: Icon(AppIcons.padlock),
              ),
              validator: Validators.tryString(),
              onSaved: (value) {
                widget.request.oldPassword = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_newPasswordFocusNode),
            ),
            const ScaledBox.vertical(16),
          ],
          PasswordFormField(
            key: passwordField,
            initialValue: initialValues.password,
            focusNode: _newPasswordFocusNode,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(AppIcons.padlock),
            ),
            validator: Validators.tryPassword(),
            onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
          ),
          const ScaledBox.vertical(16),
          PasswordFormField(
            initialValue: initialValues.password,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: "Retype Password",
              prefixIcon: Icon(AppIcons.padlock),
            ),
            validator: (value) => Validators.tryDiffPassword(passwordField.currentState)(value),
            onSaved: (value) {
              widget.request.password = value;
            },
            onEditingComplete: handleSubmit,
          ),
          const ScaledBox.vertical(28),
          FilledButton(
            onPressed: handleSubmit,
            child: Text(widget.buttonCaption ?? "Reset Password"),
          ),
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
    widget.onSaved(widget.request);
  }
}
