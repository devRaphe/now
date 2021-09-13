import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      appBar: ClearAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ScaledBox.vertical(40),
            const Align(alignment: Alignment.centerLeft, child: AppIcon()),
            const ScaledBox.vertical(38),
            Text(
              "Oh :(",
              style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
            ),
            const ScaledBox.vertical(35),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '"Houston, we have a problem"',
                    style: theme.title.bold.dark.copyWith(height: 1.5),
                  ),
                  TextSpan(text: '  —  ', style: theme.subhead3Semi),
                  TextSpan(text: 'R & D', style: theme.subhead1.primary.copyWith(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            const ScaledBox.vertical(24),
            Text(
              'You just found a bug, no need to panic, we have logged the issue and would provide a resolution as soon as possible.',
              style: theme.subhead3.copyWith(height: 1.45),
            ),
            const ScaledBox.vertical(24),
            Text(
              'If there\'s more to it, you could also file a personal complaint with our customer service representative.',
              style: theme.subhead3.copyWith(height: 1.45),
            ),
            const ScaledBox.vertical(24),
            Text.rich(
              TextSpan(
                text: "Contact support",
                style: theme.bodyMedium.copyWith(color: AppColors.primary),
                recognizer: TapGestureRecognizer()..onTap = () => showSupportDialog(context, email: '', phone: ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
