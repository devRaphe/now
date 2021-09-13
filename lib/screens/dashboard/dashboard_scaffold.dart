import 'package:borome/constants.dart';
import 'package:flutter/material.dart';

enum _LayoutSlot {
  body,
  fab,
  bottom,
  ad,
  background,
}

class DashboardScaffold extends StatefulWidget {
  const DashboardScaffold({
    Key key,
    @required this.backgroundColor,
    @required this.body,
    @required this.fab,
    @required this.bottom,
    @required this.ad,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget body;
  final PreferredSizeWidget fab;
  final PreferredSizeWidget bottom;
  final PreferredSizeWidget ad;

  @override
  DashboardScaffoldState createState() => DashboardScaffoldState();
}

class DashboardScaffoldState extends State<DashboardScaffold> {
  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);

    return Material(
      child: CustomMultiChildLayout(
        delegate: _DashboardScaffoldDelegate(
          viewInsets: queryData.viewInsets,
          bottomHeight: widget.bottom.preferredSize.height + queryData.padding.bottom,
          fabSize: widget.fab?.preferredSize ?? Size.zero,
          adHeight: widget.ad?.preferredSize?.height ?? 0.0,
        ),
        children: <Widget>[
          LayoutId(
            id: _LayoutSlot.background,
            child: Material(
              color: widget.backgroundColor ?? Colors.white,
              child: Opacity(opacity: .2, child: Image(image: AppImages.splash, fit: BoxFit.fill)),
            ),
          ),
          LayoutId(id: _LayoutSlot.body, child: widget.body),
          LayoutId(id: _LayoutSlot.bottom, child: widget.bottom),
          if (widget.fab != null) LayoutId(id: _LayoutSlot.fab, child: widget.fab),
          if (widget.ad != null) LayoutId(id: _LayoutSlot.ad, child: IgnorePointer(child: widget.ad)),
        ],
      ),
    );
  }
}

class _DashboardScaffoldDelegate extends MultiChildLayoutDelegate {
  _DashboardScaffoldDelegate({
    @required this.viewInsets,
    @required this.bottomHeight,
    @required this.adHeight,
    @required this.fabSize,
  });

  final EdgeInsets viewInsets;
  final double bottomHeight;
  final double adHeight;
  final Size fabSize;

  @override
  void performLayout(Size size) {
    final constraints = BoxConstraints.loose(size);
    final fullConstraints = constraints.tighten(width: size.width);

    layoutChild(_LayoutSlot.background, fullConstraints);
    positionChild(_LayoutSlot.background, Offset.zero);

    final bodyConstraints = fullConstraints.copyWith(
      maxHeight: constraints.maxHeight - bottomHeight / 2 - viewInsets.bottom,
    );
    layoutChild(_LayoutSlot.body, bodyConstraints);
    positionChild(_LayoutSlot.body, Offset.zero);

    layoutChild(_LayoutSlot.bottom, BoxConstraints.tight(Size(size.width, bottomHeight)));
    positionChild(_LayoutSlot.bottom, Offset(0, constraints.maxHeight - bottomHeight));

    final fabOffset = Offset(
      constraints.maxWidth / 2 - fabSize.width / 2,
      constraints.maxHeight - bottomHeight - 16,
    );
    if (hasChild(_LayoutSlot.fab)) {
      layoutChild(_LayoutSlot.fab, BoxConstraints.tight(Size.square(fabSize.longestSide)));
      positionChild(_LayoutSlot.fab, fabOffset);
    }

    if (hasChild(_LayoutSlot.ad)) {
      layoutChild(_LayoutSlot.ad, BoxConstraints.tight(Size(size.width, adHeight)));
      positionChild(_LayoutSlot.ad, Offset(0, fabOffset.dy - adHeight - 12));
    }
  }

  @override
  bool shouldRelayout(_DashboardScaffoldDelegate oldDelegate) =>
      viewInsets != oldDelegate.viewInsets ||
      fabSize != oldDelegate.fabSize ||
      bottomHeight != oldDelegate.bottomHeight;
}
