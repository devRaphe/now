import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class BankTransferPage extends StatefulWidget {
  const BankTransferPage({Key key, @required this.amount}) : super(key: key);

  final double amount;

  @override
  _BankTransferPageState createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBar(title: Text('Pay by Bank Transfer'), primary: true),
          UserModelStreamBuilder(
            orElse: (BuildContext context) => LoadingSpinner.circle(),
            builder: (BuildContext context, UserModel user) => SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.scaleY(24)),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const ScaledBox.vertical(24),
                  Text(
                    'You are paying',
                    style: theme.subhead1.medium,
                    textAlign: TextAlign.center,
                  ),
                  const ScaledBox.vertical(4),
                  Text(
                    Money(widget.amount, isLong: true).formatted,
                    style: theme.headline.bold.dark,
                    textAlign: TextAlign.center,
                  ),
                  const ScaledBox.vertical(4),
                  TouchableOpacity(
                    child: Text(
                      'Change Amount',
                      style: theme.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                    minHeight: theme.bodyMedium.fontSize * 2.5,
                    padding: EdgeInsets.zero,
                    onPressed: changeAmount,
                  ),
                  const ScaledBox.vertical(32),
                  Text(
                    'MAKE PAYMENT TO',
                    style: AppFont.bold(14, AppColors.dark).copyWith(height: 1.24, letterSpacing: 1.2),
                  ),
                  Divider(height: context.scaleY(16.0)),
                  const ScaledBox.vertical(8),
                  _InfoRow(
                    title: 'Account Name',
                    value: user.repaymentAccountName,
                  ),
                  const ScaledBox.vertical(16),
                  _InfoRow(
                    title: 'Bank',
                    value: user.repaymentBankName,
                  ),
                  const ScaledBox.vertical(16),
                  _InfoRow(
                    title: 'Account Number',
                    value: user.repaymentAccountNumber,
                    trailing: _CopyToClipboardButton(accountNumber: user.repaymentAccountNumber),
                  ),
                  const ScaledBox.vertical(48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0).scale(context),
                    child: Text(
                      AppStrings.bankTransferPaymentMessage,
                      style: theme.subhead1.medium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const ScaledBox.vertical(48),
                  FilledButton(
                    child: Text('Confirm Payment'),
                    onPressed: handleSubmit,
                  ),
                  const ScaledBox.vertical(16),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeAmount() {
    Registry.di.coordinator.payments.popUntil(AppRoutes.amount);
  }

  void handleSubmit() async {
    final message = await Registry.di.repository.payment.checkBankTransfer();
    await showSuccessDialog(
      context,
      title: 'We are having a look...',
      caption: message,
      style: SuccessDialogStyle.light,
      onDismiss: () {
        context.dispatchAction(DashboardActions.fetch());
        Registry.di.coordinator.payments.popUntil(AppRoutes.dashboard);
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    Key key,
    @required this.title,
    @required this.value,
    this.trailing,
  }) : super(key: key);

  final String title;
  final String value;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.body1),
        const ScaledBox.vertical(4),
        Text(value, style: theme.subhead3Semi.copyWith(color: AppColors.dark)),
      ],
    );

    if (trailing != null) {
      child = Row(
        children: [
          Expanded(child: child),
          trailing,
        ],
      );
    }
    return child;
  }
}

class _CopyToClipboardButton extends StatelessWidget {
  const _CopyToClipboardButton({
    Key key,
    @required this.accountNumber,
  }) : super(key: key);

  final String accountNumber;

  void _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: accountNumber));
    await HapticFeedback.vibrate();
    AppSnackBar.of(context).info("Copied to Clipboard");
  }

  @override
  Widget build(BuildContext context) {
    var size = context.scaleY(24);
    return TouchableOpacity(
      minHeight: size,
      child: Icon(Icons.copy_rounded, size: size, color: AppColors.primary),
      onPressed: () => _copyToClipboard(context),
    );
  }
}
