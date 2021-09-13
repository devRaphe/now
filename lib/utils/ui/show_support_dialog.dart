import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'webview_dialog.dart';

void showSupportDialog(BuildContext context, {@required String phone, @required String email}) async {
  await HapticFeedback.vibrate();
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => WebviewDialog(
      url:
          "https://go.crisp.chat/chat/embed/?website_id=8efabd87-69b4-4391-a7af-a2f5ce8659bc&user_phone=$phone&user_email=$email",
      title: "Support",
    ),
  );
}
