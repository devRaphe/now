import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    Key key,
    @required this.data,
  }) : super(key: key);

  final PaymentModel data;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppFont.size(12).copyWith(height: 1.24);

    return InkWell(
      highlightColor: AppColors.primary.withOpacity(.2),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12).scale(context),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.tight(Size.square(40)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFFFF6600),
              ),
              child: Icon(AppIcons.credit_card, color: Colors.white),
            ),
            const ScaledBox.horizontal(8),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Money.fromString(data.amount).formatted,
                    style: AppFont.bold(12, AppColors.dark).copyWith(height: 1.24),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const ScaledBox.vertical(2),
                  Text(
                    DateFormat('d MMM y').format(data.createdAt),
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text('Paid', style: textStyle.copyWith(color: Colors.white)),
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16).scale(context),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const ScaledBox.vertical(2),
                  Text(
                    data.paymentMethod,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
