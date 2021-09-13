import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class AmountPage extends StatefulWidget {
  const AmountPage({
    Key key,
    @required this.method,
    @required this.loan,
    @required this.paymentUrl,
  }) : super(key: key);

  final PaymentMethod method;
  final LoanModel loan;
  final String paymentUrl;

  @override
  _AmountPageState createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  final controller = MoneyMaskedValueNotifier(symbol: Money.symbol);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBar(title: Text('Enter Amount'), primary: true),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.scaleY(24)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const ScaledBox.vertical(32),
                ValueListenableBuilder<String>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Text(
                          value,
                          style: theme.headline.bold.dark,
                          textAlign: TextAlign.center,
                        ),
                        const ScaledBox.vertical(12),
                        child,
                      ],
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'You are owing '),
                        TextSpan(
                          text: Money.fromString(widget.loan.amountRemaining, isLong: true).formatted,
                          style: theme.subhead3.medium.dark,
                        ),
                      ],
                    ),
                    style: theme.subhead1.medium,
                    textAlign: TextAlign.center,
                  ),
                ),
                KeypadGridView(
                  maxLength: 13,
                  controller: controller,
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => FilledButton(
                    child: Text('Continue'),
                    onPressed: controller.numberValue > 0.0 ? onContinue : null,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void onContinue() async {
    if (controller.numberValue > double.parse(widget.loan.amountRemaining)) {
      AppSnackBar.of(context).info(AppStrings.overPaymentMessage);
      return;
    }

    final paymentsCoordinator = Registry.di.coordinator.payments;
    switch (widget.method) {
      case PaymentMethod.debit:
        try {
          final message = await Registry.di.repository.payment.debitAccount(
            widget.loan.reference,
            controller.value,
          );
          await showSuccessDialog(
            context,
            title: 'Payment Received',
            caption: message,
            onDismiss: () {
              context.dispatchAction(DashboardActions.fetch());
              paymentsCoordinator.popUntil(AppRoutes.dashboard);
            },
          );
        } catch (e, st) {
          AppLog.e(e, st);
          AppSnackBar.of(context).error(errorToString(e));
        }
        break;
      case PaymentMethod.card:
        paymentsCoordinator.toCardPayment(
          loan: widget.loan,
          payUrl: widget.paymentUrl,
          amount: controller.numberValue,
        );
        break;
      case PaymentMethod.transfer:
      default:
        paymentsCoordinator.toSummary(loan: widget.loan, amount: controller.numberValue);
    }
  }
}
