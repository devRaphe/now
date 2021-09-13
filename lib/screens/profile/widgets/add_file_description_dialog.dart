import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/profile/widgets/dialog_wrapper.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFileDescriptionDialog extends StatefulWidget {
  const AddFileDescriptionDialog({Key key}) : super(key: key);

  @override
  _AddFileDescriptionDialogState createState() => _AddFileDescriptionDialogState();
}

class _AddFileDescriptionDialogState extends State<AddFileDescriptionDialog> with DismissKeyboardMixin {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: Registry.di.session.isDev ? "IO" : "");
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      title: "Add File Description",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: 2,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: "Description"),
            onEditingComplete: handleSubmit,
          ),
          const ScaledBox.vertical(28),
          FilledButton(
            onPressed: handleSubmit,
            child: Text("Save"),
          ),
          const ScaledBox.vertical(16),
        ],
      ),
    );
  }

  void handleSubmit() async {
    closeKeyboard();
    final message = Validators.tryLength(
      min: 2,
      error: "The inputted description is not valid. At least 2 letters",
    )(controller.text);
    if (message == null) {
      Navigator.pop(context, controller.text);
      return;
    }

    AppSnackBar.of(context).info(message);
  }
}
