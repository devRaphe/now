import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.data,
  }) : super(key: key);

  final LoanModel data;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppFont.size(12).copyWith(height: 1.24);

    return InkWell(
      onTap: () => Registry.di.coordinator.loan.toDetails(loan: data),
      borderRadius: BorderRadius.circular(12),
      highlightColor: AppColors.primary.withOpacity(.2),
      child: Ink(
        padding: EdgeInsets.all(context.scaleY(12)),
        decoration: const ShadowBoxDecoration(),
        child: Row(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.tight(Size.square(40)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF1896A5),
              ),
              child: Icon(AppIcons.bank, color: Colors.white),
            ),
            const ScaledBox.horizontal(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.account == null
                        ? "Account information is missing"
                        : "${data.account.accountBank} - ${data.account.accountNumber}",
                    style: AppFont.medium(12, AppColors.dark).copyWith(height: 1.24),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.loanReason,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  Money.fromString(data.amount).formatted,
                  style: AppFont.bold(12, AppColors.dark).copyWith(height: 1.24),
                ),
                Text(DateFormat("d MMM y").format(data.dateDue), style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
