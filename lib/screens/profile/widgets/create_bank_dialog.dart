import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/profile/widgets/dialog_wrapper.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class CreateBankDialog extends StatefulWidget {
  const CreateBankDialog({Key key}) : super(key: key);

  @override
  _CreateBankDialogState createState() => _CreateBankDialogState();
}

class _CreateBankDialogState extends State<CreateBankDialog> with DismissKeyboardMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BankRequestData bankRequestData;

  var autoValidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    bankRequestData = BankRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      title: "Add Bank",
      child: BankFormView(
        request: bankRequestData,
        onSaved: handleSubmit,
        buttonCaption: "Save",
      ),
    );
  }

  void handleSubmit(BankRequestData request) async {
    closeKeyboard();
    AppSnackBar.of(context).loading();
    try {
      final accounts = await Registry.di.repository.auth.saveBankingInfo(request);
      if (!mounted) {
        return;
      }
      context.dispatchAction(UserActions.updateAccounts(accounts));
      await AppSnackBar.of(context).success(AppStrings.successMessage);
      Navigator.pop(context);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
