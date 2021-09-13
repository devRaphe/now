import 'dart:math';

import 'package:borome/constants/app_icons.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:borome/widgets/form_views/extensions.dart';
import 'package:flutter/material.dart';

class ContactInfoFormView extends StatefulWidget {
  const ContactInfoFormView({
    Key key,
    @required this.request,
    @required this.onSaved,
    this.buttonCaption,
    this.user,
  }) : super(key: key);

  final ContactInfoRequestData request;
  final ValueChanged<ContactInfoRequestData> onSaved;
  final String buttonCaption;
  final UserModel user;

  @override
  _ContactInfoFormViewState createState() => _ContactInfoFormViewState();
}

class _ContactInfoFormViewState extends State<ContactInfoFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<DropDownFormFieldState> cityFieldKey = GlobalKey<DropDownFormFieldState>();

  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _homeFocusNode = FocusNode();
  final FocusNode _landmarkFocusNode = FocusNode();

  var _autovalidateMode = AutovalidateMode.disabled;
  final initialValues = ContactInfoRequestData();

  @override
  void initState() {
    super.initState();

    final isDev = Registry.di.session.isDev;
    initialValues
      ..email = widget.user?.email ??
          widget.request.email ??
          (isDev ? "jeremiahogbomo${Random().nextInt(100)}@gmail.com" : null)
      ..phone = widget.user?.phone ??
          widget.request.phone ??
          (isDev ? "070${Random().nextInt(9)}5${Random().nextInt(9)}7528${Random().nextInt(9)}" : null)
      ..address = widget.user?.address ?? widget.request.address ?? (isDev ? "Peace Estate, Gongola" : null)
      ..state = widget.user?.state ?? widget.request.state
      ..city = widget.user?.city ?? widget.request.city
      ..landmark = widget.user?.landmark ?? widget.request.landmark ?? (isDev ? "Under Bridge" : null);
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _homeFocusNode.dispose();
    _landmarkFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDev = Registry.di.session.isDev;

    return Form(
      key: formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LabelHintWrapper(
            label: "Email Address",
            hint: "Your email address should be valid and accessible as we would send an email to verify your account.",
            child: TextFormField(
              initialValue: initialValues.email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: "e.g addressname@mail.com",
                suffixIcon: widget.user != null ? Icon(AppIcons.padlock) : null,
              ),
              validator: Validators.tryEmail(),
              readOnly: widget.user != null,
              enabled: widget.user == null,
              onSaved: (value) {
                widget.request.email = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: "Phone Number",
            hint: "Your phone number should be valid and accessible as we would call you to verify your account.",
            child: TextFormField(
              initialValue: initialValues.phone,
              focusNode: _phoneFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: "08023456789",
                suffixIcon: widget.user != null ? Icon(AppIcons.padlock) : null,
              ),
              validator: Validators.tryPhone(),
              readOnly: widget.user != null,
              enabled: widget.user == null,
              onSaved: (value) {
                widget.request.phone = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: 'Home Address',
            child: TextFormField(
              initialValue: initialValues.address,
              focusNode: _homeFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Home Address"),
              validator: Validators.tryString(),
              onSaved: (value) {
                widget.request.address = value;
              },
            ),
          ),
          const ScaledBox.vertical(16),
          StreamBuilder<SubState<SetUpData>>(
            initialData: context.store.state.value.setup,
            stream: context.store.state.map((state) => state.setup),
            builder: (context, snapshot) {
              final states = snapshot.data.map((data) => data.states.toList(), orElse: () => <String>[]);
              final selectedState = widget.request.state ?? initialValues.state ?? (isDev ? states.firstOrEmpty : null);
              final cities = snapshot.data.map(
                (data) => data.cities[selectedState]?.toList() ?? [],
                orElse: () => <String>[],
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  LabelHintWrapper(
                    label: 'State',
                    child: DropDownFormField(
                      initialValue: selectedState,
                      items: states,
                      decoration: const InputDecoration(hintText: "State"),
                      validator: Validators.tryString(),
                      onChanged: (value) {
                        setState(() {
                          widget.request.state = value;
                          widget.request.city = null;
                          cityFieldKey.currentState.clear();
                        });
                      },
                      onSaved: (value) {
                        widget.request.state = value;
                      },
                    ),
                  ),
                  const ScaledBox.vertical(16),
                  LabelHintWrapper(
                    label: 'City',
                    child: DropDownFormField(
                      key: cityFieldKey,
                      initialValue: widget.request.city ?? initialValues.city ?? (isDev ? cities.firstOrEmpty : null),
                      items: cities,
                      decoration: const InputDecoration(hintText: "City"),
                      validator: Validators.tryString(),
                      onSaved: (value) {
                        widget.request.city = value;
                      },
                      onChanged: (_) => FocusScope.of(context).requestFocus(_landmarkFocusNode),
                    ),
                  )
                ],
              );
            },
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: "Landmark / Description",
            hint:
                "This includes anything that is easily recognizable, such as a monument, building, or any other structure.",
            child: TextFormField(
              focusNode: _landmarkFocusNode,
              initialValue: initialValues.landmark,
              textInputAction: TextInputAction.done,
              minLines: null,
              maxLines: 6,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Landmark"),
              validator: Validators.tryString(),
              onSaved: (value) {
                widget.request.landmark = value;
              },
              onEditingComplete: handleSubmit,
            ),
          ),
          const ScaledBox.vertical(28),
          FilledButton(
            onPressed: handleSubmit,
            child: Text(widget.buttonCaption ?? "Next"),
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
