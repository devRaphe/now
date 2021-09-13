import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/loans/payment_item.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class LoanDetailsPage extends StatefulWidget {
  const LoanDetailsPage({Key key, @required this.loan}) : super(key: key);

  final LoanModel loan;

  @override
  _LoanDetailsPageState createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  StreamableDataModel<LoanDetailsData> loanDetailsBloc;
  Stream<DataModel<LoanDetailsData>> loanDetailsStream;

  @override
  void initState() {
    super.initState();

    loanDetailsBloc = StreamableDataModel(
      () => Registry.di.repository.loan.getDetails(widget.loan.reference),
      initialData: DataModel(LoanDetailsData.fromLoan(widget.loan)),
      errorMapper: errorToString,
    );

    loanDetailsStream = loanDetailsBloc.stream;
  }

  @override
  void dispose() {
    loanDetailsBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: StreamBuilder<Pair<DataModel<LoanDetailsData>, SubState<UserModel>>>(
        stream: CombineLatestStream.combine2<DataModel<LoanDetailsData>, SubState<UserModel>,
            Pair<DataModel<LoanDetailsData>, SubState<UserModel>>>(
          loanDetailsStream,
          context.store.state.map((state) => state.user),
          (a, b) => Pair(a, b),
        ),
        initialData: Pair(loanDetailsBloc.value, context.store.state.value.user),
        builder: (_, snapshot) {
          final data = snapshot.data.first.isData ? snapshot.data.first : loanDetailsBloc.value;
          return _ContentView(
            state: snapshot.data.first,
            data: data.valueOrNull,
            user: snapshot.data.second,
            onRetry: loanDetailsBloc.refresh,
          );
        },
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({
    Key key,
    @required this.state,
    @required this.data,
    @required this.user,
    @required this.onRetry,
  }) : super(key: key);

  final DataModel<LoanDetailsData> state;
  final LoanDetailsData data;
  final SubState<UserModel> user;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return CustomScrollView(
      slivers: [
        CustomSliverAppBar(title: Text("Loan Details"), primary: true, isLoading: state.isLoading),
        if (state.isLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: context.scaleY(10)),
              child: LoadingWidget(message: AppStrings.loadingMessage),
            ),
          ),
        if (state.hasError)
          SliverToBoxAdapter(
            child: Center(
              child: TouchableOpacity(
                child: ErrorTextWidget(message: state.message),
                onPressed: onRetry,
              ),
            ),
          ),
        if (data != null) ...[
          _DetailsSliverView(
            loan: data.loan,
            accountNumber: user?.value?.virtualAccountNumber ?? "n/a",
            bankName: user?.value?.virtualBankName ?? "n/a",
          ),
          if (data.payments.isEmpty)
            SliverToBoxAdapter(child: Center(child: Text("No payments to see yet")))
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 54).scale(context),
              sliver: SliverList(
                delegate: SliverSeparatorBuilderDelegate.withHeader(
                  builder: (_, i) => PaymentItem(data: data.payments[i]),
                  childCount: data.payments.length,
                  headerBuilder: (_a) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8).scale(context),
                    child: Text("REPAYMENTS", style: theme.bodyBold.copyWith(color: AppColors.dark)),
                  ),
                  separatorBuilder: (_a, _b) => const ScaledBox.vertical(12),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _DetailsSliverView extends StatelessWidget {
  const _DetailsSliverView({
    Key key,
    @required this.loan,
    @required this.accountNumber,
    @required this.bankName,
  }) : super(key: key);

  final LoanModel loan;
  final String accountNumber;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16).scale(context),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12).scale(context),
            constraints: BoxConstraints(maxHeight: context.scaleY(156)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Loan Amount",
                              style: theme.bodyBold.copyWith(color: Colors.white),
                            ),
                            Text(
                              Money.fromString(loan.amount).formatted,
                              style: theme.display4.copyWith(color: Colors.white, fontWeight: AppStyle.bold),
                            ),
                          ],
                        ),
                      ),
                      if (loan.canRepayLoan)
                        FilledButton(
                          height: 30,
                          backgroundColor: Colors.white,
                          onPressed: () => repayLoan(
                            context,
                            loan: loan,
                            accountNumber: accountNumber,
                            bankName: bankName,
                          ),
                          shape: StadiumBorder(),
                          child: Text("Repay Now", style: theme.smallButton),
                        ),
                    ],
                  ),
                ),
                const ScaledBox.vertical(4),
                const Divider(color: Colors.white, height: 0),
                const ScaledBox.vertical(12),
                UserModelStreamBuilder(
                  builder: (context, user) => Align(
                    alignment: Alignment.centerRight,
                    child: TouchableOpacity(
                      minHeight: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(AppIcons.chat, size: 18, color: Colors.white),
                          const ScaledBox.horizontal(4),
                          Text(
                            "Complain",
                            style: theme.subhead1Semi.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      color: Colors.white,
                      onPressed: () => showSupportDialog(context, email: user.email, phone: user.phone),
                    ),
                  ),
                  orElse: (context) => Center(child: LoadingSpinner.circle()),
                ),
              ],
            ),
          ),
          const ScaledBox.vertical(24),
          _InfoRow(
            left: Pair("Reference Number", loan.reference),
            right: Pair("Loan Reason", loan.loanReason),
          ),
          const ScaledBox.vertical(16),
          _InfoRow(
            left: Pair("Amount to Repay", Money.fromString(loan.amountForRepayment).formatted),
            right: Pair("Amount Remaining", Money.fromString(loan.amountRemaining).formatted),
          ),
          const ScaledBox.vertical(16),
          _InfoRow(
            left: Pair("Loan Duration", "${loan.durationDays} Days"),
            right: Pair("Payment Status", loan.status.toUpperCase()),
          ),
          const ScaledBox.vertical(16),
          _InfoRow(
            left: Pair(
              "Date Disbursed",
              loan.dateDisbursed != null ? DateFormat("d MMM y").format(loan.dateDisbursed) : "N/A",
            ),
            right: Pair("Date Due", DateFormat("d MMM y").format(loan.dateDue)),
          ),
          const ScaledBox.vertical(32),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    Key key,
    @required this.left,
    @required this.right,
  }) : super(key: key);

  final Pair<String, String> left;
  final Pair<String, String> right;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Row(
      children: <Widget>[
        Expanded(flex: 5, child: buildColumn(left, theme)),
        Expanded(flex: 4, child: buildColumn(right, theme)),
      ],
    );
  }

  Widget buildColumn(Pair<String, String> pair, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(pair.first, style: theme.body1),
        const ScaledBox.vertical(4),
        Text(pair.second, style: theme.subhead3Semi.copyWith(color: AppColors.dark)),
      ],
    );
  }
}
