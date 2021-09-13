import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/signup/radio_switch_form_field.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

class PersonalDetailsFormView extends StatefulWidget {
  const PersonalDetailsFormView({
    Key key,
    @required this.request,
    @required this.onSaved,
    this.buttonCaption,
    this.user,
  }) : super(key: key);

  final PersonalInfoRequestData request;
  final ValueChanged<PersonalInfoRequestData> onSaved;
  final String buttonCaption;
  final UserModel user;

  @override
  _PersonalDetailsFormViewState createState() => _PersonalDetailsFormViewState();
}

class _PersonalDetailsFormViewState extends State<PersonalDetailsFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _surnameFocusNode = FocusNode();

  final genders = const ["Male", "Female"];
  final maritalStatus = const ["Single", "Married", "Divorced", "Widowed"];
  final educationLevels = const ["Primary", "Secondary", "University", "Post-Grad"];

  var _autovalidateMode = AutovalidateMode.disabled;
  final initialValues = PersonalInfoRequestData();

  @override
  void initState() {
    super.initState();

    final isDev = Registry.di.session.isDev;
    initialValues
      ..firstname = widget.user?.firstname ?? widget.request.firstname ?? (isDev ? "Jeremiah" : null)
      ..surname = widget.user?.surname ?? widget.request.surname ?? (isDev ? "Ogbomo" : null)
      ..dob = widget.user?.dob ?? widget.request.dob ?? (isDev ? "2000-10-10" : null)
      ..gender = widget.user?.gender ?? widget.request.gender
      ..maritalStatus = widget.user?.maritalStatus ?? widget.request.maritalStatus
      ..educationLevel = widget.user?.educationLevel ?? widget.request.educationLevel;
  }

  @override
  void dispose() {
    _surnameFocusNode.dispose();
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
          LabelHintWrapper(
            label: 'First Name',
            child: TextFormField(
              initialValue: initialValues.firstname,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "First Name"),
              validator: Validators.tryString(),
              readOnly: widget.user != null,
              enabled: widget.user == null,
              onSaved: (value) {
                widget.request.firstname = value;
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_surnameFocusNode),
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: 'Surname',
            child: TextFormField(
              initialValue: initialValues.surname,
              focusNode: _surnameFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(hintText: "Surname"),
              validator: Validators.tryString(),
              readOnly: widget.user != null,
              enabled: widget.user == null,
              onSaved: (value) {
                widget.request.surname = value;
              },
              onEditingComplete: () {},
            ),
          ),
          const ScaledBox.vertical(16),
          LabelHintWrapper(
            label: 'Date of Birth',
            child: DateFormField(
              initialValue: initialValues.dobAsDateTime,
              decoration: InputDecoration(
                hintText: "Date of Birth",
                suffixIcon: Icon(AppIcons.calendar),
              ),
              validator: Validators.tryDate(
                error: "You need to be at least 18 to continue",
                min: DateTime(clock.now().year - 18),
              ),
              enabled: widget.user?.dob == null,
              onSaved: (value) {
                widget.request.dob = "${value?.day}-${value?.month}-${value?.year}";
              },
            ),
          ),
          const ScaledBox.vertical(16),
          RadioSwitchFormField(
            label: Text("Gender"),
            initialValue: genders.getIndex(initialValues.gender, 1),
            titles: genders,
            enabled: widget.user?.gender == null,
            onSaved: (value) {
              widget.request.gender = genders[value];
            },
          ),
          const ScaledBox.vertical(16),
          RadioSwitchFormField(
            label: Text("Marital Status"),
            initialValue: maritalStatus.getIndex(initialValues.maritalStatus, 0),
            titles: maritalStatus,
            onSaved: (value) {
              widget.request.maritalStatus = maritalStatus[value];
            },
          ),
          const ScaledBox.vertical(16),
          RadioSwitchFormField(
            label: Text("Education"),
            initialValue: educationLevels.getIndex(initialValues.educationLevel, 0),
            titles: educationLevels,
            onSaved: (value) {
              widget.request.educationLevel = educationLevels[value];
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

extension on List<String> {
  int getIndex(String input, int orElse) {
    if (input == null || input.isEmpty) {
      return orElse;
    }
    final index = indexOf(input);
    return index >= 0 ? index : orElse;
  }
}
