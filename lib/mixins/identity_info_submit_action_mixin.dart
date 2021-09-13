import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

mixin IdentityInfoSubmitActionMixin {
  BuildContext get context;

  bool get mounted;

  void handleSubmit() async {
    await HapticFeedback.vibrate();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (context) => _Verification(
        onDismiss: () {
          Registry.di.coordinator.shared.toDashboard();
        },
      ),
    );
  }
}

class _Verification extends StatelessWidget {
  const _Verification({
    Key key,
    @required this.onDismiss,
  }) : super(key: key);

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AppStatusBar(
      brightness: Brightness.light,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: Colors.grey.shade200,
              child: Opacity(opacity: .2, child: Image(image: AppImages.splash, fit: BoxFit.fill)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.primary.withOpacity(.15)],
                  begin: const Alignment(0.0, -.5),
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0).scale(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ScaledBox.vertical(110),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0).scale(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please be patient, we’re verifying your information',
                              textAlign: TextAlign.center,
                              style: context.theme.display2.bold.dark.copyWith(height: 1.25),
                            ),
                            ScaledBox.vertical(16),
                            Text(
                              'This usually takes between 5 minutes and an hour, but can sometimes take up to 48 hours. Please check back later',
                              textAlign: TextAlign.center,
                              style: context.theme.subhead3.copyWith(color: AppColors.dark.shade700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ScaledBox.vertical(16),
                    FilledButton(onPressed: onDismiss, child: Text('Dismiss')),
                    ScaledBox.vertical(36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
