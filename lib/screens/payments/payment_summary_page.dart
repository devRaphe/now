import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class PaymentSummaryPage extends StatefulWidget {
  const PaymentSummaryPage({
    Key key,
    @required this.loan,
    @required this.amount,
  }) : super(key: key);

  final LoanModel loan;
  final double amount;

  @override
  _PaymentSummaryPageState createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      appBar: ClearAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ScaledBox.vertical(4),
            UserModelStreamBuilder(
              builder: (context, user) => Text(
                'Here\’s what your payment looks like',
                style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
              ),
              orElse: (_) => SizedBox(),
            ),
            const ScaledBox.vertical(48),
            Container(
              color: AppColors.dark.shade50,
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text(
                    'PAYMENT SUMMARY',
                    style: AppFont.bold(14, AppColors.dark).copyWith(height: 1.24, letterSpacing: 1.2),
                  ),
                  const ScaledBox.vertical(32),
                  _InfoItemRow(title: 'LOAN AMOUNT', value: Money.fromString(widget.loan.amount).formatted),
                  const ScaledBox.vertical(24),
                  _InfoItemRow(title: 'DURATION', value: '${widget.loan.durationDays} DAYS'),
                  const ScaledBox.vertical(24),
                  _InfoItemRow(title: 'INTEREST', value: Money.fromString(widget.loan.interest).formatted),
                  const ScaledBox.vertical(24),
                  _InfoItemRow(
                    title: 'OVERDUE INTEREST',
                    value: Money.fromString(widget.loan.overdueInterest ?? "").formatted,
                  ),
                ],
              ),
            ),
            const ScaledBox.vertical(2),
            Container(
              color: AppColors.dark.shade200,
              padding: EdgeInsets.all(24),
              child: _InfoItemRow(
                title: 'PAY BACK',
                value: Money.fromString(widget.loan.amountForRepayment).formatted,
                fontWeight: AppStyle.bold,
              ),
            ),
            const ScaledBox.vertical(16),
            TouchableOpacity(
              child: Text(
                'Change Payment',
                style: theme.bodyMedium.copyWith(color: AppColors.primary),
              ),
              onPressed: changePayment,
            ),
            const ScaledBox.vertical(32),
            FilledButton(
              child: Text('Pay ${Money(widget.amount).formatted}'),
              onPressed: handleSubmit,
            ),
            const ScaledBox.vertical(16),
          ],
        ),
      ),
    );
  }

  void changePayment() {
    Navigator.pop(context);
  }

  void handleSubmit() {
    Registry.di.coordinator.payments.toBankTransfer(
      amount: widget.amount,
    );
  }
}

class _InfoItemRow extends StatelessWidget {
  const _InfoItemRow({
    Key key,
    @required this.title,
    @required this.value,
    this.fontWeight = AppStyle.medium,
  }) : super(key: key);

  final String title;
  final String value;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final style = ThemeProvider.of(context).body1.copyWith(height: 1.24, letterSpacing: 1.2, fontWeight: fontWeight);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: style.copyWith(color: kTextBaseColor, fontWeight: fontWeight)),
        ),
        Text(value, style: style.copyWith(color: AppColors.dark, fontWeight: fontWeight)),
      ],
    );
  }
}
