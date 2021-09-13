import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/screens.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsOfUseView extends StatefulWidget {
  const TermsOfUseView({Key key}) : super(key: key);

  @override
  _TermsOfUseViewState createState() => _TermsOfUseViewState();
}

class _TermsOfUseViewState extends State<TermsOfUseView> {
  bool iHaveReadToc = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ScaledBox.vertical(4),
          Text(
            'Some important information for you',
            style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
          ),
          const ScaledBox.vertical(28),
          Text(
            'We need to verify your details',
            style: theme.subhead1.dark,
          ),
          const ScaledBox.vertical(20),
          Text(
            'To be eligible for a loan from us, we need to verify that all the details you have provided to us are accurate and correct. Our third-party providers will perform a verification check. This means that...',
          ),
          const ScaledBox.vertical(28),
          _GroupedInfo(
            color: AppColors.danger,
            items: [
              // TODO: fix icons
              MapEntry(AppIcons.credit_card, 'We will charge N200 for verification'),
              MapEntry(AppIcons.money, 'The charge is non-refundable'),
              MapEntry(AppIcons.earth_grid, 'Verification takes approx 2 hours'),
              MapEntry(AppIcons.bank, 'Only successful profiles can get loans'),
            ],
          ),
          const ScaledBox.vertical(28),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "Read the full "),
                TextSpan(
                  text: "Terms of Use",
                  style: theme.bodyMedium.dark,
                  recognizer: TapGestureRecognizer()..onTap = () => launchWebView(_WebviewType.terms),
                ),
                TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: theme.bodyMedium.dark,
                  recognizer: TapGestureRecognizer()..onTap = () => launchWebView(_WebviewType.privacy),
                ),
              ],
              style: theme.bodyMedium,
            ),
          ),
          const ScaledBox.vertical(28),
          Row(
            children: <Widget>[
              Checkbox(
                value: iHaveReadToc,
                onChanged: (value) => setState(() => iHaveReadToc = value),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Text("I have read and agree with all of the above", style: theme.bodyMedium),
              ),
            ],
          ),
          const ScaledBox.vertical(16),
          FilledButton(
            onPressed: handleSubmit,
            child: Text("Agree & Continue"),
          ),
          const ScaledBox.vertical(16),
        ],
      ),
    );
  }

  void handleSubmit() async {
    if (iHaveReadToc == false) {
      AppSnackBar.of(context).error("We need you to read and accept the terms above");
      return;
    }

    Navigator.of(context).pushNamed(context.loanRequestService.nextPage);
  }

  void launchWebView(_WebviewType type) async {
    await HapticFeedback.vibrate();
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => WebviewDialog(
        url: "www.borome.ng/${type.value.first}",
        title: type.value.second,
      ),
    );
  }
}

class _GroupedInfo extends StatelessWidget {
  const _GroupedInfo({
    Key key,
    @required this.color,
    @required this.items,
  }) : super(key: key);

  final Color color;
  final List<MapEntry<IconData, String>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final item in items)
          _IconRow(
            icon: item.key,
            text: item.value,
            iconColor: color,
          ),
      ],
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({
    Key key,
    @required this.icon,
    @required this.text,
    this.iconColor,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6).scale(context),
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColor),
          const ScaledBox.horizontal(15),
          Text(
            text,
            style: ThemeProvider.of(context).bodyMedium.copyWith(color: AppColors.dark, height: 1.24),
          ),
        ],
      ),
    );
  }
}

enum _WebviewType {
  privacy,
  terms,
}

extension on _WebviewType {
  Pair<String, String> get value {
    switch (this) {
      case _WebviewType.terms:
        return Pair("terms", "Terms of Use");
      case _WebviewType.privacy:
      default:
        return Pair("privacy-policy", "Privacy Policy");
    }
  }
}
