import 'package:borome/constants.dart';
import 'package:borome/constants/app_colors.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

import '../../extensions.dart';
import '../../utils/ui/app_status_bar.dart';

void showPaymentFailureDialog(
  BuildContext context, {
  @required String title,
  @required String caption,
  @required VoidCallback onDismiss,
}) async {
  await HapticFeedback.vibrate();
  await showDialog<void>(
    context: context,
    useSafeArea: false,
    builder: (_) => _Dialog(
      title: title,
      caption: caption,
      onDismiss: onDismiss,
    ),
  );
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    Key key,
    @required this.title,
    @required this.caption,
    @required this.onDismiss,
  }) : super(key: key);

  final String title;
  final String caption;
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
                    Image(height: context.scaleY(181), image: AppImages.failureCheck),
                    ScaledBox.vertical(36),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.theme.display2.bold.dark.copyWith(height: 1.25),
                    ),
                    ScaledBox.vertical(16),
                    Expanded(
                      child: Text(
                        caption,
                        textAlign: TextAlign.center,
                        style: context.theme.subhead3.copyWith(color: AppColors.dark.shade700),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MethodItemBox(
                          onPressed: () {},
                          image: AppImages.paystack,
                          title: 'Use Paystack',
                          caption: '1.5% + ${Money(100).formatted}',
                        ),
                        ScaledBox.horizontal(24),
                        _MethodItemBox(
                          onPressed: () {},
                          image: AppImages.rave,
                          title: 'Use Rave',
                          caption: '1.4%',
                        ),
                      ],
                    ),
                    ScaledBox.vertical(16),
                    TouchableOpacity(
                      onPressed: onDismiss,
                      color: AppColors.dark,
                      child: Text('Cancel'),
                    ),
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

class _MethodItemBox extends StatelessWidget {
  const _MethodItemBox({
    Key key,
    @required this.onPressed,
    @required this.image,
    @required this.title,
    @required this.caption,
  }) : super(key: key);

  final VoidCallback onPressed;
  final ImageProvider image;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = Size.square(context.scaleY(124.0));

    return TouchableOpacity(
      onPressed: () {},
      pressedOpacity: .75,
      child: Container(
        decoration: const ShadowBoxDecoration(),
        constraints: BoxConstraints.tight(size),
        padding: EdgeInsets.all(8).scale(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.fromSize(
              size: size * .5,
              child: Image(image: image, fit: BoxFit.scaleDown),
            ),
            ScaledBox.vertical(4),
            Text(title, style: theme.subhead2.medium.dark),
            ScaledBox.vertical(1),
            Text(caption, style: theme.small),
          ],
        ),
      ),
    );
  }
}
