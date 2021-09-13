import 'dart:math' as math;

import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    Key key,
    @required this.title,
    this.primary = false,
    this.automaticallyImplyLeading = true,
    this.brightness = Brightness.dark,
    this.leading,
    this.trailing,
    this.isLoading = false,
  }) : super(key: key);

  final Widget title;
  final bool primary;
  final Widget leading;
  final bool automaticallyImplyLeading;
  final bool isLoading;
  final Brightness brightness;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final paddingTop = primary ? MediaQuery.of(context).padding.top : 0.0;
    const persistentHeight = kToolbarHeight;
    final minExtent = kToolbarHeight + paddingTop;
    final maxExtent = minExtent + persistentHeight;

    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget leadingWidget = leading;
    if (leading == null && automaticallyImplyLeading) {
      leadingWidget = useCloseButton ? const AppCloseButton() : const AppBackButton();
    }

    final titleSpace = context.scale(leadingWidget != null ? 8.0 : 24.0);

    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverPersistentHeaderDelegate(
        minExtent: minExtent,
        maxExtent: maxExtent,
        builder: (BuildContext context, double shrinkOffset, bool overlapsContent, bool isAtTop) {
          final flexibleMaxExtent = maxExtent - persistentHeight;
          final currentExtent = math.max(paddingTop, flexibleMaxExtent - shrinkOffset);
          final offset = interpolate(inputMin: paddingTop, inputMax: flexibleMaxExtent)(currentExtent);

          final _title = AlignTransition(
            alignment: AlignmentTween(begin: Alignment(-.75, 0), end: Alignment(-1, 0)).animate(parentRoute.animation),
            child: DefaultTextStyle(
              child: title,
              style: ThemeProvider.of(context).display1.copyWith(fontWeight: AppStyle.bold, color: AppColors.primary),
            ),
          );

          return AppStatusBar(
            brightness: brightness,
            child: SizedBox.expand(
              child: Material(
                color: Color.lerp(Colors.white, Colors.white10, offset),
                child: Column(
                  children: <Widget>[
                    SizedBox.fromSize(
                      size: Size.fromHeight(minExtent),
                      child: Padding(
                        padding: EdgeInsets.only(top: paddingTop),
                        child: Row(
                          children: <Widget>[
                            if (leadingWidget != null) ...[
                              ScaledBox.horizontal(8),
                              leadingWidget,
                            ],
                            ScaledBox.horizontal(titleSpace),
                            Expanded(child: Opacity(opacity: 1 - offset, child: _title)),
                            if (trailing != null) ...[
                              trailing,
                              ScaledBox.horizontal(12),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: FlexibleSpaceBar.createSettings(
                        maxExtent: flexibleMaxExtent,
                        minExtent: paddingTop,
                        toolbarOpacity: offset,
                        currentExtent: currentExtent,
                        child: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(left: 24, bottom: 8),
                          title: _title,
                          centerTitle: false,
                        ),
                      ),
                    ),
                    if (isLoading) LoadingSpinner.linear(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
