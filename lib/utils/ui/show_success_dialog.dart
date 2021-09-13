import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

import '../../extensions.dart';
import 'app_status_bar.dart';

void showSuccessDialog(
  BuildContext context, {
  @required String title,
  @required String caption,
  @required VoidCallback onDismiss,
  SuccessDialogStyle style = SuccessDialogStyle.primary,
}) async {
  await HapticFeedback.vibrate();
  await showDialog<void>(
    context: context,
    useSafeArea: false,
    builder: (_) => _Dialog(
      title: title,
      caption: caption,
      onDismiss: onDismiss,
      style: style,
    ),
  );
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    Key key,
    @required this.title,
    @required this.caption,
    @required this.onDismiss,
    @required this.style,
  }) : super(key: key);

  final String title;
  final String caption;
  final VoidCallback onDismiss;
  final SuccessDialogStyle style;

  @override
  Widget build(BuildContext context) {
    return AppStatusBar(
      brightness: Brightness.light,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: style.backgroundColor,
              child: Opacity(opacity: .2, child: Image(image: AppImages.splash, fit: BoxFit.fill)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, style.backgroundColor.withOpacity(.15), style.backgroundColor],
                  begin: Alignment.bottomCenter,
                  end: const Alignment(0.0, -.5),
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
                    Image(height: context.scaleY(181), image: AppImages.successCheck),
                    ScaledBox.vertical(36),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.theme.display2.bold.copyWith(color: style.textColor),
                    ),
                    ScaledBox.vertical(16),
                    Expanded(
                      child: Text(
                        caption,
                        textAlign: TextAlign.center,
                        style: context.theme.subhead3.copyWith(color: style.captionColor),
                      ),
                    ),
                    FilledButton(
                      onPressed: onDismiss,
                      backgroundColor: style.buttonBackgroundColor,
                      color: style.buttonColor,
                      child: Text("Dismiss"),
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

enum SuccessDialogStyle {
  primary,
  light,
}

extension SuccessDialogStyleX on SuccessDialogStyle {
  Color get backgroundColor {
    return {
      SuccessDialogStyle.primary: AppColors.primaryDark,
      SuccessDialogStyle.light: AppColors.white,
    }[this];
  }

  Color get textColor {
    return {
      SuccessDialogStyle.primary: Colors.white,
      SuccessDialogStyle.light: AppColors.dark,
    }[this];
  }

  Color get captionColor {
    return {
      SuccessDialogStyle.primary: Colors.white,
      SuccessDialogStyle.light: AppColors.dark.shade700,
    }[this];
  }

  Color get buttonColor {
    return {
      SuccessDialogStyle.primary: AppColors.primary,
      SuccessDialogStyle.light: Colors.white,
    }[this];
  }

  Color get buttonBackgroundColor {
    return {
      SuccessDialogStyle.primary: Colors.white,
      SuccessDialogStyle.light: AppColors.primary,
    }[this];
  }
}
