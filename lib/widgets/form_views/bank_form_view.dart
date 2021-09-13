import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class BankFormView extends StatefulWidget {
  const BankFormView({
    Key key,
    @required this.request,
    this.onSaved,
    this.onChanged,
    this.buttonCaption,
    this.beforeCta,
  }) : super(key: key);

  final BankRequestData request;
  final ValueChanged<BankRequestData> onSaved;
  final ValueChanged<BankRequestData> onChanged;
  final String buttonCaption;
  final Widget beforeCta;

  @override
  _BankFormViewState createState() => _BankFormViewState();
}

class _BankFormViewState extends State<BankFormView> with DismissKeyboardMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final accountName = ValueNotifier<DataModel<String>>(DataModel.empty());
  StreamTextEditingController accNoTextController;

  var _autovalidateMode = AutovalidateMode.disabled;

  bool get isDev => Registry.di.session.isDev;

  @override
  void initState() {
    super.initState();

    accNoTextController = StreamTextEditingController(
      controller: TextEditingController(text: isDev ? "0690000031" : null),
      filter: (value) => value.length > 6,
    )..listen(resolveBankAccount);
  }

  @override
  void dispose() {
    accNoTextController.dispose();
    accountName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Form(
      key: formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            initialValue: isDev ? "12345678900" : null,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
              hintText: "BVN",
              fillColor: Colors.white,
              filled: true,
            ),
            validator: Validators.tryLength(min: 11, max: 11),
            onSaved: (value) {
              widget.request.bvn = value;
            },
          ),
          const ScaledBox.vertical(16),
          StreamBuilder<SubState<SetUpData>>(
            initialData: context.store.state.value.setup,
            stream: context.store.state.map((state) => state.setup),
            builder: (context, snapshot) {
              return DropDownFormField(
                items: snapshot.data.map(
                  (data) => data.banks.map((bank) => bank.name).toList(),
                  orElse: () => const [],
                ),
                decoration: const InputDecoration(
                  hintText: "Bank",
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: Validators.tryString(),
                onSaved: (value) {
                  widget.request.bank = value;
                },
                onChanged: (value) {
                  widget.request.bank = value;
                },
              );
            },
          ),
          const ScaledBox.vertical(16),
          TextFormField(
            controller: accNoTextController.controller,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
              hintText: "Account Number",
              fillColor: Colors.white,
              filled: true,
            ),
            validator: Validators.tryString(),
            onSaved: (value) {
              widget.request.accountNumber = value;
            },
            onEditingComplete: () => resolveBankAccount(accNoTextController.text),
          ),
          const ScaledBox.vertical(16),
          ValueListenableBuilder<DataModel<String>>(
            valueListenable: accountName,
            builder: (BuildContext context, DataModel<String> data, Widget child) {
              if (data.isEmpty) {
                return SizedBox();
              }

              final radius = BorderRadius.circular(12);
              return InkWell(
                borderRadius: radius,
                onTap: data.hasError ? () => resolveBankAccount(accNoTextController.text) : null,
                child: Ink(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    color: AppColors.dark.shade200,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 350),
                      child: data.maybeWhen(
                        (value) => Text(value, style: theme.textfield),
                        loading: () => LoadingSpinner.circle(color: AppColors.secondary.withOpacity(.5), size: 24),
                        error: (message) => Text(message, style: theme.textfield),
                        orElse: () => SizedBox(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.onSaved != null || widget.beforeCta != null) const ScaledBox.vertical(28),
          if (widget.beforeCta != null) widget.beforeCta,
          if (widget.onSaved != null) ...[
            const ScaledBox.vertical(28),
            FilledButton(
              onPressed: handleSubmit,
              child: Text(widget.buttonCaption ?? "Next"),
            ),
            const ScaledBox.vertical(16),
          ],
        ],
      ),
    );
  }

  Future<void> resolveBankAccount(String accountNumber) async {
    if (widget.request.bank == null) {
      return;
    }
    accountName.value = DataModel.loading();
    try {
      final pair = await Registry.di.repository.setup.resolveBankAccount(widget.request.bank, accountNumber);
      if (!mounted) {
        return;
      }
      if (pair.first.name == null) {
        throw AppException(pair.second);
      }
      widget.request.accountName = pair.first.name;
      accountName.value = DataModel(pair.first.name);
      widget.onChanged?.call(widget.request);
    } catch (e, st) {
      AppLog.e(e, st, message: <String, String>{
        "bank": widget.request.bank,
        "accountNumber": accountNumber,
      });
      if (!mounted) {
        return;
      }
      accountName.value = DataModel.error(errorToString(e));
    }
  }

  void handleSubmit() async {
    closeKeyboard();

    final FormState form = formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate() && !Registry.di.session.isMock) {
      _autovalidateMode = AutovalidateMode.always;
      return;
    }

    form.save();

    if (accountName.value.hasError) {
      AppSnackBar.of(context).error(accountName.value.message);
      return;
    }

    if (widget.request.accountName == null && !Registry.di.session.isMock) {
      AppSnackBar.of(context).error("The account name needs to be resolved");
      return;
    }

    widget.onSaved(widget.request);
  }
}
