import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:borome/widgets/form_views/extensions.dart';
import 'package:flutter/material.dart';

class NextOfKinFormView extends StatefulWidget {
  const NextOfKinFormView({
    Key key,
    @required this.request,
    @required this.onSaved,
    this.buttonCaption,
    this.user,
  }) : super(key: key);

  final NextOfKinRequestData request;
  final ValueChanged<NextOfKinRequestData> onSaved;
  final String buttonCaption;
  final UserModel user;

  @override
  _NextOfKinFormViewState createState() => _NextOfKinFormViewState();
}

class _NextOfKinFormViewState extends State<NextOfKinFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  var _autovalidateMode = AutovalidateMode.disabled;
  final initialValues = NextOfKinRequestData();

  @override
  void initState() {
    super.initState();

    final isDev = Registry.di.session.isDev;
    initialValues
      ..guarantorName = widget.user?.guarantorName ?? widget.request.guarantorName ?? (isDev ? "Jeremiah Ogbomo" : null)
      ..guarantorPhone = widget.user?.guarantorPhone ?? widget.request.guarantorPhone ?? (isDev ? "08098445367" : null)
      ..guarantorEmail =
          widget.user?.guarantorEmail ?? widget.request.guarantorEmail ?? (isDev ? "jeremiahogbomo@gmail.com" : null)
      ..guarantorRelationship = widget.user?.guarantorRelationship ?? widget.request.guarantorRelationship;
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
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
            label: 'Full Name',
            child: TextFormField(
              initialValue: initialValues.guarantorName,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Full Name"),
              validator: Validators.tryString(),
              onSaved: (value) {
                widget.request.guarantorName = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: 'Phone Number',
            child: TextFormField(
              initialValue: initialValues.guarantorPhone,
              focusNode: _phoneFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Phone Number"),
              validator: Validators.tryPhone(),
              onSaved: (value) {
                widget.request.guarantorPhone = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: 'Email Address',
            child: TextFormField(
              initialValue: initialValues.guarantorEmail,
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Email Address"),
              onSaved: (value) {
                widget.request.guarantorEmail = value;
              },
              onEditingComplete: () {},
            ),
          ),
          const ScaledBox.vertical(16),
          StreamBuilder<SubState<SetUpData>>(
            initialData: context.store.state.value.setup,
            stream: context.store.state.map((state) => state.setup),
            builder: (context, snapshot) {
              final relationships = snapshot.data.map(
                (data) => data.relationships.toList(),
                orElse: () => <String>[],
              );
              return LabelHintWrapper(
                label: 'Relationship',
                child: DropDownFormField(
                  initialValue: initialValues.guarantorRelationship ?? (isDev ? relationships.firstOrEmpty : null),
                  items: relationships,
                  decoration: const InputDecoration(hintText: "Relationship"),
                  validator: Validators.tryString(),
                  onSaved: (value) {
                    widget.request.guarantorRelationship = value;
                  },
                ),
              );
            },
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
