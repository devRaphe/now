import 'dart:ui';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/loans/slider_widget.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

const purpleColor = Color(0xFF543A4C);

class LoanOfferPage extends StatefulWidget {
  const LoanOfferPage({
    Key key,
    @required this.rate,
  }) : super(key: key);

  final RateData rate;

  @override
  _LoanOfferPageState createState() => _LoanOfferPageState();
}

class _LoanOfferPageState extends State<LoanOfferPage> with DismissKeyboardMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  LoanRequestData loanRequestData;

  @override
  void initState() {
    super.initState();

    loanRequestData = LoanRequestData();
  }

  Pair<double, double> get amountLimits {
    return Pair(widget.rate.minRate, widget.rate.maxRate);
  }

  static int deriveAmountSteps(double min, double max) {
    final diff = max - min;
    if (diff >= 150000) {
      return 10000;
    }
    if (diff >= 50000) {
      return 5000;
    }
    if (diff >= 20000) {
      return 1000;
    }
    return 500;
  }

  @override
  Widget build(BuildContext context) {
    final style =
        ThemeProvider.of(context).subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: 1.25);

    return AppScaffold(
      appBar: ClearAppBar(
        onPop: () {
          if (Navigator.canPop(context)) {
            Navigator.maybePop(context);
          } else {
            Registry.di.coordinator.shared.toDashboard();
          }
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ScaledBox.vertical(16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Congratulations!\n"),
                    TextSpan(text: "You can access "),
                    TextSpan(
                      text: Money(widget.rate.maxRate).formatted,
                      style: style.copyWith(color: purpleColor),
                    ),
                  ],
                ),
                style: style,
              ),
              const ScaledBox.vertical(64),
              _SliderFormField(
                key: UniqueKey(),
                title: "How much would you like to Borrow?",
                valueBuilder: (value) => Money(value).formatted,
                labelBuilder: (value) => Money(value, min: 1000).formatted,
                steps: deriveAmountSteps(amountLimits.first, amountLimits.second),
                limits: amountLimits,
                validator: (value) => Validators.tryNumberAmount(value),
                onSaved: (value) {
                  loanRequestData.amount = value;
                },
              ),
              const ScaledBox.vertical(72),
              _SliderFormField(
                key: UniqueKey(),
                title: "Over how many days?",
                valueBuilder: (value) => "${value.toStringAsFixed(0)} days",
                labelBuilder: (value) => "${value.round()}",
                steps: 1,
                limits: Pair(widget.rate.minDurationDays.toDouble(), widget.rate.maxDurationDays.toDouble()),
                validator: (value) => Validators.tryDouble()(value.toString()),
                onSaved: (value) {
                  loanRequestData.duration = value.toInt();
                },
              ),
              const ScaledBox.vertical(32),
              StreamBuilder<SubState<SetUpData>>(
                initialData: context.store.state.value.setup,
                stream: context.store.state.map((state) => state.setup),
                builder: (context, snapshot) {
                  final List<String> items = snapshot.data.map((data) => data.loanReasons, orElse: () => const []);
                  return DropDownFormField(
                    items: items,
                    decoration: const InputDecoration(hintText: "Reason for loan"),
                    validator: Validators.tryString(),
                    onSaved: (value) {
                      loanRequestData.reason = value;
                    },
                  );
                },
              ),
              const ScaledBox.vertical(24),
              StreamBuilder<SubState<UserModel>>(
                initialData: context.store.state.value.user,
                stream: context.store.state.map((state) => state.user),
                builder: (context, snapshot) {
                  final List<AccountModel> accounts = snapshot.data.map(
                    (data) => data.accounts.asList(),
                    orElse: () => const [],
                  );

                  return DropDownFormField(
                    items: accounts.map((item) => item.id.toString()).toList(),
                    decoration: const InputDecoration(hintText: "Bank Account"),
                    validator: Validators.tryString(),
                    valueBuilder: (id) {
                      final item = accounts.findById(int.parse(id));
                      return "${item.accountBank} - ${item.accountNumber}";
                    },
                    onSaved: (id) {
                      loanRequestData.accountid = int.tryParse(id ?? "");
                    },
                  );
                },
              ),
              const ScaledBox.vertical(32),
              FilledButton(
                child: Text("Next"),
                onPressed: handleSubmit,
              ),
              const ScaledBox.vertical(16),
            ],
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

    final registry = Registry.di;
    if (!form.validate() && !registry.session.isMock) {
      _autovalidateMode = AutovalidateMode.always;
      return;
    }

    form.save();

    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      final summary = await registry.repository.loan.checkSummary(
        loanRequestData.amount,
        loanRequestData.duration,
      );
      if (!mounted) {
        return;
      }

      await registry.loanApplication.persistCache(loanRequestData, summary);

      final response = await registry.repository.loan.previewLoan(loanRequestData.amount);
      if (!mounted) {
        return;
      }

      if (!response.first.passedChecks) {
        await AppSnackBar.of(context).error(response.second);
        registry.coordinator.shared.pop();
        return;
      }

      AppSnackBar.of(context).hide();
      registry.coordinator.loan.toSummary(
        summary: summary,
        request: loanRequestData,
        skippedOfferStep: false,
      );
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}

class _SliderFormField extends StatefulWidget {
  const _SliderFormField({
    Key key,
    @required this.title,
    @required this.valueBuilder,
    @required this.labelBuilder,
    @required this.limits,
    @required this.steps,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.initialValue,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  final String title;
  final String Function(double value) valueBuilder;
  final String Function(double value) labelBuilder;
  final Pair<double, double> limits;
  final int steps;
  final double initialValue;
  final FormFieldSetter<double> onSaved;
  final FormFieldValidator<double> validator;
  final AutovalidateMode autovalidateMode;

  @override
  _SliderFormFieldState createState() => _SliderFormFieldState();
}

class _SliderFormFieldState extends State<_SliderFormField> {
  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(_SliderFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style =
        ThemeProvider.of(context).subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: 1.25);

    return FormField<double>(
      initialValue: _value ?? widget.limits.first,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<double> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.title, style: style),
            const ScaledBox.vertical(16),
            Text(
              widget.valueBuilder(field.value),
              style: AppFont.light(58, purpleColor),
              textAlign: TextAlign.start,
            ),
            const ScaledBox.vertical(28),
            ScaledBox.fromSize(
              size: Size.fromHeight(58),
              child: SliderWidget(
                steps: widget.steps,
                value: field.value,
                min: widget.limits.first,
                max: widget.limits.second,
                labelBuilder: widget.labelBuilder,
                onChanged: (value) {
                  field.didChange(value);
                  setState(() => _value = value);
                },
              ),
            ),
            if (field.errorText != null) ...[
              const ScaledBox.vertical(16),
              Text(field.errorText, style: _getErrorStyle(Theme.of(context))),
            ]
          ],
        );
      },
    );
  }

  TextStyle _getErrorStyle(ThemeData themeData) {
    return themeData.textTheme.caption.copyWith(color: themeData.errorColor);
  }
}
