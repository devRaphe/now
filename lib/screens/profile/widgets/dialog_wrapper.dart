import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class DialogWrapper extends StatelessWidget {
  const DialogWrapper({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: kToolbarHeight,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .9,
            maxHeight: context.scale(540),
          ),
          child: KeyboardDismissible(
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 4).scale(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const ScaledBox.vertical(4),
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          height: kToolbarHeight,
                          child: Center(
                            child: Text(
                              title,
                              style: theme.display1.copyWith(fontWeight: AppStyle.semibold, color: AppColors.dark),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          left: null,
                          child: AppCloseButton(),
                        ),
                      ],
                    ),
                    const ScaledBox.vertical(32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12).scale(context),
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
