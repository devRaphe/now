import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rating_dialog/rating_dialog.dart';

const ratingDialogKey = "RATING_DIALOG_COMPLETE";

class LoanStatusPage extends StatefulWidget {
  const LoanStatusPage({
    Key key,
    @required this.isSuccessful,
    @required this.message,
  }) : super(key: key);

  final bool isSuccessful;
  final String message;

  @override
  _LoanStatusPageState createState() => _LoanStatusPageState();
}

class _LoanStatusPageState extends State<LoanStatusPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return AppScaffold(
      appBar: ClearAppBar(
        leading: AppCloseButton(
          onPressed: Registry.di.coordinator.shared.toDashboard,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ScaledBox.vertical(72),
          Expanded(
            flex: 2,
            child: Image(image: widget.isSuccessful ? AppImages.success : AppImages.failure, fit: BoxFit.cover),
          ),
          const ScaledBox.vertical(40),
          Text(
            "Loan Request ${widget.isSuccessful ? 'Successful' : 'Unsuccessful'}",
            style: theme.display6.copyWith(height: 1.08, fontWeight: AppStyle.thin, color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const ScaledBox.vertical(16),
          Center(
            child: SizedBox(
              width: context.scale(257),
              child: Text(
                widget.message ?? "",
                style: theme.title.copyWith(height: 1.27, color: AppColors.dark),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const ScaledBox.vertical(16),
          const Spacer(),
          UserModelStreamBuilder(
            builder: (context, user) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  child: Text(widget.isSuccessful ? "Dismiss" : "Retry"),
                  onPressed: () => _onSubmit(user),
                ),
                if (!widget.isSuccessful) ...[
                  const ScaledBox.vertical(12),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Contact support",
                        style: theme.bodyMedium.copyWith(color: AppColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => showSupportDialog(context, email: user.email, phone: user.phone),
                      ),
                    ),
                  ),
                ]
              ],
            ),
            orElse: (_) => SizedBox(),
          ),
          const ScaledBox.vertical(32),
        ],
      ),
    );
  }

  void _onSubmit(UserModel user) {
    final prefs = Registry.di.sharedPref;
    if (!(prefs.getBool(ratingDialogKey) ?? false)) {
      prefs.setBool(ratingDialogKey, true);
      _showRating(user);
      return;
    }
    widget.isSuccessful ? Registry.di.coordinator.shared.toDashboard() : Navigator.pop(context);
  }

  void _showRating(UserModel user) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => RatingDialog(
        image: const Center(child: AppIcon()),
        title: "Enjoying Borome?",
        message: "Tap a star to rate on the App Store.",
        submitButton: "SUBMIT",
        ratingColor: AppColors.primary,
        onSubmitted: (response) {
          if (response.rating > 3) {
            LaunchReview.launch(androidAppId: "ng.borome.apps", iOSAppId: "id1509031811");
          } else {
            showSupportDialog(context, email: user.email, phone: user.phone);
          }
        },
        onCancelled: () {
          showSupportDialog(context, email: user.email, phone: user.phone);
        },
      ),
    );
  }
}
