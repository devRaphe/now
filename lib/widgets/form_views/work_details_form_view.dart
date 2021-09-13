import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:borome/widgets/form_views/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkDetailsFormView extends StatefulWidget {
  const WorkDetailsFormView({
    Key key,
    @required this.request,
    @required this.onSaved,
    this.buttonCaption,
    this.user,
  }) : super(key: key);

  final WorkDetailsRequestData request;
  final ValueChanged<WorkDetailsRequestData> onSaved;
  final String buttonCaption;
  final UserModel user;

  @override
  _WorkDetailsFormViewState createState() => _WorkDetailsFormViewState();
}

class _WorkDetailsFormViewState extends State<WorkDetailsFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  var _autovalidateMode = AutovalidateMode.disabled;
  final initialValues = WorkDetailsRequestData();

  @override
  void initState() {
    super.initState();

    final isDev = Registry.di.session.isDev;
    initialValues
      ..workStatus = widget.user?.workStatus ?? widget.request.workStatus
      ..industry = widget.user?.industry ?? widget.request.industry
      ..occupation = widget.user?.occupation ?? widget.request.occupation
      ..companyName = widget.user?.companyName ?? widget.request.companyName ?? (isDev ? "Jeremiah Inc." : null)
      ..companyPhone = widget.user?.companyPhone ?? widget.request.companyPhone ?? (isDev ? "07065175234" : null)
      ..companyAddress =
          widget.user?.companyAddress ?? widget.request.companyAddress ?? (isDev ? "Lebanon drive, Abuja" : null)
      ..payday = widget.user?.payday ?? widget.request.payday
      ..monthlyIncome = widget.user?.monthlyIncome ?? widget.request.monthlyIncome ?? (isDev ? "320450" : null);
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDev = Registry.di.session.isDev;

    return StreamBuilder<SetUpData>(
        initialData: context.store.state.value.setup.value,
        stream: context.store.state.map((state) => state.setup.value),
        builder: (context, snapshot) {
          final data = snapshot.data;

          return Form(
            key: formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LabelHintWrapper(
                  label: 'Work Status',
                  child: DropDownFormField(
                    initialValue: initialValues.workStatus ?? (isDev ? data.workStatus.firstOrEmpty : null),
                    decoration: const InputDecoration(hintText: "Work Status"),
                    validator: Validators.tryString(),
                    onSaved: (value) {
                      widget.request.workStatus = value;
                    },
                    items: data.workStatus,
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Industry',
                  child: DropDownFormField(
                    initialValue: initialValues.industry ?? (isDev ? data.industry.firstOrEmpty : null),
                    decoration: const InputDecoration(hintText: "Industry"),
                    validator: Validators.tryString(),
                    onSaved: (value) {
                      widget.request.industry = value;
                    },
                    items: data.industry,
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Occupation',
                  child: DropDownFormField(
                    initialValue: initialValues.occupation ?? (isDev ? data.occupation.firstOrEmpty : null),
                    decoration: const InputDecoration(hintText: "Occupation"),
                    validator: Validators.tryString(),
                    onSaved: (value) {
                      widget.request.occupation = value;
                    },
                    items: data.occupation,
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Employer / Business Name',
                  child: TextFormField(
                    initialValue: initialValues.companyName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(hintText: "Eg: ABC Nigeria Limited"),
                    validator: Validators.tryString(),
                    onSaved: (value) {
                      widget.request.companyName = value;
                    },
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Employer / Business Phone Number',
                  child: TextFormField(
                    initialValue: initialValues.companyPhone,
                    focusNode: _phoneFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(hintText: "Eg: 0801 234 5678"),
                    validator: Validators.tryPhone(),
                    onSaved: (value) {
                      widget.request.companyPhone = value;
                    },
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_addressFocusNode),
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Employer / Business Address',
                  child: TextFormField(
                    initialValue: initialValues.companyAddress,
                    focusNode: _addressFocusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(hintText: "Employer / Business Address"),
                    validator: Validators.tryString(),
                    onSaved: (value) {
                      widget.request.companyAddress = value;
                    },
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: "Pay day",
                  hint:
                      "Pay day is the date your salary mostly gets paid on. If you are a business owner, enter the day of the month that you take the profits from your business.",
                  child: DateFormField(
                    initialValue: initialValues.paydayAsDateTime,
                    decoration: const InputDecoration(hintText: "25th"),
                    validator: Validators.tryDate(),
                    valueBuilder: (value) {
                      final day = value.day;
                      final pos = (day == 1 || day == 21 || day == 31)
                          ? "'st'"
                          : (day == 2 || day == 22)
                              ? "'nd'"
                              : (day == 3 || day == 23)
                                  ? "'rd'"
                                  : "'th'";
                      return DateFormat("d$pos").format(value);
                    },
                    onSaved: (value) {
                      widget.request.payday = value?.day?.toString();
                    },
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Resumption Date',
                  child: DateFormField(
                    initialValue: initialValues.resumptionDateAsDateTime,
                    decoration: InputDecoration(
                      hintText: "Resumption Date",
                      suffixIcon: Icon(AppIcons.calendar),
                    ),
                    onSaved: (value) {
                      widget.request.resumptionDate = "${value?.day}-${value?.month}-${value?.year}";
                    },
                  ),
                ),
                const ScaledBox.vertical(16),
                LabelHintWrapper(
                  label: 'Monthly Income',
                  child: TextFormField(
                    initialValue: initialValues.monthlyIncome,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(hintText: "Monthly Income"),
                    validator: Validators.tryAmount(),
                    onSaved: (value) {
                      widget.request.monthlyIncome = value;
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
        });
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
