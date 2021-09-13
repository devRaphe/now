import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/mixins.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class IdentityVerificationView extends StatefulWidget {
  @override
  _IdentityVerificationViewState createState() => _IdentityVerificationViewState();
}

class _IdentityVerificationViewState extends State<IdentityVerificationView> with IdentityInfoSubmitActionMixin {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return StreamBuilder<SubState<ProfileStatusModel>>(
      initialData: context.store.state.value.profileStatus,
      stream: context.store.state.map((state) => state.profileStatus),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.loading) {
          return Align(
            alignment: Alignment.topCenter,
            child: LoadingSpinner.linear(),
          );
        }

        if (snapshot.data.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(snapshot.data.error, textAlign: TextAlign.center),
              TextButton(
                child: Text('RETRY'),
                onPressed: () => onRefresh(),
              )
            ],
          );
        }

        final ProfileStatusModel model = snapshot.data.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ScaledBox.vertical(4),
            Text(
              "Identity Verification",
              style: theme.display3.copyWith(height: 1.08, fontWeight: AppStyle.bold, color: AppColors.primary),
            ),
            const ScaledBox.vertical(32),
            _OptionButton(
              title: 'Connect Bank Account',
              icon: AppIcons.bank,
              isActive: model.bankAccount,
              onPressed: () {
                handleValidation(url: model.bankAccountConnectionLink, title: 'Connect Bank Account');
              },
            ),
            const ScaledBox.vertical(12),
            _OptionButton(
              title: 'Pay for Verification',
              icon: AppIcons.credit_card,
              isActive: model.paymentVerification,
              onPressed: () {
                handleValidation(url: model.paymentVerificationLink, title: 'Pay for Verification');
              },
            ),
            const Spacer(),
            FilledButton(
              onPressed: model.bankAccount && model.paymentVerification ? handleSubmit : null,
              child: Text('Verify'),
            ),
            const ScaledBox.vertical(32),
          ],
        );
      },
    );
  }

  void handleValidation({@required String url, @required String title}) async {
    await HapticFeedback.vibrate();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WebviewDialog(url: url, title: title),
    );
    onRefresh();
  }

  void onRefresh() {
    context.dispatchAction(const ProfileStatusActions.fetch());
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.isActive,
    @required this.onPressed,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    return TouchableOpacity(
      onPressed: onPressed,
      pressedOpacity: .75,
      child: ScaledBox.fromSize(
        size: Size.fromHeight(64),
        child: Container(
          decoration: const ShadowBoxDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20).scale(context),
          child: Row(
            children: [
              Icon(icon, size: context.scale(24)),
              const ScaledBox.horizontal(12),
              Expanded(
                child: Text(title, style: theme.subhead3.dark),
              ),
              const ScaledBox.horizontal(12),
              Icon(
                isActive ? Icons.check_circle : Icons.add_circle,
                color: isActive ? AppColors.success : AppColors.light_grey.withOpacity(.35),
                size: context.scale(24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
