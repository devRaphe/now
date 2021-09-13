import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:flutter/material.dart';

enum _LayoutSlot {
  body,
  appBar,
  background,
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    Key key,
    @required this.body,
    this.backgroundColor,
    this.appBar,
    this.padding,
  }) : super(key: key);

  final PreferredSizeWidget appBar;
  final Widget body;
  final Color backgroundColor;
  final EdgeInsets padding;

  @override
  AppScaffoldState createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    final systemPadding = queryData.padding;
    final appBarHeight = widget.appBar != null ? widget.appBar.preferredSize.height + systemPadding.top : 0.0;

    return Material(
      child: CustomMultiChildLayout(
        delegate: _AppScaffoldDelegate(viewInsets: queryData.viewInsets),
        children: <Widget>[
          LayoutId(
            id: _LayoutSlot.background,
            child: Material(
              color: widget.backgroundColor ?? Colors.white,
              child: Opacity(opacity: .2, child: Image(image: AppImages.splash, fit: BoxFit.fill)),
            ),
          ),
          LayoutId(
            id: _LayoutSlot.body,
            child: Material(
              type: MaterialType.transparency,
              child: MediaQuery(
                data: queryData.removePadding(removeTop: widget.appBar != null),
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.fromLTRB(38, 0, 38, systemPadding.bottom).scale(context),
                  child: widget.body,
                ),
              ),
            ),
          ),
          if (widget.appBar != null)
            LayoutId(
              id: _LayoutSlot.appBar,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: appBarHeight),
                child: FlexibleSpaceBar.createSettings(
                  currentExtent: appBarHeight,
                  child: MediaQuery(
                    data: queryData.removePadding(removeBottom: true),
                    child: widget.appBar,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AppScaffoldDelegate extends MultiChildLayoutDelegate {
  _AppScaffoldDelegate({this.viewInsets});

  final EdgeInsets viewInsets;

  @override
  void performLayout(Size size) {
    final looseConstraints = BoxConstraints.loose(size);
    final fullWidthConstraints = looseConstraints.tighten(width: size.width);

    layoutChild(_LayoutSlot.background, fullWidthConstraints);
    positionChild(_LayoutSlot.background, Offset.zero);

    double appBarHeight = 0.0;
    if (hasChild(_LayoutSlot.appBar)) {
      appBarHeight = layoutChild(_LayoutSlot.appBar, fullWidthConstraints).height;
      positionChild(_LayoutSlot.appBar, Offset.zero);
    }

    final bodyConstraints = fullWidthConstraints.copyWith(
      maxHeight: fullWidthConstraints.maxHeight - appBarHeight - viewInsets.bottom,
    );
    layoutChild(_LayoutSlot.body, bodyConstraints);
    positionChild(_LayoutSlot.body, Offset(0, appBarHeight));
  }

  @override
  bool shouldRelayout(_AppScaffoldDelegate oldDelegate) => viewInsets != oldDelegate.viewInsets;
}
