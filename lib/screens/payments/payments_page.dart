import 'package:borome/constants.dart';
import 'package:borome/constants/app_colors.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key key}) : super(key: key);

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final _paymentMethods = [PaymentMethod.debit, PaymentMethod.transfer, PaymentMethod.card];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CustomSliverAppBar(title: Text("Payments"), primary: true, automaticallyImplyLeading: false),
        StreamBuilder<Pair<SubState<DashboardData>, SubState<SetUpData>>>(
          initialData: Pair(context.store.state.value.dashboard, context.store.state.value.setup),
          stream: context.store.state.map((state) => Pair(state.dashboard, state.setup)),
          builder: (context, snapshot) {
            final dashboardState = snapshot.data;
            if (dashboardState == null || dashboardState.first.loading) {
              return SliverLoadingWidget();
            }

            if (dashboardState.first.hasError) {
              return SliverErrorWidget(
                message: dashboardState.first.error,
                onRetry: () => context.dispatchAction(UserActions.fetch()),
              );
            }

            final lastLoan = dashboardState.first.value?.lastLoan;
            if (lastLoan == null) {
              return SliverToBoxAdapter(
                child: Center(heightFactor: 12, child: Text('No outstanding payments')),
              );
            }

            final setupState = dashboardState.second.value;

            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.scaleY(24)),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _OutstandingBalanceCard(
                      amount: lastLoan.amountRemaining,
                    ),
                    const ScaledBox.vertical(32),
                    Text(
                      'SELECT PAYMENT METHOD',
                      style: context.theme.bodyMedium.dark,
                    ),
                    const ScaledBox.vertical(16),
                    ...ListUtils.withSeparator(
                      (index) {
                        return _PaymentMethodCard(
                          method: _paymentMethods[index],
                          loan: lastLoan,
                          fees: setupState.fees,
                          paymentUrl: setupState.paymentUrl,
                        );
                      },
                      (index) => ScaledBox.vertical(12),
                      _paymentMethods.length,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _OutstandingBalanceCard extends StatelessWidget {
  const _OutstandingBalanceCard({
    Key key,
    @required this.amount,
  }) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ScaledBox.fromSize(
      size: Size.fromHeight(84.0),
      child: Container(
        decoration: const ShadowBoxDecoration().copyWith(
          image: DecorationImage(
            image: AppImages.balanceBackground,
            fit: BoxFit.fitHeight,
            alignment: Alignment.centerRight,
          ),
          color: AppColors.primary,
        ),
        padding: EdgeInsets.all(context.scaleY(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox.fromSize(
                  size: Size.square(40).scale(context),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(AppIcons.wallet, color: AppColors.primary, size: context.scale(24)),
                  ),
                ),
                const ScaledBox.horizontal(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Outstanding Balance', style: theme.body1.white),
                    const ScaledBox.vertical(1),
                    Text(
                      Money.fromString(amount, isLong: true).formatted,
                      style: theme.display2.bold.white,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    Key key,
    @required this.method,
    @required this.paymentUrl,
    @required this.fees,
    @required this.loan,
  }) : super(key: key);

  final PaymentMethod method;
  final String paymentUrl;
  final FeesModel fees;
  final LoanModel loan;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final borderRadius = BorderRadius.circular(16);

    return ScaledBox.fromSize(
      size: Size.fromHeight(72.0),
      child: InkWell(
        highlightColor: AppColors.primary.withOpacity(.2),
        borderRadius: borderRadius,
        onTap: () => Registry.di.coordinator.payments.toAmount(
          method: method,
          loan: loan,
          paymentUrl: paymentUrl,
        ),
        child: Ink(
          padding: EdgeInsets.all(12.0).scale(context),
          decoration: BoxDecoration(borderRadius: borderRadius, color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: borderRadius,
                  ),
                  child: Icon(method.icon, color: Colors.white, size: context.scale(24)),
                ),
              ),
              ScaledBox.horizontal(12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(method.title, style: theme.subhead3.dark.medium),
                    ScaledBox.vertical(2),
                    Text(method.description(fees, double.parse(loan.amountRemaining)), style: theme.bodyHint),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
