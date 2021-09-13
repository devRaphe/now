import 'package:borome/domain.dart';
import 'package:flutter/widgets.dart';

import 'platform_action_sheet.dart';

Future<PaymentMethod> showChoiceSheet(BuildContext context) {
  return PlatformActionSheet.show(
    context: context,
    actions: [
      ActionSheetAction(
        text: "Direct debit",
        onPressed: () => Navigator.pop(context, PaymentMethod.debit),
      ),
      ActionSheetAction(
        text: "Card payment",
        onPressed: () => Navigator.pop(context, PaymentMethod.card),
      ),
      ActionSheetAction(
        text: "Bank transfer",
        onPressed: () => Navigator.pop(context, PaymentMethod.transfer),
      ),
      ActionSheetAction(
        text: "Cancel",
        onPressed: () => Navigator.pop(context),
        isCancel: true,
        defaultAction: true,
      )
    ],
  );
}
