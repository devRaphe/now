import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String message, {
  String no = "No",
  String yes = "Yes",
}) async {
  final text = Text(message);

  final dialog = Platform.isIOS
      ? CupertinoAlertDialog(
          title: text,
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(yes),
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context, true),
            ),
            CupertinoDialogAction(
              child: Text(no),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
      : AlertDialog(
          content: text,
          actions: <Widget>[
            TextButton(
              child: Text(no.toUpperCase()),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(yes.toUpperCase()),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );

  return showDialog<bool>(context: context, builder: (_) => dialog);
}
