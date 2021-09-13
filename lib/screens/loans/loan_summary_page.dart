import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class LoanSummaryPage extends StatefulWidget {
  const LoanSummaryPage({
    Key key,
    @required this.request,
    @required this.summary,
    @required this.skippedOfferStep,
  }) : super(key: key);

  final LoanSummaryData summary;
  final LoanRequestData request;
  final bool skippedOfferStep;

  @override
  _LoanSummaryPageState createState() => _LoanSummaryPageState();
}

class _LoanSummaryPageState extends State<LoanSummaryPage> with DismissKeyboardMixin {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      appBar: ClearAppBar(
        leading: widget.skippedOfferStep ? AppCloseButton(onPressed: cancelApplication) : const AppBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ScaledBox.vertical(4),
            UserModelStreamBuilder(
              builder: (context, user) => Text(
                "${user.firstname}, let’s take a look at your loan",
                style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
              ),
              orElse: (_) => SizedBox(),
            ),
            const ScaledBox.vertical(28),
            Text(
              "Great job, you’re almost done. Let’s review and confirm your changes.",
              style: theme.subhead3.copyWith(height: 1.24, fontWeight: AppStyle.medium, letterSpacing: .25),
            ),
            const ScaledBox.vertical(48),
            Container(
              color: AppColors.dark.shade50,
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text(
                    "LOAN SUMMARY",
                    style: AppFont.bold(14, AppColors.dark).copyWith(height: 1.24, letterSpacing: 1.2),
                  ),
                  const ScaledBox.vertical(32),
                  _InfoItemRow(title: "LOAN PRINCIPAL", value: Money.fromString(widget.summary.principal).formatted),
                  const ScaledBox.vertical(24),
                  _InfoItemRow(title: "LOAN DURATION", value: "${widget.summary.duration} DAYS"),
                  const ScaledBox.vertical(24),
                  _InfoItemRow(title: "INTEREST", value: Money.fromString(widget.summary.monthlyInterest).formatted),
                ],
              ),
            ),
            const ScaledBox.vertical(2),
            Container(
              color: AppColors.dark.shade200,
              padding: EdgeInsets.all(24),
              child: _InfoItemRow(
                title: "PAY BACK",
                value: Money.fromString(widget.summary.monthlyPayment).formatted,
                fontWeight: AppStyle.bold,
              ),
            ),
            const ScaledBox.vertical(16),
            TouchableOpacity(
              child: Text(
                "Change Terms",
                style: ThemeProvider.of(context).bodyMedium.copyWith(color: AppColors.primary),
              ),
              onPressed: changeTerms,
            ),
            const ScaledBox.vertical(32),
            FilledButton(
              child: Text("Accept"),
              onPressed: handleSubmit,
            ),
            const ScaledBox.vertical(16),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelApprovedAmount() async {
    await Registry.di.repository.loan.cancelApprovedAmount();
    if (!mounted) {
      return;
    }

    await Registry.di.loanApplication.emptyCache();
  }

  Future<void> cancelApplication() async {
    final choice = await showConfirmDialog(context, AppStrings.quitLoanApplication);
    if (choice != true) {
      return;
    }

    AppSnackBar.of(context).loading();
    try {
      await _cancelApprovedAmount();
      AppSnackBar.of(context).hide();
      Registry.di.coordinator.shared.toDashboard();
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }

  Future<void> changeTerms() async {
    if (!widget.skippedOfferStep) {
      Navigator.pop(context);
      return;
    }

    AppSnackBar.of(context).loading();
    try {
      await _cancelApprovedAmount();
      AppSnackBar.of(context).hide();
      Registry.di.coordinator.loan.toUploading(clearUntilDashboard: true);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }

  void handleSubmit() async {
    closeKeyboard();

    AppSnackBar.of(context).loading();
    try {
      final message = await Registry.di.repository.loan.apply(widget.request);
      if (!mounted) {
        return;
      }

      await Registry.di.loanApplication.emptyCache();
      Registry.di.coordinator.loan.toStatus(true, message);
    } catch (e, st) {
      AppLog.e(e, st);
      Registry.di.coordinator.loan.toStatus(false, errorToString(e));
    } finally {
      AppSnackBar.of(context).hide();
    }
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
